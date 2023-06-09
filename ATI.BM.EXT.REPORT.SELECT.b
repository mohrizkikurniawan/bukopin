*-----------------------------------------------------------------------------
* <Rating>-70</Rating>
* 15:36:17 07 OCT 2016 * 11:53:57 04 OCT 2016 * 17:57:49 03 OCT 2016 * 16:18:41 03 OCT 2016 * 11:33:57 06 SEP 2016 * 11:23:33 06 SEP 2016 * 11:19:30 06 SEP 2016 * 11:17:48 06 SEP 2016 * 11:12:27 06 SEP 2016 * 15:02:45 05 SEP 2016 
* WIN-KVUAVRB60BE/R14 * CBS-APP1-JKT/t24sit * CBS-APP1-JKT/t24sit * CBS-APP1-JKT/t24sit * CBS-APP1-JKT/t24sit * CBS-APP1-JKT/t24sit * CBS-APP1-JKT/t24sit * CBS-APP1-JKT/t24sit * CBS-APP1-JKT/t24sit * CBS-APP1-JKT/t24sit 
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.BM.EXT.REPORT.SELECT
*-----------------------------------------------------------------------------
* Developer Name    : Dwi K
* Development Date  : 20150917
* Description       : Extract Report
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date            Modified by                Description
*-----------------------------------------------------------------------------
* 20160620        Dwi K                      Add function to splitted data
* 20161103        Fatkhur Rohman             Change logic for var common extractor Bank DATE
*                                            Read from DATES table, do not use R.DATES from I_COMMON
* 20171023        Dhio Faizar Wahyudi        Add field and logic extract HEADER to the textfile
* 20200810        Khoirul Rokhim             Add field backup directory
*-----------------------------------------------------------------------------

    $INSERT I_EQUATE
    $INSERT I_COMMON
    $INSERT I_F.LOCKING
    $INSERT I_BATCH.FILES
    $INSERT I_TSA.COMMON
    $INSERT I_F.ATI.TH.EXT.REPORT
    $INSERT I_F.DATES
    $INSERT I_ATI.BM.EXT.REPORT.COMMON

*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------
	
    GOSUB INIT

    RETURN

*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
    CONVERT SM TO FM IN Y.BATCH.DETAILS

    PROCESS.GOAHEAD = ""
    IF CONTROL.LIST EQ "" THEN
        CONTROL.LIST = Y.BATCH.DETAILS :FM: "FINAL.WRITE"
    END
    Y.CONTROL.LIST.FUNCTION = CONTROL.LIST<1,1>

    FN.LOC.DATE = 'F.DATES'
    F.LOC.DATE  = ''
    CALL OPF(FN.LOC.DATE,F.LOC.DATE)

    Y.COMPANY.ID = ID.COMPANY
    CALL F.READ(FN.LOC.DATE,Y.COMPANY.ID,R.LOC.DATE,F.LOC.DATE,LOC.DATE.ERR)

    LIST.PARAM = ""
    SEL.CMD    = ""

    Y.SYS.DATE      = ''
    Y.SYS.DATE      = OCONV(DATE(),"D-")
    Y.LAST.SYS.DATE = Y.SYS.DATE[7,4]:Y.SYS.DATE[1,2]:Y.SYS.DATE[4,2]
    Y.DAYS          = '-01C'
    CALL CDT('', Y.LAST.SYS.DATE, Y.DAYS)
    Y.SYS.TIME      = OCONV(TIME(), "MTS")

    Y.SYS.DATE.VAL           = Y.SYS.DATE[7,4]:Y.SYS.DATE[1,2]:Y.SYS.DATE[4,2]
    Y.SYS.TIME.DATE.VAL      = Y.SYS.DATE[9,2]:Y.SYS.DATE[1,2]:Y.SYS.DATE[4,2]:'0000'
    Y.LAST.SYS.DATE.VAL      = Y.LAST.SYS.DATE
    Y.LAST.SYS.TIME.DATE.VAL = Y.LAST.SYS.DATE[3,6]:'0000'
	
    BEGIN CASE
    CASE Y.CONTROL.LIST.FUNCTION EQ "FINAL.WRITE"
        GOSUB FINAL.WRITE
    CASE OTHERWISE
        GOSUB PROCESS
    END CASE

    RETURN
