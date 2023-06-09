*-----------------------------------------------------------------------------
    SUBROUTINE ATI.VIN.CHECK.MOVE.MONEY.BMONEY
*-----------------------------------------------------------------------------
* Developer Name     : Dhio Faizar Wahyudi
* Development Date   : 20181108
* Description        : Routine to posting journal to Bukysis
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

	IF R.NEW(FT.TRANSACTION.TYPE) EQ 'ACMM' THEN
		GOSUB INIT
		GOSUB PROCESS
	END
	
    RETURN

*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------

	FN.ACCOUNT = 'F.ACCOUNT'
	F.ACCOUNT = ''
	CALL OPF(FN.ACCOUNT, F.ACCOUNT)
	
	FN.AA.ARRANGEMENT = "F.AA.ARRANGEMENT"
	F.AA.ARRANGEMENT = ""
	CALL OPF(FN.AA.ARRANGEMENT, F.AA.ARRANGEMENT)
	
	FN.ATI.TH.INTF.GLOBAL.PARAM = "F.ATI.TH.INTF.GLOBAL.PARAM"
	F.ATI.TH.INTF.GLOBAL.PARAM = ""
	CALL OPF(FN.ATI.TH.INTF.GLOBAL.PARAM, F.ATI.TH.INTF.GLOBAL.PARAM)
	
	Y.ATI.TH.INTF.GLOBAL.PARAM.ID = "SYSTEM"
	CALL F.READ(FN.ATI.TH.INTF.GLOBAL.PARAM, Y.ATI.TH.INTF.GLOBAL.PARAM.ID, R.ATI.TH.INTF.GLOBAL.PARAM, F.ATI.TH.INTF.GLOBAL.PARAM, ATI.TH.INTF.GLOBAL.PARAM.ERR)
	Y.ATI.TH.INTF.GLOBAL.PARAM.SUB.PRODUCT       = R.ATI.TH.INTF.GLOBAL.PARAM<GLOBAL.PARAM.SUB.PRODUCT>
	Y.ATI.TH.INTF.GLOBAL.PARAM.WALLET.REGISTER   = R.ATI.TH.INTF.GLOBAL.PARAM<GLOBAL.PARAM.WALLET.REGISTER>
	Y.ATI.TH.INTF.GLOBAL.PARAM.WALLET.UNREGISTER = R.ATI.TH.INTF.GLOBAL.PARAM<GLOBAL.PARAM.WALLET.UNREGISTER>
	
	
	RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
	
	Y.ACCOUNT = R.NEW(FT.DEBIT.ACCT.NO)
	GOSUB GET.ARRANGEMENT.PRODUCT
	Y.PRODUCT.DEBIT.ACCOUNT = Y.AA.ARRANGEMENT.PRODUCT
	
	Y.ACCOUNT = R.NEW(FT.CREDIT.ACCT.NO)
	GOSUB GET.ARRANGEMENT.PRODUCT
	Y.PRODUCT.CREDIT.ACCOUNT = Y.AA.ARRANGEMENT.PRODUCT
	
	IF Y.PRODUCT.DEBIT.ACCOUNT EQ Y.ATI.TH.INTF.GLOBAL.PARAM.WALLET.REGISTER OR Y.PRODUCT.DEBIT.ACCOUNT EQ Y.ATI.TH.INTF.GLOBAL.PARAM.WALLET.UNREGISTER THEN
		FIND Y.PRODUCT.CREDIT.ACCOUNT IN Y.ATI.TH.INTF.GLOBAL.PARAM.SUB.PRODUCT SETTING POSF, POSV THEN
			ETEXT = 'FT-BMONEY.TO.SUBAC.NOT.ALLOWED'
			CALL STORE.END.ERROR
		END
	END
		
	RETURN
	
*-----------------------------------------------------------------------------
GET.ARRANGEMENT.PRODUCT:
*-----------------------------------------------------------------------------
	
	Y.AA.ARRANGEMENT.PRODUCT = ''
	Y.ACCOUNT.ARRANGEMENT.ID = ''
	
	CALL F.READ(FN.ACCOUNT, Y.ACCOUNT, R.ACCOUNT, F.ACCOUNT, ACCOUNT.ERR)
	Y.ACCOUNT.ARRANGEMENT.ID = R.ACCOUNT<AC.ARRANGEMENT.ID>
	
	CALL F.READ(FN.AA.ARRANGEMENT, Y.ACCOUNT.ARRANGEMENT.ID, R.AA.ARRANGEMENT, F.AA.ARRANGEMENT, AA.ARRANGEMENT.ERR)
	Y.AA.ARRANGEMENT.PRODUCT = R.AA.ARRANGEMENT<AA.ARR.PRODUCT, 1>

	RETURN
*-----------------------------------------------------------------------------

END
