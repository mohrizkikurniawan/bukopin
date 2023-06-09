*-----------------------------------------------------------------------------
    SUBROUTINE ATI.VIN.NM.MAX.MIN.AMT.VAL
*-----------------------------------------------------------------------------
* Developer Name     : Dhio Faizar Wahyudi
* Development Date   : 20180315
* Description        : Routine to validate maks transaction on Need Money
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date            Modified by                Description
*-----------------------------------------------------------------------------

	$INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ATI.TH.INTF.GLOBAL.PARAM
    $INSERT I_F.ATI.TH.NEED.MONEY

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
	F.ATI.TH.INTF.GLOBAL.PARAM = ""
	CALL OPF(FN.ATI.TH.INTF.GLOBAL.PARAM, F.ATI.TH.INTF.GLOBAL.PARAM)
	
	RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
	
	CALL F.READ(FN.ATI.TH.INTF.GLOBAL.PARAM, "SYSTEM", R.ATI.TH.INTF.GLOBAL.PARAM, F.ATI.TH.INTF.GLOBAL.PARAM, ATI.TH.INTF.GLOBAL.PARAM.ERR)
	Y.ATI.TH.INTF.GLOBAL.PARAM.MAX.NM = R.ATI.TH.INTF.GLOBAL.PARAM<GLOBAL.PARAM.MAX.NM>
	Y.ATI.TH.INTF.GLOBAL.PARAM.MIN.NM = R.ATI.TH.INTF.GLOBAL.PARAM<GLOBAL.PARAM.MIN.NM>
	
	Y.ATI.TH.NEED.MONEY.AMOUNT = R.NEW(NEED.MONEY.AMOUNT)
	
	IF Y.ATI.TH.INTF.GLOBAL.PARAM.MAX.NM EQ "" THEN RETURN
	IF Y.ATI.TH.INTF.GLOBAL.PARAM.MIN.NM EQ "" THEN RETURN
	
	IF Y.ATI.TH.NEED.MONEY.AMOUNT LT Y.ATI.TH.INTF.GLOBAL.PARAM.MIN.NM THEN
		AF = NEED.MONEY.AMOUNT
		ETEXT<1> = "EB-NEED.MONEY.MIN.AMT"
		ETEXT<2> = Y.ATI.TH.INTF.GLOBAL.PARAM.MIN.NM
		*ETEXT = "EB-NEED.MONEY.MIN.AMT"
		CALL STORE.END.ERROR
	END
	
	IF Y.ATI.TH.NEED.MONEY.AMOUNT GT Y.ATI.TH.INTF.GLOBAL.PARAM.MAX.NM THEN
		AF = NEED.MONEY.AMOUNT
		ETEXT<1> = "EB-NEED.MONEY.MAX.AMT"
		ETEXT<2> = Y.ATI.TH.INTF.GLOBAL.PARAM.MAX.NM
		*ETEXT = "EB-NEED.MONEY.MAX.AMT"
		CALL STORE.END.ERROR
	END
	
	RETURN
*-----------------------------------------------------------------------------
END
