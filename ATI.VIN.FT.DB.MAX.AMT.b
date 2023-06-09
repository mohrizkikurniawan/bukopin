*-----------------------------------------------------------------------------
* <Rating>-181</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.VIN.FT.DB.MAX.AMT
*-----------------------------------------------------------------------------
* Developer Name     : Dwi K
* Development Date   : 20180417
* Description        : Routine to validate maximum amount debit
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date            Modified by                Description
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
	$INSERT I_F.ATI.TT.AGENT.MONTHLY.TXN.ACT
	$INSERT I_F.ATI.TH.AGENT.GLOBAL.PARAM
    $INSERT I_F.ACCOUNT

*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------
    GOSUB INIT
    GOSUB PROCESS

    RETURN

*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
    FN.ATI.TH.AGENT.GLOBAL.PARAM = 'F.ATI.TH.AGENT.GLOBAL.PARAM'
	F.ATI.TH.AGENT.GLOBAL.PARAM  = ''
	CALL OPF(FN.ATI.TH.AGENT.GLOBAL.PARAM, F.ATI.TH.AGENT.GLOBAL.PARAM)
	
    FN.ATI.TT.AGENT.MONTHLY.TXN.ACT = 'F.ATI.TT.AGENT.MONTHLY.TXN.ACT'
    F.ATI.TT.AGENT.MONTHLY.TXN.ACT  = ''
    CALL OPF(FN.ATI.TT.AGENT.MONTHLY.TXN.ACT,F.ATI.TT.AGENT.MONTHLY.TXN.ACT)
	
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT  = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

	CALL F.READ(FN.ATI.TH.AGENT.GLOBAL.PARAM, "SYSTEM", R.ATI.TH.AGENT.GLOBAL.PARAM, F.ATI.TH.AGENT.GLOBAL.PARAM, ATI.TH.AGENT.GLOBAL.PARAM.ERR)
	Y.MAX.AMT.DB    = R.ATI.TH.AGENT.GLOBAL.PARAM<AGENT.PARAM.MAX.AMT.DB>

	Y.TRANSACTION.TYPE = R.NEW(FT.TRANSACTION.TYPE)
	Y.AMOUNT           = R.NEW(FT.AMOUNT.DEBITED)[4,99]

    RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
	Y.ACCOUNT  = R.NEW(FT.DEBIT.ACCT.NO)
	CALL F.READ(FN.ACCOUNT, Y.ACCOUNT, R.ACCOUNT, F.ACCOUNT, ACCT.ERR)
	Y.CUST.ID  = R.ACCOUNT<AC.CUSTOMER>
	Y.ACTVT.ID = TODAY[1,6]:'*':Y.CUST.ID
    CALL F.READ(FN.ATI.TT.AGENT.MONTHLY.TXN.ACT, Y.ACTVT.ID, R.ATI.TT.AGENT.MONTHLY.TXN.ACT, F.ATI.TT.AGENT.MONTHLY.TXN.ACT, ATI.TT.AGENT.MONTHLY.TXN.ACT.ERR)
	Y.AMOUNT.DB    = R.ATI.TT.AGENT.MONTHLY.TXN.ACT<TXN.ACT.AMOUNT.DB>
	Y.TOTAL.AMT.DB = SUM(Y.AMOUNT.DB) + Y.AMOUNT
	IF Y.TOTAL.AMT.DB GT Y.MAX.AMT.DB THEN
	   ETEXT = "FT-MAX.AMT.DB.AGENT"
	   AF    = FT.DEBIT.AMOUNT
	   CALL STORE.END.ERROR
	END
	
    RETURN
*-----------------------------------------------------------------------------
END




