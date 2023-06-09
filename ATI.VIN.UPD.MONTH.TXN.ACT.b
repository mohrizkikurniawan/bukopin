*-----------------------------------------------------------------------------
* <Rating>-181</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.VIN.UPD.MONTH.TXN.ACT
*-----------------------------------------------------------------------------
* Developer Name     : Dwi K
* Development Date   : 20180416
* Description        : Routine for update table ATI.TT.AGENT.MONTHLY.TXN.ACT
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
	$INSERT I_F.VERSION
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
	Y.TRANS.CODE.DB = R.ATI.TH.AGENT.GLOBAL.PARAM<AGENT.PARAM.TRANS.CODE.DB>
	Y.TRANS.CODE.CR = R.ATI.TH.AGENT.GLOBAL.PARAM<AGENT.PARAM.TRANS.CODE.CR>
	
	Y.APP      = 'FUNDS.TRANSFER'
    Y.FLD.NAME = 'ATI.AGENT.ID'
    Y.POS      = ''
    CALL MULTI.GET.LOC.REF(Y.APP,Y.FLD.NAME,Y.POS)
    Y.ATI.AGENT.ID.POS  = Y.POS<1,1>
	
	Y.DATE             = TODAY[7,2]
	Y.TRANSACTION.TYPE = R.NEW(FT.TRANSACTION.TYPE)	
	Y.RECORD.STATUS    = R.NEW(FT.RECORD.STATUS)
	Y.DB.AMOUNT        = R.NEW(FT.DEBIT.AMOUNT)
	Y.CR.AMOUNT        = R.NEW(FT.CREDIT.AMOUNT)
	Y.ATI.AGENT.ID     = R.NEW(FT.LOCAL.REF)<1,Y.ATI.AGENT.ID.POS>
    Y.ACCOUNT          = ""
	Y.AMOUNT           = ""
	Y.SIGN             = ""
     
*	IF Y.DB.AMOUNT THEN
*	   Y.AMOUNT = Y.DB.AMOUNT
*	END ELSE
*	   Y.AMOUNT = Y.CR.AMOUNT
*	END
	
    RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
	Y.ACCOUNT    = R.NEW(FT.DEBIT.ACCT.NO)
	CALL F.READ(FN.ACCOUNT, Y.ACCOUNT, R.ACCOUNT, F.ACCOUNT, ACCT.ERR)
	Y.CUST.ID    = R.ACCOUNT<AC.CUSTOMER>
	IF Y.CUST.ID THEN
	   Y.ACTVT.ID   = TODAY[1,6]:'*':Y.ACCOUNT
	   Y.SIGN       = "D"
	   Y.AMOUNT     = R.NEW(FT.AMOUNT.DEBITED)[4,99]
	   GOSUB UPD.TABLE
	END
	
	Y.ACCOUNT    = R.NEW(FT.CREDIT.ACCT.NO)
	CALL F.READ(FN.ACCOUNT, Y.ACCOUNT, R.ACCOUNT, F.ACCOUNT, ACCT.ERR)
	Y.CUST.ID    = R.ACCOUNT<AC.CUSTOMER>
	IF Y.CUST.ID THEN
	   Y.ACTVT.ID   = TODAY[1,6]:'*':Y.ACCOUNT
	   Y.SIGN       = "C"
	   Y.AMOUNT     = R.NEW(FT.AMOUNT.CREDITED)[4,99]
	   GOSUB UPD.TABLE
	END

