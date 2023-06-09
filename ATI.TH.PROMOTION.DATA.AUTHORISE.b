*-----------------------------------------------------------------------------
    SUBROUTINE ATI.TH.PROMOTION.DATA.AUTHORISE
*-----------------------------------------------------------------------------
* Developer Name     : Dhio Faizar Wahyudi
* Development Date   : 20180115
* Description        : Routine Authorise ATI.TH.PROMOTION.DATA
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date            Modified by                Description
*-----------------------------------------------------------------------------

	$INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ATI.TH.PROMOTION.DATA
    $INSERT I_F.ATI.TH.PROMOTION.PARAM

*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------

	GOSUB INIT
	GOSUB PROCESS
	
    RETURN

*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
	
	FN.ATI.TH.PROMOTION.PARAM = "F.ATI.TH.PROMOTION.PARAM"
	F.ATI.TH.PROMOTION.PARAM = ""
	CALL OPF(FN.ATI.TH.PROMOTION.PARAM, F.ATI.TH.PROMOTION.PARAM)
	
	Y.OFS.SOURCE = "GENERIC.OFS.PROCESS"
	
	RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------

	Y.ATI.TH.PROMOTION.PARAM.ID = R.NEW(PROMO.DATA.ID.1)
	CALL F.READU(FN.ATI.TH.PROMOTION.PARAM, Y.ATI.TH.PROMOTION.PARAM.ID, R.ATI.TH.PROMOTION.PARAM, F.ATI.TH.PROMOTION.PARAM, ATI.TH.PROMOTION.PARAM.ERR, Y.RETRY)
		
*	Y.CNT = DCOUNT(R.NEW(PROMO.DATA.MSG.IN.RESULT), @VM)
	Y.CNT = DCOUNT(R.NEW(PROMO.DATA.VALUE.DATE), @VM)
	
	Y.OFS.MESSAGE = R.NEW(PROMO.DATA.MSG.IN.RESULT)<1, Y.CNT>
	
	IF Y.OFS.MESSAGE THEN
		
*    CALL OFS.CALL.BULK.MANAGER(Y.OFS.SOURCE, Y.OFS.MESSAGE, Y.OFS.RESPONSE, Y.TXN.RESULT)    
		CALL OFS.GLOBUS.MANAGER(Y.OFS.SOURCE,Y.OFS.MESSAGE)
	
		Y.APP.ID = Y.OFS.MESSAGE["/",1,1]
		CHANGE "<requests><request>" TO "" IN Y.APP.ID
		Y.FLAG.OFS      = FIELD(Y.OFS.MESSAGE, ",", 1, 1)["/", 3, 1]
		
		IF Y.FLAG.OFS EQ "1" THEN
			Y.STATUS.RESULT = "SUCCESS"
			
			R.ATI.TH.PROMOTION.PARAM<PROMO.PAR.TOTAL.TRANS> += 1
			CALL F.WRITE(FN.ATI.TH.PROMOTION.PARAM, Y.ATI.TH.PROMOTION.PARAM.ID, R.ATI.TH.PROMOTION.PARAM)
		END ELSE
			Y.STATUS.RESULT = "ERROR"
		END
		
		R.NEW(PROMO.DATA.STATUS.RESULT)<1, Y.CNT>  = Y.STATUS.RESULT
		R.NEW(PROMO.DATA.ID.RESULT)<1, Y.CNT>      = Y.APP.ID
		
		Y.ATI.TH.PROMOTION.PARAM.MSG.OUT.RESULT = ""
		Y.LOOP.OFS.OUT        = 0
		Y.OFS.OUT.MESSAGE.CNT = LEN(Y.OFS.MESSAGE)
		Y.OFS.OUT.CNT         = Y.OFS.OUT.MESSAGE.CNT / 500
		FIND "." IN Y.OFS.OUT.CNT SETTING Y.POSF, Y.POSV, Y.POSS THEN
			Y.OFS.OUT.CNT         = FIELD(Y.OFS.OUT.CNT, ".", 1)
			Y.OFS.OUT.CNT        += 1
		END
		
		Y.LEN = 500
		Y.START = 1
		FOR Y.LOOP.OUT.CNT = 1 TO Y.OFS.OUT.CNT
			Y.ATI.TH.PROMOTION.PARAM.MSG.OUT.RESULT<1, 1, -1> = Y.OFS.MESSAGE[Y.START, Y.LEN]
			Y.START += Y.LEN
		NEXT Y.LOOP.OUT.CNT
		
		R.NEW(PROMO.DATA.MSG.OUT.RESULT)<1, Y.CNT> = Y.ATI.TH.PROMOTION.PARAM.MSG.OUT.RESULT
	
	END
	
	CALL F.RELEASE(FN.ATI.TH.PROMOTION.PARAM, Y.ATI.TH.PROMOTION.PARAM.ID, F.ATI.TH.PROMOTION.PARAM)

	
	RETURN
	
*-----------------------------------------------------------------------------
END
