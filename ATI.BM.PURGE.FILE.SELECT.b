*-----------------------------------------------------------------------------
* <Rating>-50</Rating>
* 17:30:00 15 JAN 2016 * 16:37:36 15 JAN 2016 * 12:05:32 15 JAN 2016
* CBS-APP1-JKT/t24sit * CBS-APP1-JKT/t24sit * CBS-APP1-JKT/t24sit
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.BM.PURGE.FILE.SELECT
*-----------------------------------------------------------------------------
* Developer Name        : ATI-YUDISTIA ADNAN
* Development Date      : 02 DECEMBER 2015
* Description           : Purge based on Table Parameter
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date        :
* Modified by :
* Description :
* No Log      :
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ATI.BM.PURGE.FILE.COMMON
    $INSERT I_F.ATI.TH.PURGE.PARAM
    $INSERT I_BATCH.FILES
    $INSERT I_F.DATES
    $INSERT I_F.COMPANY

*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------

    GOSUB INIT
    GOSUB PROCESS

    RETURN

*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
    Y.BATCH.DETAILS = BATCH.DETAILS<3,1>

    CONVERT SM TO FM IN Y.BATCH.DETAILS

    IF CONTROL.LIST EQ "" THEN
        CONTROL.LIST = Y.BATCH.DETAILS
    END

    RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    LIST.PARAMETER = ""
    Y.PRG.ID       = CONTROL.LIST<1,1>

    CALL F.READ(FN.PRG.PARAM, Y.PRG.ID, R.PRG.PARAM, F.PRG.PARAM, PARAM.ERR)

    IF R.PRG.PARAM THEN
        Y.FIELD.SEL.LIST     = R.PRG.PARAM<PRG.FL.FIELD.SEL>
        Y.OPERATION.SEL.LIST = R.PRG.PARAM<PRG.FL.OPERATION.SEL>
        Y.VALUE.SEL.LIST     = R.PRG.PARAM<PRG.FL.VALUE.SEL>
        Y.COMB.SEL.LIST      = R.PRG.PARAM<PRG.FL.COMB.SEL>
        Y.ROUTINE.SEL        = R.PRG.PARAM<PRG.FL.ROUTINE.SEL>

        Y.FILE.NAME = Y.PRG.ID

        BEGIN CASE
        CASE Y.FIELD.SEL.LIST  NE ""
            GOSUB GET.SEL.FIELD

            LIST.PARAMETER<2> = "F.":Y.FILE.NAME
            LIST.PARAMETER<3> = Y.CMD.LIST

            CALL BATCH.BUILD.LIST(LIST.PARAMETER, "")

        CASE Y.ROUTINE.SEL NE ""
            Y.ROUTINE = FIELD(Y.ROUTINE.SEL,"@",2)
            CALL @Y.ROUTINE(SEL.LIST)

            CALL BATCH.BUILD.LIST("", SEL.LIST)

        END CASE
    END

    RETURN

*-----------------------------------------------------------------------------
GET.SEL.FIELD:
*-----------------------------------------------------------------------------
    Y.FIELD.CNT = DCOUNT(Y.FIELD.SEL.LIST,VM)
    Y.CMD.LIST  = ""

    FOR J = 1 TO Y.FIELD.CNT
        Y.FIELD.SEL     = Y.FIELD.SEL.LIST<1,J>
        Y.OPERATION.SEL = Y.OPERATION.SEL.LIST<1,J>
        Y.VALUE.SEL     = Y.VALUE.SEL.LIST<1,J>
        Y.COMB.SEL      = Y.COMB.SEL.LIST<1,J>

        BEGIN CASE
        CASE Y.VALUE.SEL[1,1] EQ "!"
            Y.VALUE = Y.VALUE.SEL
            GOSUB GET.VARIABLE
        CASE Y.VALUE.SEL[1,1] EQ "@"
            Y.RTN.VALUE = FIELD(Y.VALUE.SEL,"@",2)
            CALL @Y.RTN.VALUE(Y.VALUE)
        CASE Y.VALUE.SEL EQ ''
            Y.VALUE = "''"

        CASE (1)
            Y.VALUE = Y.VALUE.SEL
        END CASE

        Y.SELECTION = " ":Y.FIELD.SEL:" ":Y.OPERATION.SEL:" ":Y.VALUE

        IF Y.COMB.SEL NE "" THEN
            Y.SELECTION := " " : Y.COMB.SEL
        END

        Y.CMD.LIST := Y.SELECTION
    NEXT J

    RETURN

*-----------------------------------------------------------------------------
GET.VARIABLE:
*-----------------------------------------------------------------------------
    CHANGE "!TODAY" TO R.DATES(EB.DAT.TODAY) IN Y.VALUE
    CHANGE "!LAST.WORKING.DAY" TO R.DATES(EB.DAT.LAST.WORKING.DAY) IN Y.VALUE
    CHANGE "!NEXT.WORKING.DAY" TO R.DATES(EB.DAT.NEXT.WORKING.DAY) IN Y.VALUE
    CHANGE "!USER" TO OPERATOR IN Y.VALUE
    CHANGE "!LOCAL.CCY" TO LCCY IN Y.VALUE
    CHANGE "!LANGUAGE" TO LNGG IN Y.VALUE
    CHANGE "!COMPANY" TO ID.COMPANY IN Y.VALUE

    Y.SYS.DATE = ""
    Y.SYS.DATE = OCONV(DATE(),"D-")
    Y.SYS.DATE.VAL = Y.SYS.DATE[7,4]:Y.SYS.DATE[1,2]:Y.SYS.DATE[4,2]

    CHANGE "!SYSTEM.DATE" TO Y.SYS.DATE.VAL IN Y.VALUE

    RETURN

*-----------------------------------------------------------------------------
END









