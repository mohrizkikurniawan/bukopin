*-----------------------------------------------------------------------------
* <Rating>559</Rating>
* 15:41:10 07 OCT 2016 * 15:36:31 07 OCT 2016 * 11:54:20 04 OCT 2016 * 10:58:08 04 OCT 2016 * 10:29:18 04 OCT 2016 * 17:35:20 03 OCT 2016 * 16:24:00 19 OCT 2016 * 15:08:15 18 OCT 2016 * 18:30:20 17 OCT 2016 * 18:16:20 17 OCT 2016 
* WIN-KVUAVRB60BE/R14 * WIN-KVUAVRB60BE/R14 * CBS-APP1-JKT/t24sit * CBS-APP1-JKT/t24sit * CBS-APP1-JKT/t24sit * CBS-APP1-JKT/t24sit * CBS-APP1-JKT/t24sit * CBS-APP1-JKT/t24sit * CBS-APP1-JKT/t24sit * CBS-APP1-JKT/t24sit 
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.BM.EXT.REPORT(Y.ID)
*-----------------------------------------------------------------------------
* Developer Name     : Dwi K
* Development Date   : 20150917
* Description        : Extract Report
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date            Modified by                Description
*-----------------------------------------------------------------------------
* 20150925        Novi Leo                   Add logic for link which use local field
* 20160620        Dwi K                      Add function to splitted data
* 20160726        Dwi K                      Add function to convert character delimeter to space in data output
* 20161017        FAR                        Add logic for SS sys field type J
*                                            Remove . char from unique time generated for id temp textfile
* 20161104        Dwi K                      Add function to generate data delta
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ATI.TH.EXT.REPORT
    $INSERT I_F.LOCKING
    $INSERT I_BATCH.FILES
    $INSERT I_TSA.COMMON
    $INSERT I_ATI.BM.EXT.REPORT.COMMON
    $INSERT I_F.STANDARD.SELECTION

*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------
    GOSUB INIT
    GOSUB PROCESS

    RETURN

*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
    Y.ID.EXT.REP = CONTROL.LIST<1,1>
    GOSUB GET.DATA.EXT.REP

    BEGIN CASE
    CASE Y.TABLES.TYPE EQ "" OR Y.TABLES.TYPE EQ "LIVE"
        FN.APP = 'F.':Y.APPLICATION
        CALL OPF(FN.APP,F.APP)
    CASE Y.TABLES.TYPE EQ "$HIS"
        FN.APP = 'F.':Y.APPLICATION:'$HIS'
        CALL OPF(FN.APP,F.APP)
    CASE Y.TABLES.TYPE EQ "$NAU"
        FN.APP = 'F.':Y.APPLICATION:'$NAU'
        CALL OPF(FN.APP,F.APP)
    END CASE

    FN.EXT.TEMP = 'F.ATI.EXT.REP.':Y.ID.EXT.REP:'.TEMP'
    F.EXT.TEMP  = ''
    CALL OPF(FN.EXT.TEMP,F.EXT.TEMP)

    FN.EXT.DATA = 'F.ATI.EXT.REP.':Y.ID.EXT.REP:'.DATA'
    F.EXT.DATA  = ''
    CALL OPF(FN.EXT.DATA,F.EXT.DATA)

    CALL GET.STANDARD.SELECTION.DETS(Y.APPLICATION,R.SS)

    Y.FLD.LBL.ARRAY    = ""
    Y.FLD.VALUE.ARRAY  = ""
    Y.OUTPUT.REC       = ""

    RETURN