*	FIND Y.TRANSACTION.TYPE IN Y.TRANS.CODE.DB SETTING POSF.DB, POSV.DB THEN
*	     Y.ACCOUNT  = R.NEW(FT.DEBIT.ACCT.NO)
*		 Y.AMOUNT   = R.NEW(FT.AMOUNT.DEBITED)[4,99]
*		 Y.SIGN     = "D"
*		 Y.ACTVT.ID = TODAY[1,6]:'*':OPERATOR
*	     GOSUB UPD.TABLE
*	END
*
*	FIND Y.TRANSACTION.TYPE IN Y.TRANS.CODE.CR SETTING POSF.CR, POSV.CR THEN
*	     Y.ACCOUNT  = R.NEW(FT.CREDIT.ACCT.NO)
*		 Y.AMOUNT   = R.NEW(FT.AMOUNT.CREDITED)[4,99]
*		 Y.SIGN     = "C"
*		 Y.ACTVT.ID = TODAY[1,6]:'*':OPERATOR
*	     GOSUB UPD.TABLE
*	END	
	
    RETURN
*-----------------------------------------------------------------------------
UPD.TABLE:
*-----------------------------------------------------------------------------

    CALL F.READ(FN.ATI.TT.AGENT.MONTHLY.TXN.ACT, Y.ACTVT.ID, R.ATI.TT.AGENT.MONTHLY.TXN.ACT, F.ATI.TT.AGENT.MONTHLY.TXN.ACT, ATI.TT.AGENT.MONTHLY.TXN.ACT.ERR)
	Y.DATE.LIST = R.ATI.TT.AGENT.MONTHLY.TXN.ACT<TXN.ACT.DATE>
	
	Y.NO.OF.AUTH = R.VERSION(EB.VER.NO.OF.AUTH)
	
 	BEGIN CASE
	CASE (V$FUNCTION EQ "I" AND Y.RECORD.STATUS EQ "")
		GOSUB PROCESS.INPUT
	CASE (V$FUNCTION EQ "R" AND Y.RECORD.STATUS EQ "" AND Y.NO.OF.AUTH EQ 0) OR (V$FUNCTION EQ "A" AND Y.RECORD.STATUS[1,1] EQ "R" AND Y.NO.OF.AUTH GT 0) OR (V$FUNCTION EQ "D" AND Y.RECORD.STATUS[1,1] EQ "I")
	    GOSUB PROCESS.DELETE
	END CASE
	
	CALL F.WRITE(FN.ATI.TT.AGENT.MONTHLY.TXN.ACT, Y.ACTVT.ID, R.ATI.TT.AGENT.MONTHLY.TXN.ACT)
	
    RETURN