*-----------------------------------------------------------------------------
PROCESS:
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

    CHANGE '!TODAY' TO R.LOC.DATE<EB.DAT.TODAY> IN Y.OUTPUT.DIR
    CHANGE '!LAST.WORKING.DAY' TO R.LOC.DATE<EB.DAT.LAST.WORKING.DAY> IN Y.OUTPUT.DIR
    CHANGE '!NEXT.WORKING.DAY' TO R.LOC.DATE<EB.DAT.NEXT.WORKING.DAY> IN Y.OUTPUT.DIR
    CHANGE '!USER' TO OPERATOR IN Y.OUTPUT.DIR
    CHANGE '!LOCAL.CCY' TO LCCY IN Y.OUTPUT.DIR
    CHANGE '!LANGUAGE' TO LNGG IN Y.OUTPUT.DIR
    CHANGE '!COMPANY' TO ID.COMPANY IN Y.OUTPUT.DIR
    CHANGE '!SYSTEM.DATE' TO Y.SYS.DATE.VAL IN Y.OUTPUT.DIR
    CHANGE '!SERVER.NAME' TO SYSTEM(50) IN Y.OUTPUT.DIR
*<20200810_Khoirul
    CHANGE '!TODAY' TO R.LOC.DATE<EB.DAT.TODAY> IN Y.BACKUP.DIR
    CHANGE '!LAST.WORKING.DAY' TO R.LOC.DATE<EB.DAT.LAST.WORKING.DAY> IN Y.BACKUP.DIR
    CHANGE '!NEXT.WORKING.DAY' TO R.LOC.DATE<EB.DAT.NEXT.WORKING.DAY> IN Y.BACKUP.DIR
    CHANGE '!USER' TO OPERATOR IN Y.BACKUP.DIR
    CHANGE '!LOCAL.CCY' TO LCCY IN Y.BACKUP.DIR
    CHANGE '!LANGUAGE' TO LNGG IN Y.BACKUP.DIR
    CHANGE '!COMPANY' TO ID.COMPANY IN Y.BACKUP.DIR
    CHANGE '!SYSTEM.DATE' TO Y.SYS.DATE.VAL IN Y.BACKUP.DIR
    CHANGE '!SERVER.NAME' TO SYSTEM(50) IN Y.BACKUP.DIR
*>20200810_Khoirul

    FN.FOLDER = Y.OUTPUT.DIR
*<20200810_Khoirul
	FN.FOLDER := FM : Y.BACKUP.DIR
*>20200810_Khoirul

    OPEN FN.FOLDER TO F.FOLDER ELSE
        Y.EXEC.CMD = 'CREATE.FILE ':FN.FOLDER:' TYPE=UD'
        EXECUTE Y.EXEC.CMD
        OPEN FN.FOLDER TO F.FOLDER ELSE
            RETURN
        END
    END
	
    GOSUB DELETE.FILE
	
*------SELECTION------
    IF Y.SEL.RTN THEN
        CALL @Y.SEL.RTN(SEL.LIST)
        CALL BATCH.BUILD.LIST("",SEL.LIST)
    END
    ELSE
        Y.CNT.SEL.FLD = DCOUNT(Y.SEL.FLD,VM)
        FOR Y.FLD = 1 TO Y.CNT.SEL.FLD
            SEL.CMD := " ":Y.SEL.FLD<1,Y.FLD>
            SEL.CMD := " ":Y.SEL.CRIT<1,Y.FLD>

            Y.CUR.SEL.VAL = Y.SEL.VAL<1,Y.FLD>
            CHANGE '!TODAY' TO R.LOC.DATE<EB.DAT.TODAY> IN Y.CUR.SEL.VAL
            CHANGE '!LAST.WORKING.DAY' TO R.LOC.DATE<EB.DAT.LAST.WORKING.DAY> IN Y.CUR.SEL.VAL
            CHANGE '!NEXT.WORKING.DAY' TO R.LOC.DATE<EB.DAT.NEXT.WORKING.DAY> IN Y.CUR.SEL.VAL
            CHANGE '!SYSTEM.DATE' TO Y.SYS.DATE.VAL IN Y.CUR.SEL.VAL
            CHANGE '!SYSTEM.TIME.DATE' TO Y.SYS.TIME.DATE.VAL IN Y.CUR.SEL.VAL
            CHANGE '!LAST.SYSTEM.DATE' TO Y.LAST.SYS.DATE.VAL IN Y.CUR.SEL.VAL
            CHANGE '!LAST.SYSTEM.TIME.DATE' TO Y.LAST.SYS.TIME.DATE.VAL IN Y.CUR.SEL.VAL

            SEL.CMD := " ":Y.CUR.SEL.VAL
            SEL.CMD := " ":Y.SEL.COMB<1,Y.FLD>
        NEXT Y.FLD

        LIST.PARAM<1> = ""
        LIST.PARAM<2> = FN.APP
        LIST.PARAM<3> = SEL.CMD
        LIST.PARAM<6> = ""
        LIST.PARAM<7> = ""

        CALL BATCH.BUILD.LIST(LIST.PARAM,"")
    END

    RETURN