*-----------------------------------------------------------------------------
GET.DATA.EXT.REP:
*-----------------------------------------------------------------------------
    CALL F.READ(FN.EXT.REPORT,Y.ID.EXT.REP,R.EXT.REPORT,F.EXT.REPORT,REP.ERR)
    Y.APPLICATION       = R.EXT.REPORT<EXT.REP.APPLICATION>
    Y.FLD.LBL           = R.EXT.REPORT<EXT.REP.FLD.LABEL>
    Y.FLD.EXT           = R.EXT.REPORT<EXT.REP.FLD.EXT>
    Y.FLD.FUNCT         = R.EXT.REPORT<EXT.REP.FLD.FUNCT>
    Y.FLD.ATTRIB        = R.EXT.REPORT<EXT.REP.FLD.ATTRIB>
    Y.SEPARATOR.FM      = R.EXT.REPORT<EXT.REP.SEPARATOR.FM>
    Y.SEPARATOR.VM      = R.EXT.REPORT<EXT.REP.SEPARATOR.VM>
    Y.SEPARATOR.SM      = R.EXT.REPORT<EXT.REP.SEPARATOR.SM>
    Y.SPLIT.FILE        = R.EXT.REPORT<EXT.REP.SPLIT.FILE>
    Y.TABLES.TYPE       = R.EXT.REPORT<EXT.REP.TABLES.TYPE>
    Y.DELIMETER.REPLACE = R.EXT.REPORT<EXT.REP.DELIMETER.REPLACE>
    Y.DELTA.FLAG        = R.EXT.REPORT<EXT.REP.DELTA.FLAG>

    IF Y.SPLIT.FILE EQ 'YES' THEN
        Y.SPLIT.MAX.REC = R.EXT.REPORT<EXT.REP.SPLIT.MAX.REC>
    END ELSE
        Y.SPLIT.MAX.REC = 500
    END

    RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    CALL F.READ(FN.APP, Y.ID, R.APP, F.APP, APP.ERR)

    Y.CNT.FLD = DCOUNT(Y.FLD.EXT,VM)

    FOR Y.FLD = 1 TO Y.CNT.FLD
        Y.LABEL.FIELD   = Y.FLD.LBL<1,Y.FLD>
        Y.CURRENT.FIELD = Y.FLD.EXT<1,Y.FLD>

        Y.LT.FIELD.NAME.NO = ""
        Y.LT.FIELD.POS     = ""
        Y.FIELD.VALUE      = ""
        Y.FIELD.VALUE.VM   = ""
        Y.FIELD.VALUE.SM   = ""

        Y.FLAG.FLD    = 1
        Y.FLAG.HIDDEN = ""
        Y.CNT.VM      = ""
        Y.CNT.SM      = ""
        Y.FLD.VM      = ""
        Y.FLD.SM      = ""

        BEGIN CASE
        CASE Y.CURRENT.FIELD EQ "@ID"
            Y.FIELD.VALUE = Y.ID
            GOSUB GET.FUNCTION
        CASE Y.CURRENT.FIELD EQ ""
            GOSUB GET.FUNCTION
        CASE OTHERWISE
            GOSUB GET.FIELD.VALUE
            GOSUB CHECK.FIELDS
        END CASE

        GOSUB GET.OUTPUT

        Y.FLD.LBL.ARRAY  <-1>= Y.LABEL.FIELD
        Y.FLD.VALUE.ARRAY<-1>= Y.FIELD.VALUE

    NEXT Y.FLD

    GOSUB WRITE.TEMP

    RETURN

*-----------------------------------------------------------------------------
GET.FIELD.VALUE:
*-----------------------------------------------------------------------------
    CALL FIELD.NAMES.TO.NUMBERS(Y.CURRENT.FIELD, R.SS, Y.CURRENT.FIELD.POS, "", "", "", "", "")

    IF Y.CURRENT.FIELD.POS THEN
        Y.FIELD.VALUE = R.APP<Y.CURRENT.FIELD.POS>
    END
*--Get Value Local Ref-----
    ELSE
        CALL FIELD.NAMES.TO.NUMBERS("LOCAL.REF", R.SS, Y.CURRENT.FIELD.POS, YAF, YAV, YAS, Y.DATA.TYPE, Y.ERR.MSG)
        CALL GET.LOC.REF(Y.APPLICATION, Y.CURRENT.FIELD, Y.LT.FIELD.POS)

*/20161017 - far
*        Y.FIELD.VALUE = R.APP<Y.CURRENT.FIELD.POS, Y.LT.FIELD.POS>
        IF Y.LT.FIELD.POS EQ '' THEN
            LOCATE Y.CURRENT.FIELD IN R.SS<SSL.SYS.FIELD.NAME,1> SETTING Y.SYS.POS THEN
                IF R.SS<SSL.SYS.TYPE, Y.SYS.POS> EQ "J" THEN
                    Y.FIELD.REF = FIELD(R.SS<SSL.SYS.FIELD.NO, Y.SYS.POS, 1>, ">", 1)
                    Y.TABLE.REF = FIELD(R.SS<SSL.SYS.FIELD.NO, Y.SYS.POS, 1>, ">", 2)
                    Y.VALUE.REF = FIELD(R.SS<SSL.SYS.FIELD.NO, Y.SYS.POS, 1>, ">", 3)

                    CALL FIELD.NAMES.TO.NUMBERS(Y.FIELD.REF, R.SS, Y.CURRENT.FIELD.POS, "", "", "", "", "")
                    Y.RECORD = R.APP<Y.CURRENT.FIELD.POS>

                    FN.REF.TEMP = "F." : Y.TABLE.REF
                    F.REF.TEMP  = ""
                    CALL OPF(FN.REF.TEMP, F.REF.TEMP)

                    Y.APPLICATION.TEMP1 = Y.TABLE.REF
                    CALL GET.STANDARD.SELECTION.DETS(Y.APPLICATION.TEMP1, R.SS.TEMP1)
                    CALL FIELD.NAMES.TO.NUMBERS(Y.VALUE.REF, R.SS.TEMP1, Y.REF.FIELD.POS, "", "", "", "", "")

                    CALL F.READ(FN.REF.TEMP, Y.RECORD, R.REF.TEMP, F.REF.TEMP, REF.TEMP.ERR)
                    Y.FIELD.VALUE = R.REF.TEMP<Y.REF.FIELD.POS>
                END
            END ELSE
                Y.FIELD.VALUE = ''
            END
        END ELSE
            Y.FIELD.VALUE = R.APP<Y.CURRENT.FIELD.POS, Y.LT.FIELD.POS>
        END
