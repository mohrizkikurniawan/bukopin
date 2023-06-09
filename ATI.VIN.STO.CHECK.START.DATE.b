*-----------------------------------------------------------------------------
    SUBROUTINE ATI.VIN.STO.CHECK.START.DATE
*-----------------------------------------------------------------------------
* Developer Name     : Dhio Faizar Wahyudi
* Development Date   : 20171121
* Description        : Routine to cek START.DATE and PERIODIC STO on Sub account Creation STO
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

	IF R.NEW(ORK.DATA.MAPPING) EQ "SUB.AC.CREATION.STO" THEN
		GOSUB INIT
		GOSUB PROCESS
	END
	
    RETURN

*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
    FN.ATI.TH.INTF.GLOBAL.PARAM = "F.ATI.TH.INTF.GLOBAL.PARAM"
	F.ATI.TH.INTF.GLOBAL.PARAM  = ""
	CALL OPF(FN.ATI.TH.INTF.GLOBAL.PARAM, F.ATI.TH.INTF.GLOBAL.PARAM)
	
	Y.ATI.TH.INTF.GLOBAL.PARAM.ID = "SYSTEM"
	CALL F.READ(FN.ATI.TH.INTF.GLOBAL.PARAM, Y.ATI.TH.INTF.GLOBAL.PARAM.ID, R.ATI.TH.INTF.GLOBAL.PARAM, F.ATI.TH.INTF.GLOBAL.PARAM, ATI.TH.INTF.GLOBAL.PARAM.ERR)
	Y.PARAM.STO.MIN.PERIODIC = R.ATI.TH.INTF.GLOBAL.PARAM<GLOBAL.PARAM.STO.MIN.PERIODIC>
	Y.PARAM.STO.MAX.PERIODIC = R.ATI.TH.INTF.GLOBAL.PARAM<GLOBAL.PARAM.STO.MAX.PERIODIC>
	Y.PARAM.STO.START.DATE   = R.ATI.TH.INTF.GLOBAL.PARAM<GLOBAL.PARAM.STO.START.DATE>
	
	
	Y.PARAM.STO.MIN.PERIODIC = Y.PARAM.STO.MIN.PERIODIC / 30
	Y.PARAM.STO.MIN.PERIODIC = FIELD(Y.PARAM.STO.MIN.PERIODIC, ".", 1)
	
	Y.PARAM.STO.MAX.PERIODIC = Y.PARAM.STO.MAX.PERIODIC / 365
	Y.PARAM.STO.MAX.PERIODIC = FIELD(Y.PARAM.STO.MAX.PERIODIC, ".", 1) * 12
	
	RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
	Y.ORK.FIELD = R.NEW(ORK.DATA.FIELD)
	Y.ORK.VALUE = R.NEW(ORK.DATA.VALUE)
	
	LOCATE "PER.START.DATE" IN Y.ORK.FIELD<1, 1> SETTING Y.POS.START THEN
		Y.STO.START.DATE = Y.ORK.VALUE<1, Y.POS.START>
	END
	
	LOCATE "PER.END.DATE" IN Y.ORK.FIELD<1, 1> SETTING Y.POS.END THEN
		Y.STO.END.DATE = Y.ORK.VALUE<1, Y.POS.END>
	END
	
	Y.LEN.STO.START.DATE = LEN(Y.STO.START.DATE)
	Y.LEN.STO.END.DATE   = LEN(Y.STO.END.DATE)
	Y.LEN.TODAY          = LEN(TODAY)
	
	GOSUB CHECK.START.END.DATE
	GOSUB CHECK.START.DATE
	
	RETURN
*-----------------------------------------------------------------------------
CHECK.START.END.DATE:
*-----------------------------------------------------------------------------

	Y.SELISIH.PERIODIC = 0
	
	IF Y.LEN.STO.START.DATE EQ 8 AND Y.LEN.STO.END.DATE EQ 8 THEN
		CALL EB.NO.OF.MONTHS(Y.STO.START.DATE, Y.STO.END.DATE, Y.SELISIH.PERIODIC)
	END	
	
	IF Y.STO.START.DATE LE TODAY THEN
		ETEXT = "EB-STO.START.DATE.GT.TODAY"
		CALL STORE.END.ERROR
	END
	
	IF Y.SELISIH.PERIODIC LT Y.PARAM.STO.MIN.PERIODIC THEN
		ETEXT = "EB-STO.MIN.PERIODIC"
		CALL STORE.END.ERROR
	END
	
	IF Y.SELISIH.PERIODIC GT Y.PARAM.STO.MAX.PERIODIC THEN
		ETEXT = "EB-STO.MAX.PERIODIC"
		CALL STORE.END.ERROR
	END
	
	
	RETURN

*-----------------------------------------------------------------------------
CHECK.START.DATE:
*-----------------------------------------------------------------------------

	IF Y.LEN.TODAY EQ 8 AND Y.LEN.STO.START.DATE EQ 8 THEN
		Y.NUM.DAYS = 'C'
        CALL CDD('', TODAY, Y.STO.START.DATE, Y.NUM.DAYS)
		IF Y.NUM.DAYS GT Y.PARAM.STO.START.DATE THEN
			ETEXT = "EB-STO.START.DATE"
			CALL STORE.END.ERROR
		END
	END
	
	RETURN
*-----------------------------------------------------------------------------
END