*-----------------------------------------------------------------------------
FINAL.WRITE:
*-----------------------------------------------------------------------------
	
    Y.CNT.BATCH.DATA = DCOUNT(Y.BATCH.DETAILS,FM)
    FOR YLOOP = 1 TO Y.CNT.BATCH.DATA
        Y.ID.EXT.REP = Y.BATCH.DETAILS<YLOOP>
        GOSUB GET.DATA.EXT.REP
		
        FN.FOLDER = Y.OUTPUT.DIR
*<20200810_Khoirul
		FN.FOLDER := FM : Y.BACKUP.DIR
*>20200810_Khoirul
        F.FOLDER  = ''

        OPEN FN.FOLDER TO F.FOLDER ELSE
            Y.EXEC.CMD = 'CREATE.FILE ':FN.FOLDER:' TYPE=UD'
            EXECUTE Y.EXEC.CMD
            OPEN FN.FOLDER TO F.FOLDER ELSE
                RETURN
            END
        END
		
        FN.EXT.TEMP = 'F.ATI.EXT.REP.':Y.ID.EXT.REP:'.TEMP'
        F.EXT.TEMP  = ''
        CALL OPF(FN.EXT.TEMP,F.EXT.TEMP)

        FN.FILE.EXT = 'F.ATI.TT.FILE.EXT.REPORT'
        F.FILE.EXT  = ''
        CALL OPF(FN.FILE.EXT,F.FILE.EXT)

        Y.EXT.TEMP.CMD = "SELECT ":FN.EXT.TEMP
        CALL EB.READLIST(Y.EXT.TEMP.CMD,Y.EXT.TEMP.LIST,"",Y.EXT.TEMP.CNT,Y.EXT.TEMP.ERR)
		
        FOR I = 1 TO Y.EXT.TEMP.CNT
            Y.AGENT.NO = FIELD(Y.EXT.TEMP.LIST<I>,'-',1)
            CHANGE '!AGENT.NUMBER' TO Y.AGENT.NO IN Y.TARGET.FILE

            IF Y.SPLIT.FILE EQ 'YES' THEN
                Y.TARGET.FILE.NEW = Y.TARGET.FILE:'_':Y.EXT.TEMP.LIST<I>
****************<20171223_Dhio	
				IF Y.LABEL.AS.HEADER EQ "YES" THEN
					GOSUB WRITE.HEADER.TEXTFILE
				END
****************>20171223_Dhio	
                GOSUB WRITE.TEXTFILE
            END ELSE
                Y.TARGET.FILE.NEW = Y.TARGET.FILE
****************<20171223_Dhio
				IF Y.LABEL.AS.HEADER EQ "YES" THEN
					GOSUB WRITE.HEADER.TEXTFILE
				END
****************>20171223_Dhio
                GOSUB WRITE.TEXTFILE
            END

            CALL F.READ(FN.FILE.EXT,Y.ID.EXT.REP,R.FILE.EXT,F.FILE.EXT,FILE.EXT.ERR)
            FIND Y.TARGET.FILE.NEW IN R.FILE.EXT SETTING POSF.FILE ELSE
                R.FILE.EXT<-1> = Y.TARGET.FILE.NEW
            END
            CALL F.WRITE(FN.FILE.EXT,Y.ID.EXT.REP,R.FILE.EXT)

        NEXT I

    NEXT YLOOP

    RETURN