*/20161017 - far

    END

    RETURN

*-----------------------------------------------------------------------------
CHECK.FIELDS:
*-----------------------------------------------------------------------------
    Y.CNT.VM = DCOUNT(Y.FIELD.VALUE,VM)
    Y.CNT.SM = DCOUNT(Y.FIELD.VALUE,SM)

    Y.SAVE.FIELD.VAL = Y.FIELD.VALUE

    Y.FLAG.FUNCT.FIELD = ""
    GOSUB CHECK.FUNCT.FIELD

    BEGIN CASE
    CASE Y.FLAG.FUNCT.FIELD EQ 1
        GOSUB GET.FUNCTION
    CASE Y.CNT.VM GT 1
        GOSUB GET.MULTIVALUE
        Y.FIELD.VALUE = Y.FIELD.VALUE.VM
    CASE Y.CNT.SM GT 1
        GOSUB GET.SUBVALUE
        Y.FIELD.VALUE = Y.FIELD.VALUE.SM
    CASE 1
        GOSUB GET.FUNCTION
    END CASE

    RETURN

*-----------------------------------------------------------------------------
CHECK.FUNCT.FIELD:
*-----------------------------------------------------------------------------
    Y.CURRENT.FUNCT  = Y.FLD.FUNCT<1,Y.FLD,1>
    Y.CURRENT.ATTRIB = Y.FLD.ATTRIB<1,Y.FLD,1>
    IF Y.CURRENT.FUNCT NE "" THEN
        IF Y.CURRENT.FUNCT EQ 'FIELD' THEN
            Y.DELIM.VALUE = FIELD(Y.CURRENT.ATTRIB,',',1)
            IF (Y.DELIM.VALUE EQ '@VM') OR (Y.DELIM.VALUE EQ '@SM') THEN
                Y.FLAG.FUNCT.FIELD = 1
            END
        END
    END

    RETURN

*-----------------------------------------------------------------------------
GET.MULTIVALUE:
*-----------------------------------------------------------------------------
    Y.FIELD.VALUE.VM = ""
    FOR Y.FLD.VM = 1 TO Y.CNT.VM
        Y.FIELD.VALUE = Y.SAVE.FIELD.VAL<1, Y.FLD.VM>

        IF Y.FLAG.FLD EQ 1 THEN
            GOSUB GET.FUNCTION
        END ELSE
            GOSUB GET.FMT.FIELD
        END

        Y.FIELD.VALUE.VM<1,-1>  = Y.FIELD.VALUE
    NEXT Y.FLD.VM

    RETURN

*-----------------------------------------------------------------------------
GET.SUBVALUE:
*-----------------------------------------------------------------------------
    Y.FIELD.VALUE.SM = ""
    FOR Y.FLD.SM = 1 TO Y.CNT.SM
        Y.FIELD.VALUE = Y.SAVE.FIELD.VAL<1,1,Y.FLD.SM>

        IF Y.FLAG.FLD EQ 1 THEN
            GOSUB GET.FUNCTION
        END ELSE
            GOSUB GET.FMT.FIELD
        END

        Y.FIELD.VALUE.SM<1,1,-1> = Y.FIELD.VALUE
    NEXT Y.FLD.SM

    RETURN

