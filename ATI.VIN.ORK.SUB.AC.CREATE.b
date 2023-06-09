*-----------------------------------------------------------------------------
* <Rating>-52</Rating>
* 08:48:41 24 NOV 2017 
* JFT/t24r11 
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.VIN.ORK.SUB.AC.CREATE
*-----------------------------------------------------------------------------
* Developer Name     : Dhio Faizar Wahyudi
* Development Date   : 20171121
* Description        : Routine for validation orchestration sub account creation
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date            Modified by                Description
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ATI.TH.INTF.GLOBAL.PARAM
    $INSERT I_F.ATI.TH.INTF.ORK.DATA

*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------
    GOSUB INIT
    GOSUB PROCESS

    RETURN

*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
    FN.ATI.TH.INTF.GLOBAL.PARAM = "F.ATI.TH.INTF.GLOBAL.PARAM"
    F.ATI.TH.INTF.GLOBAL.PARAM  = ""
    CALL OPF(FN.ATI.TH.INTF.GLOBAL.PARAM, F.ATI.TH.INTF.GLOBAL.PARAM)
	
	Y.MAX.AMOUNT = ''

    RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    Y.ORK.FIELD.LIST = R.NEW(ORK.DATA.FIELD)
    Y.ORK.VALUE.LIST = R.NEW(ORK.DATA.VALUE)

    FIND "DATE.DEPOSIT" IN Y.ORK.FIELD.LIST SETTING POSF, POSV, POSS THEN
        Y.DATE.DEPOSIT = Y.ORK.VALUE.LIST<1, POSV>
    END

    FIND "FREQUENCY" IN Y.ORK.FIELD.LIST SETTING POSF, POSV, POSS THEN
        Y.FREQUENCY = Y.ORK.VALUE.LIST<1, POSV>
    END

    FIND "PER.START.DATE" IN Y.ORK.FIELD.LIST SETTING POSF, POSV, POSS THEN
        Y.PER.START.DATE = Y.ORK.VALUE.LIST<1, POSV>
    END

    FIND "PER.END.DATE" IN Y.ORK.FIELD.LIST SETTING POSF, POSV, POSS THEN
        Y.PER.END.DATE = Y.ORK.VALUE.LIST<1, POSV>
    END
	
	FIND "MAX.AMOUNT" IN Y.ORK.FIELD.LIST SETTING POSF, POSV, POSS THEN
        Y.MAX.AMOUNT = Y.ORK.VALUE.LIST<1, POSV>
    END
	
*-Validation Date Deposit-----------------------------------------------------
    IF Y.DATE.DEPOSIT AND Y.DATE.DEPOSIT LT TODAY THEN
        AF    = ""
        ETEXT = "EB-DATE.LT.TODAY"
        CALL STORE.END.ERROR
    END

*-Validation Frequency--------------------------------------------------------
    IF Y.FREQUENCY THEN
        Y.FREQUENCY.DATE = FIELD(Y.FREQUENCY, " ", 1)

        IF Y.FREQUENCY.DATE LE TODAY THEN
            AF    = ""
            ETEXT = "EB-DATE.LT.TODAY"
            CALL STORE.END.ERROR
        END
    END

*-Validation for STO---------------------------------------------------------
	IF R.NEW(ORK.DATA.MAPPING) EQ "SUB.AC.CREATION.STO" THEN
        CALL F.READ(FN.ATI.TH.INTF.GLOBAL.PARAM, "SYSTEM", R.ATI.TH.INTF.GLOBAL.PARAM, F.ATI.TH.INTF.GLOBAL.PARAM, ATI.TH.INTF.GLOBAL.PARAM.ERR)
        Y.STO.MIN.PERIODIC = R.ATI.TH.INTF.GLOBAL.PARAM<GLOBAL.PARAM.STO.MIN.PERIODIC>
        Y.STO.MAX.PERIODIC = R.ATI.TH.INTF.GLOBAL.PARAM<GLOBAL.PARAM.STO.MAX.PERIODIC>
        Y.STO.START.DATE   = R.ATI.TH.INTF.GLOBAL.PARAM<GLOBAL.PARAM.STO.START.DATE>
        
        Y.STO.MIN.PERIODIC = Y.STO.MIN.PERIODIC / 30
        Y.STO.MIN.PERIODIC = FIELD(Y.STO.MIN.PERIODIC, ".", 1)
        
        Y.STO.MAX.PERIODIC = Y.STO.MAX.PERIODIC / 365
        Y.STO.MAX.PERIODIC = FIELD(Y.STO.MAX.PERIODIC, ".", 1) * 12
        
        Y.LEN.PER.START.DATE = LEN(Y.PER.START.DATE)
        Y.LEN.PER.END.DATE   = LEN(Y.PER.END.DATE)
        Y.LEN.TODAY          = LEN(TODAY)
        
        GOSUB CHECK.START.END.DATE
        GOSUB CHECK.START.DATE
    END

    RETURN

*-----------------------------------------------------------------------------
CHECK.START.END.DATE:
*-----------------------------------------------------------------------------
    Y.SELISIH.PERIODIC = 0

    IF Y.LEN.PER.START.DATE EQ 8 AND Y.LEN.PER.END.DATE EQ 8 THEN
        CALL EB.NO.OF.MONTHS(Y.PER.START.DATE, Y.PER.END.DATE, Y.SELISIH.PERIODIC)
    END

    IF Y.PER.START.DATE LE TODAY THEN
        AF    = ""
        ETEXT = "EB-STO.START.DATE.GT.TODAY"
        CALL STORE.END.ERROR
    END

    IF Y.SELISIH.PERIODIC LT Y.STO.MIN.PERIODIC AND Y.MAX.AMOUNT EQ "" THEN
        AF    = ""
        ETEXT = "EB-STO.MIN.PERIODIC"
        CALL STORE.END.ERROR
    END

    IF Y.SELISIH.PERIODIC GT Y.STO.MAX.PERIODIC AND Y.MAX.AMOUNT EQ "" THEN
        AF    = ""
        ETEXT = "EB-STO.MAX.PERIODIC"
        CALL STORE.END.ERROR
    END

    RETURN

*-----------------------------------------------------------------------------
CHECK.START.DATE:
*-----------------------------------------------------------------------------
    IF Y.LEN.TODAY EQ 8 AND Y.LEN.PER.START.DATE EQ 8 THEN
        Y.NUM.DAYS = "C"
        CALL CDD("", TODAY, Y.PER.START.DATE, Y.NUM.DAYS)

        IF Y.NUM.DAYS GT Y.PER.START.DATE THEN
            AF    = ""
            ETEXT = "EB-STO.START.DATE"
            CALL STORE.END.ERROR
        END
    END

    RETURN
*-----------------------------------------------------------------------------
END
