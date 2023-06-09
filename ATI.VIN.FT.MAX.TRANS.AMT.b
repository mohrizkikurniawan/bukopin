*-----------------------------------------------------------------------------
    SUBROUTINE ATI.VIN.FT.MAX.TRANS.AMT
*-----------------------------------------------------------------------------
* Developer Name     : Dhio Faizar Wahyudi
* Development Date   : 20171006
* Description        : Validation Max Transaction Amount
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date               :
* Modified by        :
* Description        :
*-----------------------------------------------------------------------------
	$INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ATI.TH.TRANS.LIMIT.PARAM
    $INSERT I_F.ATI.TT.TRANS.LIMIT.PARAM.CONCAT
    $INSERT I_F.ATI.TH.TRANS.LIMIT.ACT
    $INSERT I_F.FUNDS.TRANSFER
	$INSERT I_GTS.COMMON

*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------
	Y.NO.OF.AUTH = R.VERSION(EB.VER.NO.OF.AUTH)
	
    IF V$FUNCTION EQ "R" AND Y.NO.OF.AUTH NE 0 THEN
	   RETURN
	END
	
	GOSUB INIT
	GOSUB PROCESS
	
    RETURN
	
*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
	
	FN.ATI.TH.TRANS.LIMIT.PARAM = "F.ATI.TH.TRANS.LIMIT.PARAM"
	F.ATI.TH.TRANS.LIMIT.PARAM = ""
	CALL OPF(FN.ATI.TH.TRANS.LIMIT.PARAM, F.ATI.TH.TRANS.LIMIT.PARAM)
	
	FN.ATI.TT.TRANS.LIMIT.PARAM.CONCAT = "F.ATI.TT.TRANS.LIMIT.PARAM.CONCAT"
	F.ATI.TT.TRANS.LIMIT.PARAM.CONCAT = ""
	CALL OPF(FN.ATI.TT.TRANS.LIMIT.PARAM.CONCAT, F.ATI.TT.TRANS.LIMIT.PARAM.CONCAT)
	
	FN.ATI.TH.TRANS.LIMIT.ACT = "F.ATI.TH.TRANS.LIMIT.ACT"
	F.ATI.TH.TRANS.LIMIT.ACT = ""
	CALL OPF(FN.ATI.TH.TRANS.LIMIT.ACT, F.ATI.TH.TRANS.LIMIT.ACT)
	
    RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
	
	Y.DEBIT.ACCOUNT    = R.NEW(FT.DEBIT.ACCT.NO)
	Y.DEBIT.AMOUNT     = R.NEW(FT.DEBIT.AMOUNT)
	Y.TRANSACTION.TYPE = R.NEW(FT.TRANSACTION.TYPE)
	Y.RECORD.STATUS    = R.NEW(FT.RECORD.STATUS)
	
	CALL F.READ(FN.ATI.TT.TRANS.LIMIT.PARAM.CONCAT, Y.TRANSACTION.TYPE, R.ATI.TT.TRANS.LIMIT.PARAM.CONCAT, F.ATI.TT.TRANS.LIMIT.PARAM.CONCAT, ATI.TT.TRANS.LIMIT.PARAM.CONCAT.ERR)
	IF R.ATI.TT.TRANS.LIMIT.PARAM.CONCAT EQ "" THEN
		RETURN
	END ELSE
		GOSUB GET.TRANS.LIMIT.PARAM
	END	
	
	RETURN
	
*-----------------------------------------------------------------------------
GET.TRANS.LIMIT.PARAM:
*-----------------------------------------------------------------------------
	
	Y.CNT.CONCAT = DCOUNT(R.ATI.TT.TRANS.LIMIT.PARAM.CONCAT, @FM)
	
	FOR Y.LOOP.CONCAT = 1 TO Y.CNT.CONCAT

		Y.GROUP.ID = R.ATI.TT.TRANS.LIMIT.PARAM.CONCAT<Y.LOOP.CONCAT>
		CALL F.READ(FN.ATI.TH.TRANS.LIMIT.PARAM, Y.GROUP.ID, R.ATI.TH.TRANS.LIMIT.PARAM, F.ATI.TH.TRANS.LIMIT.PARAM, ATI.TH.TRANS.LIMIT.PARAM.ERR)
		Y.TOTAL.AMOUNT.PARAM = R.ATI.TH.TRANS.LIMIT.PARAM<TRANS.LIM.PARAM.MAX.AMOUNT>
		
		Y.ATI.TH.TRANS.LIMIT.ACT.ID = ""
		Y.ATI.TH.TRANS.LIMIT.ACT.ID = TODAY : "-" : Y.DEBIT.ACCOUNT : "-" : Y.GROUP.ID
		CALL F.READU(FN.ATI.TH.TRANS.LIMIT.ACT, Y.ATI.TH.TRANS.LIMIT.ACT.ID, R.ATI.TH.TRANS.LIMIT.ACT, F.ATI.TH.TRANS.LIMIT.ACT, ATI.TH.TRANS.LIMIT.ACT.ERR, Y.RETRY)
		
		IF (V$FUNCTION EQ "R" AND Y.RECORD.STATUS EQ "" AND Y.NO.OF.AUTH EQ 0) OR (V$FUNCTION EQ "A" AND Y.RECORD.STATUS[1,1] EQ "R" AND Y.NO.OF.AUTH GT 0) OR (V$FUNCTION EQ "D" AND Y.RECORD.STATUS[1,1] EQ "I") THEN
			GOSUB PROCESS.DELETE
			BREAK
		END
		
		Y.TOTAL.AMOUNT = R.ATI.TH.TRANS.LIMIT.ACT<TRANS.LIM.ACT.TOTAL.AMOUNT> + Y.DEBIT.AMOUNT
		GOSUB CHECK.AMOUNT
	
	NEXT Y.LOOP.CONCAT

	RETURN
	