*-----------------------------------------------------------------------------
GET.FUNCTION:
*-----------------------------------------------------------------------------
    IF Y.FLD.FUNCT NE "" THEN
        Y.CNT.FUNCT = DCOUNT(Y.FLD.FUNCT<1,Y.FLD>,SM)

        Y.SAVE.CNT.VM          = Y.CNT.VM
        Y.SAVE.CNT.SM          = Y.CNT.SM
        Y.SAVE.FLD.VM          = Y.FLD.VM
        Y.SAVE.FLD.SM          = Y.FLD.SM
        Y.SAVE.FIELD.VAL.FUNCT = Y.SAVE.FIELD.VAL

        FOR Y.FUNCT = 1 TO Y.CNT.FUNCT
            Y.CURRENT.FUNCT  = Y.FLD.FUNCT<1,Y.FLD,Y.FUNCT>
            Y.CURRENT.ATTRIB = Y.FLD.ATTRIB<1,Y.FLD,Y.FUNCT>
            IF Y.CURRENT.FUNCT NE "" THEN
                Y.FLAG.FLD = ""
                IF Y.CURRENT.FUNCT EQ 'FIELD' THEN
                    Y.DELIM.VALUE = FIELD(Y.CURRENT.ATTRIB,',',1)
                    IF (Y.DELIM.VALUE EQ '@VM') OR (Y.DELIM.VALUE EQ '@SM') THEN
                        GOSUB GET.FMT.FIELD
                    END ELSE
                        GOSUB CHECK.FIELD.VALUE
                    END
                END ELSE
                    GOSUB CHECK.FIELD.VALUE
                END
            END
        NEXT Y.FUNCT

        Y.CNT.VM         = Y.SAVE.CNT.VM
        Y.CNT.SM         = Y.SAVE.CNT.SM
        Y.FLD.VM         = Y.SAVE.FLD.VM
        Y.FLD.SM         = Y.SAVE.FLD.SM
        Y.SAVE.FIELD.VAL = Y.SAVE.FIELD.VAL.FUNCT

    END

    RETURN

*-----------------------------------------------------------------------------
CHECK.FIELD.VALUE:
*-----------------------------------------------------------------------------
    Y.CNT.VM = DCOUNT(Y.FIELD.VALUE,VM)
    Y.CNT.SM = DCOUNT(Y.FIELD.VALUE,SM)

    Y.SAVE.FIELD.VAL = Y.FIELD.VALUE

    BEGIN CASE
    CASE Y.CNT.VM GT 1
        GOSUB GET.MULTIVALUE
        Y.FIELD.VALUE = Y.FIELD.VALUE.VM
    CASE Y.CNT.SM GT 1
        GOSUB GET.SUBVALUE
        Y.FIELD.VALUE = Y.FIELD.VALUE.SM
    CASE 1
        GOSUB GET.FMT.FIELD
    END CASE

    RETURN

*-----------------------------------------------------------------------------
GET.FMT.FIELD:
*-----------------------------------------------------------------------------
    IF Y.CURRENT.FUNCT NE "" THEN
        BEGIN CASE
        CASE Y.CURRENT.FUNCT EQ "LINK"
            GOSUB FUNCT.LINK

        CASE Y.CURRENT.FUNCT EQ "PRG"
            CALL @Y.CURRENT.ATTRIB(Y.FIELD.VALUE)

        CASE Y.CURRENT.FUNCT EQ "FIXED"
            Y.FIELD.VALUE = Y.CURRENT.ATTRIB

        CASE Y.CURRENT.FUNCT EQ "CONCATE"
            GOSUB FUNCT.CONCATE

        CASE Y.CURRENT.FUNCT EQ "SUBSTRINGS"
            Y.FIELD.VALUE = SUBSTRINGS(Y.FIELD.VALUE, FIELD(Y.CURRENT.ATTRIB,",",1), FIELD(Y.CURRENT.ATTRIB,",",2))

        CASE Y.CURRENT.FUNCT EQ "TRIM"
            Y.FIELD.VALUE = TRIM(Y.FIELD.VALUE, FIELD(Y.CURRENT.ATTRIB,",",1), FIELD(Y.CURRENT.ATTRIB,",",2))

        CASE Y.CURRENT.FUNCT EQ "FIELD"
            GOSUB FUNCT.FIELD

        CASE Y.CURRENT.FUNCT EQ "FMT"
            Y.FIELD.VALUE = FMT(Y.FIELD.VALUE,Y.CURRENT.ATTRIB)

        CASE Y.CURRENT.FUNCT EQ "ICONV"
            Y.FIELD.VALUE = ICONV(Y.FIELD.VALUE,Y.CURRENT.ATTRIB)

        CASE Y.CURRENT.FUNCT EQ "OCONV"
            Y.FIELD.VALUE = OCONV(Y.FIELD.VALUE,Y.CURRENT.ATTRIB)

        CASE Y.CURRENT.FUNCT EQ "DROUND"
            Y.FIELD.VALUE = DROUND(Y.FIELD.VALUE,Y.CURRENT.ATTRIB)

        CASE Y.CURRENT.FUNCT EQ "COMMON"
            GOSUB FUNCT.COMMON

        CASE Y.CURRENT.FUNCT EQ "FIELD.VALUE"
            GOSUB FUNCT.FLD.VALUE

        CASE Y.CURRENT.FUNCT EQ "READ.HISTORY"
            GOSUB FUNCT.READ.HISTORY

        CASE Y.CURRENT.FUNCT EQ "ARITHMETIC"
            GOSUB FUNCT.ARITHMETIC

        CASE Y.CURRENT.FUNCT EQ "CONDITION"
            GOSUB FUNCT.CONDITION

        CASE Y.CURRENT.FUNCT EQ "HIDDEN"
            Y.FLAG.HIDDEN = 1

        END CASE
    END

    RETURN