*-----------------------------------------------------------------------------
WRITE.TEXTFILE:
*-----------------------------------------------------------------------------
	
    OPENSEQ FN.FOLDER, Y.TARGET.FILE.NEW TO F.FOLDER ELSE
        CREATE F.FOLDER THEN
        END
    END

    CALL F.READ(FN.EXT.TEMP,Y.EXT.TEMP.LIST<I>,R.EXT.TEMP,F.EXT.TEMP,EXT.TEMP.ERR)
    Y.CNT.REC.DATA = DCOUNT(R.EXT.TEMP,FM)

    FOR YLOOP3 = 1 TO Y.CNT.REC.DATA
        WRITESEQ R.EXT.TEMP<YLOOP3> APPEND TO F.FOLDER ELSE
            CRT 'FILE WRITE ERROR'
            STOP
        END
    NEXT YLOOP3

    WEOFSEQ F.FOLDER
    CLOSESEQ F.FOLDER

    RETURN
*-----------------------------------------------------------------------------
GET.DATA.EXT.REP:
*-----------------------------------------------------------------------------
	
    CALL F.READ(FN.EXT.REPORT,Y.ID.EXT.REP,R.EXT.REPORT,F.EXT.REPORT,REP.ERR)
    Y.APPLICATION  = R.EXT.REPORT<EXT.REP.APPLICATION>
    Y.OUTPUT.DIR   = R.EXT.REPORT<EXT.REP.OUTPUT.DIR>
    Y.SEL.FLD      = R.EXT.REPORT<EXT.REP.SEL.FLD>
    Y.SEL.CRIT     = R.EXT.REPORT<EXT.REP.SEL.CRIT>
    Y.SEL.VAL      = R.EXT.REPORT<EXT.REP.SEL.VALUE>
    Y.SEL.COMB     = R.EXT.REPORT<EXT.REP.SEL.COMB>
    Y.SEL.RTN      = R.EXT.REPORT<EXT.REP.SEL.RTN>
    Y.TARGET.FILE  = R.EXT.REPORT<EXT.REP.TARGET.FILE>
    Y.SPLIT.FILE   = R.EXT.REPORT<EXT.REP.SPLIT.FILE>
    Y.TABLES.TYPE  = R.EXT.REPORT<EXT.REP.TABLES.TYPE>
*<20171223_Dhio	
	Y.LABEL.AS.HEADER     = R.EXT.REPORT<EXT.REP.LABEL.AS.HEADER>
	Y.FIELD.LABEL         = R.EXT.REPORT<EXT.REP.FLD.LABEL>
	Y.SEPARATOR.FM.HEADER = R.EXT.REPORT<EXT.REP.SEPARATOR.FM>
*>20171223_Dhio
*<20200810_Khoirul
	Y.BACKUP.DIR   = R.EXT.REPORT<EXT.REP.BACKUP.DIR>