*-----------------------------------------------------------------------------
PROCESS.INPUT:
*-----------------------------------------------------------------------------
	FIND Y.DATE IN Y.DATE.LIST SETTING POSF.DT, POSV.DT THEN
	    IF Y.SIGN EQ "D" THEN
		   R.ATI.TT.AGENT.MONTHLY.TXN.ACT<TXN.ACT.TRANS.DB, POSV.DT, -1>   = Y.TRANSACTION.TYPE
		   R.ATI.TT.AGENT.MONTHLY.TXN.ACT<TXN.ACT.REF.ID.DB, POSV.DT, -1>  = ID.NEW
		   R.ATI.TT.AGENT.MONTHLY.TXN.ACT<TXN.ACT.ACCOUNT.DB, POSV.DT, -1> = Y.ACCOUNT
		   R.ATI.TT.AGENT.MONTHLY.TXN.ACT<TXN.ACT.AMOUNT.DB, POSV.DT, -1>  = Y.AMOUNT
		END ELSE
		   R.ATI.TT.AGENT.MONTHLY.TXN.ACT<TXN.ACT.TRANS.CR, POSV.DT, -1>   = Y.TRANSACTION.TYPE
		   R.ATI.TT.AGENT.MONTHLY.TXN.ACT<TXN.ACT.REF.ID.CR, POSV.DT, -1>  = ID.NEW
		   R.ATI.TT.AGENT.MONTHLY.TXN.ACT<TXN.ACT.ACCOUNT.CR, POSV.DT, -1> = Y.ACCOUNT
		   R.ATI.TT.AGENT.MONTHLY.TXN.ACT<TXN.ACT.AMOUNT.CR, POSV.DT, -1>  = Y.AMOUNT		
		END
	END ELSE
	   R.ATI.TT.AGENT.MONTHLY.TXN.ACT<TXN.ACT.DATE,-1> = Y.DATE
	   Y.CNT.DATE = DCOUNT(R.ATI.TT.AGENT.MONTHLY.TXN.ACT<TXN.ACT.DATE>, VM)
	    IF Y.SIGN EQ "D" THEN
		   R.ATI.TT.AGENT.MONTHLY.TXN.ACT<TXN.ACT.TRANS.DB, Y.CNT.DATE, -1>   = Y.TRANSACTION.TYPE
		   R.ATI.TT.AGENT.MONTHLY.TXN.ACT<TXN.ACT.REF.ID.DB, Y.CNT.DATE, -1>  = ID.NEW
		   R.ATI.TT.AGENT.MONTHLY.TXN.ACT<TXN.ACT.ACCOUNT.DB, Y.CNT.DATE, -1> = Y.ACCOUNT
		   R.ATI.TT.AGENT.MONTHLY.TXN.ACT<TXN.ACT.AMOUNT.DB, Y.CNT.DATE, -1>  = Y.AMOUNT
		END ELSE
		   R.ATI.TT.AGENT.MONTHLY.TXN.ACT<TXN.ACT.TRANS.CR, Y.CNT.DATE, -1>   = Y.TRANSACTION.TYPE
		   R.ATI.TT.AGENT.MONTHLY.TXN.ACT<TXN.ACT.REF.ID.CR, Y.CNT.DATE, -1>  = ID.NEW
		   R.ATI.TT.AGENT.MONTHLY.TXN.ACT<TXN.ACT.ACCOUNT.CR, Y.CNT.DATE, -1> = Y.ACCOUNT
		   R.ATI.TT.AGENT.MONTHLY.TXN.ACT<TXN.ACT.AMOUNT.CR, Y.CNT.DATE, -1>  = Y.AMOUNT		
		END
	END
		
    RETURN
*-----------------------------------------------------------------------------
PROCESS.DELETE:
*-----------------------------------------------------------------------------
    Y.REF.ID.DB = R.ATI.TT.AGENT.MONTHLY.TXN.ACT<TXN.ACT.REF.ID.DB>
	Y.REF.ID.CR = R.ATI.TT.AGENT.MONTHLY.TXN.ACT<TXN.ACT.REF.ID.CR>
	
  	FIND ID.NEW IN Y.REF.ID.DB SETTING POSF.DB, POSV.DB, POSS.DB THEN
		   DEL R.ATI.TT.AGENT.MONTHLY.TXN.ACT<TXN.ACT.TRANS.DB, POSV.DB, POSS.DB>
		   DEL R.ATI.TT.AGENT.MONTHLY.TXN.ACT<TXN.ACT.REF.ID.DB, POSV.DB, POSS.DB>
		   DEL R.ATI.TT.AGENT.MONTHLY.TXN.ACT<TXN.ACT.ACCOUNT.DB, POSV.DB, POSS.DB>
		   DEL R.ATI.TT.AGENT.MONTHLY.TXN.ACT<TXN.ACT.AMOUNT.DB, POSV.DB, POSS.DB>
    END
	
  	FIND ID.NEW IN Y.REF.ID.CR SETTING POSF.CR, POSV.CR, POSS.CR THEN	
		   DEL R.ATI.TT.AGENT.MONTHLY.TXN.ACT<TXN.ACT.TRANS.CR, POSV.CR, POSS.CR>
		   DEL R.ATI.TT.AGENT.MONTHLY.TXN.ACT<TXN.ACT.REF.ID.CR, POSV.CR, POSS.CR>
		   DEL R.ATI.TT.AGENT.MONTHLY.TXN.ACT<TXN.ACT.ACCOUNT.CR, POSV.CR, POSS.CR>
		   DEL R.ATI.TT.AGENT.MONTHLY.TXN.ACT<TXN.ACT.AMOUNT.CR, POSV.CR, POSS.CR>		
	END
		
    RETURN
*-----------------------------------------------------------------------------
END