*-----------------------------------------------------------------------------
FUNCT.LINK:
*-----------------------------------------------------------------------------
    Y.APPLICATION.LINK = FIELD(Y.CURRENT.ATTRIB,">",1)
    Y.FLD.LINK = FIELD(Y.CURRENT.ATTRIB,">",2)

    FN.APP.LINK = "F.":Y.APPLICATION.LINK
    F.APP.LINK  = ""
    CALL OPF(FN.APP.LINK,F.APP.LINK)

    CALL F.READ(Y.APPLICATION.LINK, Y.FIELD.VALUE, R.APP.LINK, F.APP.LINK, APP.LINK.ERR)

    CALL GET.STANDARD.SELECTION.DETS(Y.APPLICATION.LINK, R.LINK.SS)

    Y.APPLICATION.TEMP   = Y.APPLICATION
    R.SS.TEMP            = R.SS
    R.APP.TEMP           = R.APP
    Y.CURRENT.FIELD.TEMP = Y.CURRENT.FIELD

    Y.APPLICATION   = Y.APPLICATION.LINK
    R.SS            = R.LINK.SS
    R.APP           = R.APP.LINK
    Y.CURRENT.FIELD = Y.FLD.LINK

    GOSUB GET.FIELD.VALUE

    Y.APPLICATION   = Y.APPLICATION.TEMP
    R.SS            = R.SS.TEMP
    R.APP           = R.APP.TEMP
    Y.CURRENT.FIELD = Y.CURRENT.FIELD.TEMP

    RETURN

*-----------------------------------------------------------------------------
FUNCT.CONCATE:
*-----------------------------------------------------------------------------
    Y.CNT.DELIM = DCOUNT(Y.CURRENT.ATTRIB,",")

    FOR Y.L = 1 TO Y.CNT.DELIM
        Y.LBL = FIELD(Y.CURRENT.ATTRIB,",",Y.L)

        FIND Y.LBL IN Y.FLD.LBL.ARRAY SETTING Y.POSF THEN
            Y.FIELD.VALUE := Y.FLD.VALUE.ARRAY<Y.POSF>
        END ELSE
            Y.FIELD.VALUE := Y.CURRENT.ATTRIB
        END

    NEXT Y.L

    RETURN

*-----------------------------------------------------------------------------
FUNCT.FIELD:
*-----------------------------------------------------------------------------
    Y.CNT.DELIM   = DCOUNT(Y.CURRENT.ATTRIB,",")
    Y.DELIM.VALUE = FIELD(Y.CURRENT.ATTRIB,',',1)

    BEGIN CASE
    CASE Y.DELIM.VALUE EQ "VM" OR Y.DELIM.VALUE EQ "@VM"
        Y.DELIM.VALUE = VM
    CASE Y.DELIM.VALUE EQ "SM" OR Y.DELIM.VALUE EQ "@SM"
        Y.DELIM.VALUE = SM
    END CASE


    IF Y.CNT.DELIM EQ 2 THEN
        Y.FIELD.VALUE = FIELD(Y.FIELD.VALUE, Y.DELIM.VALUE, FIELD(Y.CURRENT.ATTRIB,",",2))
    END ELSE
        Y.FIELD.VALUE = FIELD(Y.FIELD.VALUE, Y.DELIM.VALUE, FIELD(Y.CURRENT.ATTRIB,",",2), FIELD(Y.CURRENT.ATTRIB,",",3))
    END

    RETURN