*>20200810_Khoirul

    CHANGE '!TODAY' TO R.LOC.DATE<EB.DAT.TODAY> IN Y.TARGET.FILE
    CHANGE '!LAST.WORKING.DAY' TO R.LOC.DATE<EB.DAT.LAST.WORKING.DAY> IN Y.TARGET.FILE
    CHANGE '!NEXT.WORKING.DAY' TO R.LOC.DATE<EB.DAT.NEXT.WORKING.DAY> IN Y.TARGET.FILE
    CHANGE '!USER' TO OPERATOR IN Y.TARGET.FILE
    CHANGE '!LOCAL.CCY' TO LCCY IN Y.TARGET.FILE
    CHANGE '!LANGUAGE' TO LNGG IN Y.TARGET.FILE
    CHANGE '!COMPANY' TO ID.COMPANY IN Y.TARGET.FILE

    CHANGE '!SYSTEM.DATE' TO Y.SYS.DATE.VAL IN Y.TARGET.FILE
    CHANGE '!SERVER.NAME' TO SYSTEM(50) IN Y.TARGET.FILE

    CHANGE '!TODAY' TO R.LOC.DATE<EB.DAT.TODAY> IN Y.OUTPUT.DIR
    CHANGE '!LAST.WORKING.DAY' TO R.LOC.DATE<EB.DAT.LAST.WORKING.DAY> IN Y.OUTPUT.DIR
    CHANGE '!NEXT.WORKING.DAY' TO R.LOC.DATE<EB.DAT.NEXT.WORKING.DAY> IN Y.OUTPUT.DIR
    CHANGE '!USER' TO OPERATOR IN Y.OUTPUT.DIR
    CHANGE '!LOCAL.CCY' TO LCCY IN Y.OUTPUT.DIR
    CHANGE '!LANGUAGE' TO LNGG IN Y.OUTPUT.DIR
    CHANGE '!COMPANY' TO ID.COMPANY IN Y.OUTPUT.DIR
    CHANGE '!SYSTEM.DATE' TO Y.SYS.DATE.VAL IN Y.OUTPUT.DIR
    CHANGE '!SERVER.NAME' TO SYSTEM(50) IN Y.OUTPUT.DIR
*<20200810_Khoirul
    CHANGE '!TODAY' TO R.LOC.DATE<EB.DAT.TODAY> IN Y.BACKUP.DIR
    CHANGE '!LAST.WORKING.DAY' TO R.LOC.DATE<EB.DAT.LAST.WORKING.DAY> IN Y.BACKUP.DIR
    CHANGE '!NEXT.WORKING.DAY' TO R.LOC.DATE<EB.DAT.NEXT.WORKING.DAY> IN Y.BACKUP.DIR
    CHANGE '!USER' TO OPERATOR IN Y.BACKUP.DIR
    CHANGE '!LOCAL.CCY' TO LCCY IN Y.BACKUP.DIR
    CHANGE '!LANGUAGE' TO LNGG IN Y.BACKUP.DIR
    CHANGE '!COMPANY' TO ID.COMPANY IN Y.BACKUP.DIR
    CHANGE '!SYSTEM.DATE' TO Y.SYS.DATE.VAL IN Y.BACKUP.DIR
    CHANGE '!SERVER.NAME' TO SYSTEM(50) IN Y.BACKUP.DIR
*>20200810_Khoirul

    RETURN
*-----------------------------------------------------------------------------
DELETE.FILE:
*-----------------------------------------------------------------------------
    FN.FILE.EXT = 'F.ATI.TT.FILE.EXT.REPORT'
    F.FILE.EXT  = ''
    CALL OPF(FN.FILE.EXT,F.FILE.EXT)

    CALL F.READ(FN.FILE.EXT,Y.ID.EXT.REP,R.FILE.EXT,F.FILE.EXT,FILE.EXT.ERR)
    Y.CNT.FILE = DCOUNT(R.FILE.EXT,FM)

    FOR YLOOP2 = 1 TO Y.CNT.FILE
        Y.CURRENT.FILE = R.FILE.EXT<YLOOP2>
        DELETE F.FOLDER, Y.CURRENT.FILE
    NEXT YLOOP2

    DELETE F.FILE.EXT,Y.ID.EXT.REP

    FN.EXT.TEMP = 'F.ATI.EXT.REP.':Y.ID.EXT.REP:'.TEMP'
    F.EXT.TEMP  = ''
    CALL OPF(FN.EXT.TEMP,F.EXT.TEMP)

    CLEARFILE F.EXT.TEMP

    RETURN
	
*-----------------------------------------------------------------------------
WRITE.HEADER.TEXTFILE:
*-----------------------------------------------------------------------------
	CHANGE VM TO Y.SEPARATOR.FM.HEADER IN Y.FIELD.LABEL
	
	OPENSEQ FN.FOLDER, Y.TARGET.FILE.NEW TO F.FOLDER ELSE
        CREATE F.FOLDER THEN
        END
    END
	
	WRITESEQ Y.FIELD.LABEL TO F.FOLDER ELSE
        CRT 'FILE WRITE ERROR'
        STOP
    END

    WEOFSEQ F.FOLDER
    CLOSESEQ F.FOLDER

	RETURN
*-----------------------------------------------------------------------------
END




