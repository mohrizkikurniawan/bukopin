*-----------------------------------------------------------------------------
* <Rating>-181</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.VIN.FT.BSA.MAX.AMT.DB
*-----------------------------------------------------------------------------
* Developer Name     : Dwi K
* Development Date   : 20180417
* Description        : Routine to validate maximum amount debited
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
	Y.TRANS.CODE.DB = R.ATI.TH.AGENT.GLOBAL.PARAM<AGENT.PARAM.TRANS.CODE.DB>

	Y.TRANSACTION.TYPE = R.NEW(FT.TRANSACTION.TYPE)
	Y.AMOUNT           = R.NEW(FT.AMOUNT.DEBITED)[4,99]
	Y.CURR.AMOUNT.DB   = 0
	Y.TOT.AMOUNT.DB    = 0
	

    RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------

	Y.ACCOUNT  = R.NEW(FT.DEBIT.ACCT.NO)
	CALL F.READ(FN.ACCOUNT, Y.ACCOUNT, R.ACCOUNT, F.ACCOUNT, ACCT.ERR)
	Y.CUST.ID  = R.ACCOUNT<AC.CUSTOMER>
	Y.ACTVT.ID = TODAY[1,6]:'*':Y.ACCOUNT
    CALL F.READ(FN.ATI.TT.AGENT.MONTHLY.TXN.ACT, Y.ACTVT.ID, R.ATI.TT.AGENT.MONTHLY.TXN.ACT, F.ATI.TT.AGENT.MONTHLY.TXN.ACT, ATI.TT.AGENT.MONTHLY.TXN.ACT.ERR)
	Y.TRANSACTION.TYPE = R.ATI.TT.AGENT.MONTHLY.TXN.ACT<TXN.ACT.TRANS.DB>
	Y.AMOUNT.DB        = R.ATI.TT.AGENT.MONTHLY.TXN.ACT<TXN.ACT.AMOUNT.DB>
	
    CONVERT SM TO VM IN Y.TRANSACTION.TYPE
	CONVERT SM TO VM IN Y.AMOUNT.DB
	
	Y.CNT.TRX = DCOUNT(Y.TRANSACTION.TYPE, VM)
	FOR YLOOP.TRX = 1 TO Y.CNT.TRX
	    Y.TRANS.TYPE = Y.TRANSACTION.TYPE<1,YLOOP.TRX>
		
		FIND Y.TRANS.TYPE IN Y.TRANS.CODE.DB SETTING POSF.DB, POSV.DB THEN
		     Y.CURR.AMOUNT.DB = Y.AMOUNT.DB<1,YLOOP.TRX>
			 Y.TOT.AMOUNT.DB += Y.CURR.AMOUNT.DB
		END
	NEXT YLOOP.TRX
	
	Y.TOTAL.AMT = Y.TOT.AMOUNT.DB + Y.AMOUNT
	IF Y.TOTAL.AMT GT Y.MAX.AMT.DB THEN
		ETEXT = "FT-MAX.AMT.DB.AGENT"
		AF    = FT.DEBIT.AMOUNT
		CALL STORE.END.ERROR
	END
	
    RETURN
*-----------------------------------------------------------------------------
END