*-----------------------------------------------------------------------------
FUNCT.COMMON:
*-----------------------------------------------------------------------------
    BEGIN CASE
    CASE Y.CURRENT.ATTRIB EQ "TODAY"
        Y.FIELD.VALUE = TODAY
    CASE Y.CURRENT.ATTRIB EQ "ID.COMPANY"
        Y.FIELD.VALUE = ID.COMPANY
    CASE Y.CURRENT.ATTRIB EQ "USER"
        Y.FIELD.VALUE = OPERATOR
    CASE Y.CURRENT.ATTRIB EQ "DATE"
        Y.FIELD.VALUE = DATE()
    CASE Y.CURRENT.ATTRIB EQ "TIME"
        Y.FIELD.VALUE = TIME()
    END CASE

    RETURN

*-----------------------------------------------------------------------------
FUNCT.FLD.VALUE:
*-----------------------------------------------------------------------------
    Y.LBL  = Y.CURRENT.ATTRIB

    FIND Y.LBL IN Y.FLD.LBL.ARRAY SETTING Y.POSF THEN
        Y.FIELD.VALUE = Y.FLD.VALUE.ARRAY<Y.POSF>
    END

    RETURN

*-----------------------------------------------------------------------------
FUNCT.READ.HISTORY:
*-----------------------------------------------------------------------------
    Y.APPLICATION.HIS = FIELD(Y.CURRENT.ATTRIB,">",1)
    Y.FLD.HIS = FIELD(Y.CURRENT.ATTRIB,">",2)
    Y.OUT.FLD = ""

    FN.APP.HIS = "F.":Y.APPLICATION.HIS:"$HIS"
    F.APP.HIS  = ""
    CALL OPF(FN.APP.HIS,F.APP.HIS)

    CALL F.READ.HISTORY(FN.APP.HIS, Y.FIELD.VALUE, R.APP.HIS, F.APP.HIS, APP.HIS.ERR)

    CALL GET.STANDARD.SELECTION.DETS(Y.APPLICATION.HIS, R.HIS.SS)

    Y.APPLICATION.TEMP   = Y.APPLICATION
    R.SS.TEMP            = R.SS
    R.APP.TEMP           = R.APP
    Y.CURRENT.FIELD.TEMP = Y.CURRENT.FIELD

    Y.APPLICATION   = Y.APPLICATION.HIS
    R.SS            = R.HIS.SS
    R.APP           = R.APP.HIS
    Y.CURRENT.FIELD = Y.FLD.HIS

    GOSUB GET.FIELD.VALUE

    Y.APPLICATION   = Y.APPLICATION.TEMP
    R.SS            = R.SS.TEMP
    R.APP           = R.APP.TEMP
    Y.CURRENT.FIELD = Y.CURRENT.FIELD.TEMP

    RETURN
*-----------------------------------------------------------------------------
FUNCT.ARITHMETIC:
*-----------------------------------------------------------------------------
    Y.CNT.DELIM = DCOUNT(Y.CURRENT.ATTRIB," ")
    Y.LAST.VAL  = ''
    Y.VAL       = ''

    FOR Y.M = 1 TO Y.CNT.DELIM STEP 2
        Y.LBL = FIELD(Y.CURRENT.ATTRIB," ",Y.M)
        Y.OP  = FIELD(Y.CURRENT.ATTRIB," ",Y.M-1)

        FIND Y.LBL IN Y.FLD.LBL.ARRAY SETTING Y.POSF THEN
            Y.VAL = Y.FLD.VALUE.ARRAY<Y.POSF>
        END

        IF Y.M GT 1 THEN
            BEGIN CASE
            CASE Y.OP EQ '+'
                Y.LAST.VAL += Y.VAL
            CASE Y.OP EQ '-'
                Y.LAST.VAL -= Y.VAL
            CASE Y.OP EQ '*'
                Y.LAST.VAL *= Y.VAL
            CASE Y.OP EQ '/'
                Y.LAST.VAL /= Y.VAL
            END CASE
        END ELSE
            Y.LAST.VAL = Y.VAL
        END

    NEXT Y.M

    Y.FIELD.VALUE = Y.LAST.VAL

    RETURN
