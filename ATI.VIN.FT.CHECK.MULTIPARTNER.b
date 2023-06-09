*-----------------------------------------------------------------------------
    SUBROUTINE ATI.VIN.FT.CHECK.MULTIPARTNER
*-----------------------------------------------------------------------------
* Developer Name     : Dhio Faizar Wahyudi
* Development Date   : 20190212
* Description        : Routine to check Wokee and Channel Link when do transaction
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date            Modified by                Description
*-----------------------------------------------------------------------------

	$INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ATI.TH.EC.USERNAME
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT

*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------

	GOSUB INIT
	
	IF Y.FUNDS.TRANSFER.ATI.CHANNEL THEN
		GOSUB PROCESS
	END ELSE
		AF    = ""
		ETEXT = "EB-FT.CHECK.MULTIPARTNER.MISSING"
        CALL STORE.END.ERROR
	END

    RETURN

*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
	
	FN.CUSTOMER = "F.CUSTOMER"
	F.CUSTOMER = ""
	CALL OPF(FN.CUSTOMER, F.CUSTOMER)
	
	FN.ACCOUNT = "F.ACCOUNT"
	F.ACCOUNT = ""
	CALL OPF(FN.ACCOUNT, F.ACCOUNT)
	
	FN.ATI.TH.EC.USERNAME = "F.ATI.TH.EC.USERNAME"
	F.ATI.TH.EC.USERNAME = ""
	CALL OPF(FN.ATI.TH.EC.USERNAME, F.ATI.TH.EC.USERNAME)
	
	YAPP = "FUNDS.TRANSFER"
	YFLD = "ATI.CHANNEL"
	YPOS = ""
	
	CALL MULTI.GET.LOC.REF(YAPP, YFLD, YPOS)
	
	Y.ATI.CHANNEL.POS = YPOS<1, 1>
	
	Y.FUNDS.TRANSFER.ATI.CHANNEL = R.NEW(FT.LOCAL.REF)<1, Y.ATI.CHANNEL.POS>
	
	RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------

	Y.ACCOUNT = R.NEW(FT.DEBIT.ACCT.NO)
	CALL F.READ(FN.ACCOUNT, Y.ACCOUNT, R.ACCOUNT, F.ACCOUNT, ACCOUNT.ERR)
	Y.CUSTOMER = R.ACCOUNT<AC.CUSTOMER>
	
	CALL F.READ(FN.CUSTOMER, Y.CUSTOMER, R.CUSTOMER, F.CUSTOMER, CUSTOMER.ERR)
	Y.EMAIL = R.CUSTOMER<EB.CUS.EMAIL.1>
	
	CALL F.READ(FN.ATI.TH.EC.USERNAME, Y.EMAIL, R.ATI.TH.EC.USERNAME, F.ATI.TH.EC.USERNAME, ATI.TH.EC.USERNAME.ERR)
	Y.CHANNEL = R.ATI.TH.EC.USERNAME<EC.USER.CHANNEL>
	
	FIND Y.FUNDS.TRANSFER.ATI.CHANNEL IN Y.CHANNEL SETTING Y.AF.POS, Y.AV.POS THEN
	END ELSE
		AF    = ""
		ETEXT = "EB-FT.CHECK.MULTIPARTNER"
        CALL STORE.END.ERROR
	END
	
	RETURN
*-----------------------------------------------------------------------------
END
