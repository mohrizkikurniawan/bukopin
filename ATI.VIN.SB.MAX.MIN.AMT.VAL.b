*-----------------------------------------------------------------------------
    SUBROUTINE ATI.VIN.SB.MAX.MIN.AMT.VAL
*-----------------------------------------------------------------------------
* Developer Name     : Dhio Faizar Wahyudi
* Development Date   : 20180315
* Description        : Routine to validate maks transaction on Split Bill
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date            Modified by                Description
*-----------------------------------------------------------------------------

	$INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ATI.TH.INTF.GLOBAL.PARAM
    $INSERT I_F.ATI.TH.SPLIT.BILL

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
	Y.ATI.TH.INTF.GLOBAL.PARAM.MAX.SB = R.ATI.TH.INTF.GLOBAL.PARAM<GLOBAL.PARAM.MAX.SB>
	Y.ATI.TH.INTF.GLOBAL.PARAM.MIN.SB = R.ATI.TH.INTF.GLOBAL.PARAM<GLOBAL.PARAM.MIN.SB>
	
	Y.ATI.TH.SPLIT.BILL.AMOUNT = R.NEW(SPLIT.BILL.AMOUNT.TOT)
	
	IF Y.ATI.TH.INTF.GLOBAL.PARAM.MAX.SB EQ "" THEN RETURN
	IF Y.ATI.TH.INTF.GLOBAL.PARAM.MIN.SB EQ "" THEN RETURN
	
	IF Y.ATI.TH.SPLIT.BILL.AMOUNT LT Y.ATI.TH.INTF.GLOBAL.PARAM.MIN.SB THEN
		ETEXT = "EB-SPLIT.BILL.MIN.AMT":FM:Y.ATI.TH.INTF.GLOBAL.PARAM.MIN.SB
		CALL STORE.END.ERROR
	END
	
	IF Y.ATI.TH.SPLIT.BILL.AMOUNT GT Y.ATI.TH.INTF.GLOBAL.PARAM.MAX.SB THEN
		ETEXT = "EB-SPLIT.BILL.MAX.AMT":FM:Y.ATI.TH.INTF.GLOBAL.PARAM.MAX.SB
		CALL STORE.END.ERROR
	END
	
	RETURN
*-----------------------------------------------------------------------------
END