*-----------------------------------------------------------------------------
FUNCT.CONDITION:
*-----------------------------------------------------------------------------
    Y.COND  = FIELD(Y.CURRENT.ATTRIB," ",1)
    Y.OP    = FIELD(Y.CURRENT.ATTRIB," ",2)
    Y.VAL1  = FIELD(Y.CURRENT.ATTRIB," ",3)
    Y.VAL2  = FIELD(Y.CURRENT.ATTRIB," ",4)
    Y.VAL3  = FIELD(Y.CURRENT.ATTRIB," ",5)
    Y.VAL4  = FIELD(Y.CURRENT.ATTRIB," ",6)

    FIND Y.COND IN Y.FLD.LBL.ARRAY SETTING Y.POSF THEN
        Y.FLD.COND = Y.FLD.VALUE.ARRAY<Y.POSF>
    END

    BEGIN CASE
    CASE Y.OP EQ 'EQ'
        GOSUB GET.VAL.CONDITION
        IF Y.FLD.COND EQ Y.VAL1 THEN
            Y.FIELD.VALUE = Y.VAL2
        END ELSE
            Y.FIELD.VALUE = Y.VAL3
        END

    CASE Y.OP EQ 'NE'
        GOSUB GET.VAL.CONDITION
        IF Y.FLD.COND NE Y.VAL1 THEN
            Y.FIELD.VALUE = Y.VAL2
        END ELSE
            Y.FIELD.VALUE = Y.VAL3
        END

    CASE Y.OP EQ 'GT'
        GOSUB GET.VAL.CONDITION
        IF Y.FLD.COND GT Y.VAL1 THEN
            Y.FIELD.VALUE = Y.VAL2
        END ELSE
            Y.FIELD.VALUE = Y.VAL3
        END

    CASE Y.OP EQ 'LT'
        GOSUB GET.VAL.CONDITION
        IF Y.FLD.COND LT Y.VAL1 THEN
            Y.FIELD.VALUE = Y.VAL2
        END ELSE
            Y.FIELD.VALUE = Y.VAL3
        END

    CASE Y.OP EQ 'GE'
        GOSUB GET.VAL.CONDITION
        IF Y.FLD.COND GE Y.VAL1 THEN
            Y.FIELD.VALUE = Y.VAL2
        END ELSE
            Y.FIELD.VALUE = Y.VAL3
        END

    CASE Y.OP EQ 'LE'
        GOSUB GET.VAL.CONDITION
        IF Y.FLD.COND LE Y.VAL1 THEN
            Y.FIELD.VALUE = Y.VAL2
        END ELSE
            Y.FIELD.VALUE = Y.VAL3
        END

    CASE Y.OP EQ 'RG'
        GOSUB GET.VAL.CONDITION
        IF Y.FLD.COND GE Y.VAL1 AND Y.FLD.COND LE Y.VAL2 THEN
            Y.FIELD.VALUE = Y.VAL3
        END ELSE
            Y.FIELD.VALUE = Y.VAL4
        END

    CASE Y.OP EQ 'NR'
        GOSUB GET.VAL.CONDITION
        IF Y.FLD.COND LT Y.VAL1 AND Y.FLD.COND GT Y.VAL2 THEN
            Y.FIELD.VALUE = Y.VAL3
        END ELSE
            Y.FIELD.VALUE = Y.VAL4
        END

    CASE Y.OP EQ 'LK'
        GOSUB GET.VAL.CONDITION
        Y.VAL1.LEN = LEN(Y.VAL1)
        Y.MATCHES  = 0

        BEGIN CASE
        CASE (Y.VAL1[1,3] = '...') AND (Y.VAL1[3] = '...')
            Y.MATCHES = INDEX(Y.FLD.COND,Y.VAL1[4,Y.VAL1.LEN-6],1)
        CASE Y.VAL1[1,3] = '...'
            IF Y.FLD.COND[Y.VAL1.LEN-3] = Y.VAL1[4,Y.VAL1.LEN] THEN
                Y.MATCHES = 1
            END
        CASE Y.VAL1[3] = '...'
            IF Y.FLD.COND[1,Y.VAL1.LEN-3] = Y.VAL1[1,Y.VAL1.LEN-3] THEN
                Y.MATCHES = 1
            END
        END CASE

        IF Y.MATCHES NE 0 THEN
            Y.FIELD.VALUE = Y.VAL2
        END ELSE
            Y.FIELD.VALUE = Y.VAL3
        END

    CASE Y.OP EQ 'UL'
        GOSUB GET.VAL.CONDITION
        Y.VAL1.LEN = LEN(Y.VAL1)
        Y.MATCHES     = 0

        BEGIN CASE
        CASE (Y.VAL1[1,3] = '...') AND (Y.VAL1[3] = '...')
            Y.MATCHES = NOT(INDEX(Y.FLD.COND,Y.VAL1[4,Y.VAL1.LEN-6],1))
        CASE Y.VAL1[1,3] = '...'
            IF Y.FLD.COND[Y.VAL1.LEN-3] <> Y.VAL1[4,Y.VAL1.LEN] THEN
                Y.MATCHES = 1
            END
        CASE Y.VAL1[3] = '...'
            IF Y.FLD.COND[1,Y.VAL1.LEN-3] <> Y.VAL1[1,Y.VAL1.LEN-3] THEN
                Y.MATCHES = 1
            END
        END CASE

        IF Y.MATCHES NE 0 THEN
            Y.FIELD.VALUE = Y.VAL2
        END ELSE
            Y.FIELD.VALUE = Y.VAL3
        END

    END CASE

    RETURN
