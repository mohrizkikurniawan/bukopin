*-----------------------------------------------------------------------------
    SUBROUTINE ATI.BM.CREATE.CASHBACK.LOAD
*-----------------------------------------------------------------------------
* Developer Name     : Dhio Faizar Wahyudi
* Development Date   : 20180430
* Description        : Routine to create CASHBACK
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date            Modified by                Description
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ATI.BM.CREATE.CASHBACK.COMMON
    $INSERT I_F.ATI.TH.INTF.GLOBAL.PARAM
    
*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------
    GOSUB INIT

    RETURN

*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
    
	FN.ATI.TH.PROMOTION.DATA = "F.ATI.TH.PROMOTION.DATA"
	F.ATI.TH.PROMOTION.DATA = ""
	CALL OPF(FN.ATI.TH.PROMOTION.DATA, F.ATI.TH.PROMOTION.DATA)
	
	FN.ATI.TT.PROMOTION.DATA.CONCAT = "F.ATI.TT.PROMOTION.DATA.CONCAT"
	F.ATI.TT.PROMOTION.DATA.CONCAT = ""
	CALL OPF(FN.ATI.TT.PROMOTION.DATA.CONCAT, F.ATI.TT.PROMOTION.DATA.CONCAT)
	
	FN.ATI.TH.INTF.GLOBAL.PARAM = "F.ATI.TH.INTF.GLOBAL.PARAM"
	F.ATI.TH.INTF.GLOBAL.PARAM = ""
	CALL OPF(FN.ATI.TH.INTF.GLOBAL.PARAM, F.ATI.TH.INTF.GLOBAL.PARAM)
	
	FN.ATI.TH.PROMOTION.PARAM = "F.ATI.TH.PROMOTION.PARAM"
	F.ATI.TH.PROMOTION.PARAM = ""
	CALL OPF(FN.ATI.TH.PROMOTION.PARAM, F.ATI.TH.PROMOTION.PARAM)
	
	CALL F.READ(FN.ATI.TH.INTF.GLOBAL.PARAM, "SYSTEM", R.ATI.TH.INTF.GLOBAL.PARAM, F.ATI.TH.INTF.GLOBAL.PARAM, ATI.TH.INTF.GLOBAL.PARAM.ERR)
	Y.ATI.TH.INTF.GLOBAL.PARAM.BUFFER.PROMO = R.ATI.TH.INTF.GLOBAL.PARAM<GLOBAL.PARAM.BUFFER.PROMO>

    RETURN
*-----------------------------------------------------------------------------
END





















