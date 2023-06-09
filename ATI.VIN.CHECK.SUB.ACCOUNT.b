*-----------------------------------------------------------------------------
    SUBROUTINE ATI.VIN.CHECK.SUB.ACCOUNT
*-----------------------------------------------------------------------------
* Developer Name     : Dhio Faizar Wahyudi
* Development Date   : 20170831
* Description        : Input routine for check sub account
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date            Modified by                Description
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.ATI.TH.INTF.GLOBAL.PARAM

*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------
    GOSUB INIT
    GOSUB PROCESS

    RETURN

*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
    FN.ACCOUNT = "F.ACCOUNT"
    CALL OPF(FN.ACCOUNT, F.ACCOUNT)

    FN.AA.ARRANGEMENT = "F.AA.ARRANGEMENT"
    CALL OPF(FN.AA.ARRANGEMENT, F.AA.ARRANGEMENT)
	
	FN.ATI.TH.INTF.GLOBAL.PARAM = "F.ATI.TH.INTF.GLOBAL.PARAM"
	CALL OPF(FN.ATI.TH.INTF.GLOBAL.PARAM, F.ATI.TH.INTF.GLOBAL.PARAM)
	
	Y.ATI.TH.INTF.GLOBAL.PARAM.ID = "SYSTEM"
	CALL F.READ(FN.ATI.TH.INTF.GLOBAL.PARAM, Y.ATI.TH.INTF.GLOBAL.PARAM.ID, R.ATI.TH.INTF.GLOBAL.PARAM, F.ATI.TH.INTF.GLOBAL.PARAM, ATI.TH.INTF.GLOBAL.PARAM.ERR)
	Y.ATI.TH.INTF.GLOBAL.PARAM.PRODUCT.ID = R.ATI.TH.INTF.GLOBAL.PARAM<GLOBAL.PARAM.SUB.PRODUCT>


    RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    
	Y.CR.ACCOUNT = R.NEW(FT.CREDIT.ACCT.NO)
	CALL F.READ(FN.ACCOUNT, Y.CR.ACCOUNT, R.ACCOUNT, F.ACCOUNT, ACCOUNT.ERR)
	
	Y.CATEGORY       = R.ACCOUNT<AC.CATEGORY>
	Y.ARRANGEMENT.ID = R.ACCOUNT<AC.ARRANGEMENT.ID>
	
	CALL F.READ(FN.AA.ARRANGEMENT, Y.ARRANGEMENT.ID, R.AA.ARRANGEMENT, F.AA.ARRANGEMENT, AA.ARRANGEMENT.ERR)
	Y.AA.ARRANGEMENT.PRODUCT = R.AA.ARRANGEMENT<AA.ARR.PRODUCT, 1>
	
	LOCATE Y.AA.ARRANGEMENT.PRODUCT IN Y.ATI.TH.INTF.GLOBAL.PARAM.PRODUCT.ID<1, 1> SETTING POS THEN
        AF    = ""
		ETEXT = "EB-AC.SUB.AC.NOTRANS"
        CALL STORE.END.ERROR
	END		
	

    RETURN
*-----------------------------------------------------------------------------
END