*-----------------------------------------------------------------------------
GET.VAL.CONDITION:
*-----------------------------------------------------------------------------
    FIND Y.VAL1 IN Y.FLD.LBL.ARRAY SETTING Y.POSF THEN
        Y.VAL1 = Y.FLD.VALUE.ARRAY<Y.POSF>
    END

    FIND Y.VAL2 IN Y.FLD.LBL.ARRAY SETTING Y.POSF THEN
        Y.VAL2 = Y.FLD.VALUE.ARRAY<Y.POSF>
    END

    FIND Y.VAL3 IN Y.FLD.LBL.ARRAY SETTING Y.POSF THEN
        Y.VAL3 = Y.FLD.VALUE.ARRAY<Y.POSF>
    END

    FIND Y.VAL4 IN Y.FLD.LBL.ARRAY SETTING Y.POSF THEN
        Y.VAL4 = Y.FLD.VALUE.ARRAY<Y.POSF>
    END

    RETURN

*-----------------------------------------------------------------------------
GET.OUTPUT:
*-----------------------------------------------------------------------------
    Y.DELIMETER.REPLACE = UPCASE(Y.DELIMETER.REPLACE)

    IF Y.DELIMETER.REPLACE EQ 'SPACE' THEN
        CHANGE Y.SEPARATOR.FM TO ' ' IN Y.FIELD.VALUE
        CHANGE Y.SEPARATOR.VM TO ' ' IN Y.FIELD.VALUE
        CHANGE Y.SEPARATOR.SM TO ' ' IN Y.FIELD.VALUE
    END ELSE
        CHANGE Y.SEPARATOR.FM TO Y.DELIMETER.REPLACE IN Y.FIELD.VALUE
        CHANGE Y.SEPARATOR.VM TO Y.DELIMETER.REPLACE IN Y.FIELD.VALUE
        CHANGE Y.SEPARATOR.SM TO Y.DELIMETER.REPLACE IN Y.FIELD.VALUE
    END

    IF Y.FLAG.HIDDEN EQ "" THEN
        Y.OUTPUT.REC<-1> = Y.FIELD.VALUE

        CHANGE FM TO Y.SEPARATOR.FM IN Y.OUTPUT.REC
        CHANGE VM TO Y.SEPARATOR.VM IN Y.OUTPUT.REC
        CHANGE SM TO Y.SEPARATOR.SM IN Y.OUTPUT.REC
    END

    RETURN
*-----------------------------------------------------------------------------
WRITE.TEMP:
*-----------------------------------------------------------------------------
    CALL F.READ(FN.EXT.TEMP, AGENT.NUMBER, R.EXT.TEMP, F.EXT.TEMP, EXT.TEMP.ERR)
    CALL F.READ(FN.EXT.DATA, Y.ID, R.EXT.DATA, F.EXT.DATA, EXT.DATA.ERR)

    IF Y.DELTA.FLAG EQ 'YES' THEN
        IF R.EXT.DATA NE Y.OUTPUT.REC THEN
            R.EXT.TEMP<-1> = Y.OUTPUT.REC
        END
    END ELSE
        R.EXT.TEMP<-1> = Y.OUTPUT.REC
    END

    R.EXT.DATA = Y.OUTPUT.REC
    CALL F.WRITE(FN.EXT.DATA, Y.ID, R.EXT.DATA)

    CALL F.WRITE(FN.EXT.TEMP, AGENT.NUMBER, R.EXT.TEMP)

    Y.REC.CNT = DCOUNT(R.EXT.TEMP, FM)

    IF Y.REC.CNT GE Y.SPLIT.MAX.REC THEN
        CALL ALLOCATE.UNIQUE.TIME(Y.UNIQUE.TIME)
*/20161017 - far
        Y.UNIQUE.TIME = TRIM(Y.UNIQUE.TIME, ".", "A")
*\20161017 - far
        Y.ID.NEW = AGENT.NUMBER:"-":Y.UNIQUE.TIME

        CALL F.WRITE(FN.EXT.TEMP, Y.ID.NEW, R.EXT.TEMP)
        CALL F.DELETE(FN.EXT.TEMP, AGENT.NUMBER)
    END

    RETURN
*-----------------------------------------------------------------------------
END










