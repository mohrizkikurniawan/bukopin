*-----------------------------------------------------------------------------
* <Rating>-80</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.BM.DEL.RECORD.NAU.SELECT
*-----------------------------------------------------------------------------
* Developer Name     : Novi Leo
* Development Date   : 20151030
* Description        : Delete INAU Record based on parameter
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date               :
* Modified by        :
* Description        :
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FILE.CONTROL
    $INSERT I_F.ATI.TH.DEL.RECORD.NAU.PARAM
    $INSERT I_ATI.BM.DEL.RECORD.NAU.COMMON
    $INSERT I_F.DATES
    $INSERT I_F.COMPANY
    $INSERT I_BATCH.FILES

*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------

    GOSUB INIT
    GOSUB PROCESS

    RETURN

*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------

    PROCESS.GOAHEAD = ''
    Y.BATCH.DETAILS = BATCH.DETAILS<3,1>

    CONVERT SM TO FM IN Y.BATCH.DETAILS

    IF CONTROL.LIST EQ "" THEN
        CONTROL.LIST = Y.BATCH.DETAILS
    END

    Y.APPLICATION = CONTROL.LIST<1,1>

    RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------

    LIST.PARAM = ""
    FINAL.LIST = ""

    Y.FILE.NAME = Y.APPLICATION

    GOSUB CHECK.FILE.NAME

    CALL F.READ(FN.PARAM,Y.FILE.NAME,R.PARAM,F.PARAM,PARAM.ERR)
    IF R.PARAM THEN
        Y.SEL.FLD  = R.PARAM<DEL.REC.NAU.PARAM.SEL.FLD>
        Y.SEL.CRIT = R.PARAM<DEL.REC.NAU.PARAM.SEL.CRIT>
        Y.SEL.VAL  = R.PARAM<DEL.REC.NAU.PARAM.SEL.VALUE>
        Y.SEL.COMB = R.PARAM<DEL.REC.NAU.PARAM.SEL.COMB>
        Y.SEL.RTN  = R.PARAM<DEL.REC.NAU.PARAM.SEL.RTN>

        IF Y.SEL.FLD THEN
            GOSUB PROCESS.SELECT
        END

        BEGIN CASE
        CASE Y.SEL.FLD
            LIST.PARAM<1> = ""
            LIST.PARAM<2> = FN.FILE.NAU
            LIST.PARAM<3> = Y.LIST.CMD
            CALL BATCH.BUILD.LIST(LIST.PARAM, "")
        CASE Y.SEL.RTN
            CALL @Y.SEL.RTN(Y.SEL.LIST)
            LIST.ID = Y.SEL.LIST
            CALL BATCH.BUILD.LIST("", LIST.ID)
        END CASE
    END

    RETURN

*-----------------------------------------------------------------------------
CHECK.FILE.NAME:
*-----------------------------------------------------------------------------

    CALL F.READ(FN.FL, Y.FILE.NAME, R.FL, F.FL, ERR.FL)
    Y.CLASS = R.FL<EB.FILE.CONTROL.CLASS>

    BEGIN CASE
    CASE Y.CLASS EQ "INT"
        FN.FILE.NAU = "F.":Y.FILE.NAME:"$NAU"
    CASE Y.CLASS EQ "CUS" OR Y.CLASS EQ "FIN"
        FN.FILE.NAU = "FBNK.":Y.FILE.NAME:"$NAU"
    END CASE

    RETURN

*-----------------------------------------------------------------------------
PROCESS.SELECT:
*-----------------------------------------------------------------------------

    Y.LIST.CUR.CMD = ""
    Y.LIST.CMD     = ""

    Y.CNT.SEL = DCOUNT(Y.SEL.FLD,VM)
    FOR J = 1 TO Y.CNT.SEL
        Y.CUR.SEL.FLD  = Y.SEL.FLD<1,J>
        Y.CUR.SEL.CRIT = Y.SEL.CRIT<1,J>
        Y.CUR.SEL.VAL  = Y.SEL.VAL<1,J>
        Y.CUR.SEL.COMB = Y.SEL.COMB<1,J>

        BEGIN CASE
        CASE Y.CUR.SEL.VAL[1,1] EQ "@"
            Y.CUR.SEL.VAL = FIELD(Y.CUR.SEL.VAL,"@",2)
            CALL @Y.CUR.SEL.VAL(Y.CURRENT.SEL.VAL)
        CASE Y.CUR.SEL.VAL[1,1] EQ "!"
            Y.CURRENT.SEL.VAL = Y.CUR.SEL.VAL
            GOSUB GET.VAR.COMMON
        CASE (1)
            Y.CURRENT.SEL.VAL = Y.CUR.SEL.VAL
        END CASE

        Y.LIST.CUR.CMD  = " ":Y.CUR.SEL.FLD:" ":Y.CUR.SEL.CRIT:" ":Y.CURRENT.SEL.VAL
        Y.LIST.CUR.CMD := " ":Y.CUR.SEL.COMB

        Y.LIST.CMD := Y.LIST.CUR.CMD
    NEXT J

    RETURN
*-----------------------------------------------------------------------------
GET.VAR.COMMON:
*-----------------------------------------------------------------------------

    CHANGE '!TODAY' TO R.DATES(EB.DAT.TODAY) IN Y.CURRENT.SEL.VAL
    CHANGE '!LAST.WORKING.DAY' TO R.DATES(EB.DAT.LAST.WORKING.DAY) IN Y.CURRENT.SEL.VAL
    CHANGE '!NEXT.WORKING.DAY' TO R.DATES(EB.DAT.NEXT.WORKING.DAY) IN Y.CURRENT.SEL.VAL
    CHANGE '!USER' TO OPERATOR IN Y.CURRENT.SEL.VAL
    CHANGE '!LOCAL.CCY' TO LCCY IN Y.CURRENT.SEL.VAL
    CHANGE '!LANGUAGE' TO LNGG IN Y.CURRENT.SEL.VAL
    CHANGE '!COMPANY' TO ID.COMPANY IN Y.CURRENT.SEL.VAL

    Y.SYS.DATE = ''
    Y.SYS.DATE = OCONV(DATE(),"D-")
    Y.SYS.DATE.VAL = Y.SYS.DATE[7,4]:Y.SYS.DATE[1,2]:Y.SYS.DATE[4,2]

    CHANGE '!SYSTEM.DATE' TO Y.SYS.DATE.VAL IN Y.CURRENT.SEL.VAL

    RETURN
*-----------------------------------------------------------------------------
END

