*-----------------------------------------------------------------------------
CHECK.AMOUNT:
*-----------------------------------------------------------------------------

	IF Y.TOTAL.AMOUNT GT Y.TOTAL.AMOUNT.PARAM AND Y.TOTAL.AMOUNT.PARAM NE "" THEN
		CALL F.RELEASE(FN.ATI.TH.TRANS.LIMIT.ACT, Y.ATI.TH.TRANS.LIMIT.ACT.ID, F.ATI.TH.TRANS.LIMIT.ACT)
		
		AF    = ""
		ETEXT = "EB-ATI.ONL.TRF.MAX.TRANS"
		CALL STORE.END.ERROR
		
	END ELSE
		GOSUB BUILD.RECORD
	END
	
	RETURN
	
*-----------------------------------------------------------------------------
BUILD.RECORD:
*-----------------------------------------------------------------------------
	
	R.ATI.TH.TRANS.LIMIT.ACT<TRANS.LIM.ACT.VALUE.DATE>     = TODAY
	R.ATI.TH.TRANS.LIMIT.ACT<TRANS.LIM.ACT.ACCOUNT>        = Y.DEBIT.ACCOUNT
	R.ATI.TH.TRANS.LIMIT.ACT<TRANS.LIM.ACT.GROUP.ID>       = Y.GROUP.ID
	R.ATI.TH.TRANS.LIMIT.ACT<TRANS.LIM.ACT.TRANS.ID, -1>   = ID.NEW
	R.ATI.TH.TRANS.LIMIT.ACT<TRANS.LIM.ACT.TRANS.TYPE, -1> = Y.TRANSACTION.TYPE
	R.ATI.TH.TRANS.LIMIT.ACT<TRANS.LIM.ACT.TRANS.AMT, -1>  = Y.DEBIT.AMOUNT
	R.ATI.TH.TRANS.LIMIT.ACT<TRANS.LIM.ACT.TOTAL.AMOUNT>   = SUM(R.ATI.TH.TRANS.LIMIT.ACT<TRANS.LIM.ACT.TRANS.AMT>)
	
	CALL ID.LIVE.WRITE(FN.ATI.TH.TRANS.LIMIT.ACT, Y.ATI.TH.TRANS.LIMIT.ACT.ID, R.ATI.TH.TRANS.LIMIT.ACT)
	CALL F.RELEASE(FN.ATI.TH.TRANS.LIMIT.ACT, Y.ATI.TH.TRANS.LIMIT.ACT.ID, F.ATI.TH.TRANS.LIMIT.ACT)

	RETURN
	
*-----------------------------------------------------------------------------	
PROCESS.DELETE:
*-----------------------------------------------------------------------------	

    Y.TRANS.ID.LIST = R.ATI.TH.TRANS.LIMIT.ACT<TRANS.LIM.ACT.TRANS.ID>

	FIND ID.NEW IN Y.TRANS.ID.LIST SETTING POSF.TRANS, POSV.TRANS THEN
	    
	    DEL R.ATI.TH.TRANS.LIMIT.ACT<TRANS.LIM.ACT.TRANS.ID, POSV.TRANS>
	    DEL R.ATI.TH.TRANS.LIMIT.ACT<TRANS.LIM.ACT.TRANS.TYPE, POSV.TRANS>
	    DEL R.ATI.TH.TRANS.LIMIT.ACT<TRANS.LIM.ACT.TRANS.AMT, POSV.TRANS>
		
		R.ATI.TH.TRANS.LIMIT.ACT<TRANS.LIM.ACT.TOTAL.AMOUNT>  = SUM(R.ATI.TH.TRANS.LIMIT.ACT<TRANS.LIM.ACT.TRANS.AMT>)
	
		CALL ID.LIVE.WRITE(FN.ATI.TH.TRANS.LIMIT.ACT, Y.ATI.TH.TRANS.LIMIT.ACT.ID, R.ATI.TH.TRANS.LIMIT.ACT)
		CALL F.RELEASE(FN.ATI.TH.TRANS.LIMIT.ACT, Y.ATI.TH.TRANS.LIMIT.ACT.ID, F.ATI.TH.TRANS.LIMIT.ACT)
		
	END

	RETURN
*-----------------------------------------------------------------------------	
END