*-----------------------------------------------------------------------------
* <Rating>-60</Rating>
* 17:14:36 15 JAN 2016 * 17:12:56 15 JAN 2016 * 16:24:36 15 JAN 2016 * 13:59:24 15 JAN 2016 * 13:53:45 15 JAN 2016 * 13:50:35 15 JAN 2016
* CBS-APP1-JKT/t24sit * CBS-APP1-JKT/t24sit * CBS-APP1-JKT/t24sit * CBS-APP1-JKT/t24sit * CBS-APP1-JKT/t24sit * CBS-APP1-JKT/t24sit
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.TH.PURGE.PARAM.VALIDATE
*-----------------------------------------------------------------------------
* Developer Name        : ATI-YUDISTIA ADNAN
* Development Date      : 07 DECEMBER 2015
* Description           : Validation Routine for table IDCH.PURGE.FILE.PARAM
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
    $INSERT I_F.FILE.CONTROL
    $INSERT I_F.ATI.TH.PURGE.PARAM
    $INSERT I_F.STANDARD.SELECTION
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
    FN.SS = "F.STANDARD.SELECTION"
    F.SS  = ""
    CALL OPF(FN.SS, F.SS)

    Y.FIELD.LIST     = R.NEW(PRG.FL.FIELD.SEL)
    Y.OPERATION.LIST = R.NEW(PRG.FL.OPERATION.SEL)
    Y.VALUE.LIST     = R.NEW(PRG.FL.VALUE.SEL)
    Y.COMB.LIST      = R.NEW(PRG.FL.COMB.SEL)
    Y.RTN.SEL        = R.NEW(PRG.FL.ROUTINE.SEL)

    Y.APP = ID.NEW

    RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    Y.FIELD.CNT = DCOUNT(Y.FIELD.LIST, VM)

    FOR Y.LOOP1 = 1 TO Y.FIELD.CNT
        Y.FLD.SEL   = Y.FIELD.LIST<1,Y.LOOP1>
        Y.OPERATION = Y.OPERATION.LIST<1,Y.LOOP1>
        Y.VALUE     = Y.VALUE.LIST<1,Y.LOOP1>

        IF Y.FLD.SEL NE "" AND Y.OPERATION EQ "" THEN
            AF    = PRG.FL.OPERATION.SEL
            AV    = Y.LOOP1
            ETEXT = "EB-FIELD.NOT.EMPTY"
            CALL STORE.END.ERROR
        END

        IF Y.FLD.SEL EQ "" AND Y.OPERATION NE "" THEN
            AF    = PRG.FL.FIELD.SEL
            AV    = Y.LOOP1
            ETEXT = "EB-FIELD.NOT.EMPTY"
            CALL STORE.END.ERROR
        END

        GOSUB CHECK.FIELD

        IF Y.VALUE[1,1] EQ "@" THEN
            Y.ROUTINE    = FIELD(Y.VALUE,"@",2)

            AF = PRG.FL.VALUE.SEL
            AV = Y.LOOP1

            GOSUB CHECK.ROUTINE
        END

    NEXT Y.LOOP1

    IF Y.RTN.SEL NE "" THEN
        GOSUB CHECK.RTN.SEL

        Y.ROUTINE = FIELD(Y.RTN.SEL,"@",2)
        AF        = PRG.FL.ROUTINE.SEL

        GOSUB CHECK.ROUTINE

    END

    RETURN

*-----------------------------------------------------------------------------
CHECK.ROUTINE:
*-----------------------------------------------------------------------------
    CALL CHECK.ROUTINE.EXIST(Y.ROUTINE,Y.COMPILE,Y.RETURN.INFO)

    IF Y.COMPILE EQ 0 THEN
        ETEXT = "EB-RTN.NOT.EXIST"
        CALL STORE.END.ERROR
    END

    RETURN

*-----------------------------------------------------------------------------
CHECK.FIELD:
*-----------------------------------------------------------------------------
    CALL F.READ(FN.SS,Y.APP,R.SS,F.SS,SS.ERR)
    Y.SYS.FLD = R.SS<SSL.SYS.FIELD.NAME>
    Y.USR.FLD = R.SS<SSL.USR.FIELD.NAME>

    Y.FLD.SS = Y.SYS.FLD:VM:Y.USR.FLD

    FIND Y.FLD.SEL IN Y.FLD.SS SETTING POSF, POSV ELSE
        AF    = PRG.FL.FIELD.SEL
        AV    = Y.LOOP1
        ETEXT = "EB-FIELD.NOT.IN.SS"
        CALL STORE.END.ERROR
    END

    RETURN
*-----------------------------------------------------------------------------
CHECK.RTN.SEL:
*-----------------------------------------------------------------------------
    BEGIN CASE
    CASE Y.FIELD.LIST NE ""
        AF    = PRG.FL.FIELD.SEL
        ETEXT = "EB-FIELD.EMPTY"
        CALL STORE.END.ERROR

    CASE Y.OPERATION.LIST NE ""
        AF    = PRG.FL.OPERATION.SEL
        ETEXT = "EB-FIELD.EMPTY"
        CALL STORE.END.ERROR

    CASE Y.VALUE.LIST NE ""
        AV    = PRG.FL.VALUE.SEL
        ETEXT = "EB-FIELD.EMPTY"
        CALL STORE.END.ERROR

    CASE Y.COMB.LIST NE ""
        AF    = PRG.FL.COMB.SEL
        ETEXT = "EB-FIELD.EMPTY"
        CALL STORE.END.ERROR

    END CASE

    RETURN
*-----------------------------------------------------------------------------
END





