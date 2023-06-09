*-----------------------------------------------------------------------------
    SUBROUTINE ATI.BM.CREATE.CASHBACK(Y.ID.CONCAT)
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
	
	Y.TIME.NOW = CHANGE(OCONV(TIME(), "MT" ),":","")
		
    RETURN
	
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
	
	Y.ATI.TH.PROMOTION.DATA.ID = FIELD(Y.ID.CONCAT, "_", 1)
	Y.VM                       = FIELD(Y.ID.CONCAT, "_", 2)
	
	CALL F.READU(FN.ATI.TH.PROMOTION.DATA, Y.ATI.TH.PROMOTION.DATA.ID, R.ATI.TH.PROMOTION.DATA, F.ATI.TH.PROMOTION.DATA, ATI.TH.PROMOTION.DATA.ERR, Y.RETRY)
	Y.ATI.TH.PROMOTION.DATA.DATE.TIME.TRANS = R.ATI.TH.PROMOTION.DATA<PROMO.DATA.DATE.TIME.TRANS, Y.VM>
	Y.ATI.TH.PROMOTION.DATA.STATUS          = R.ATI.TH.PROMOTION.DATA<PROMO.DATA.STATUS.RESULT, Y.VM>
	Y.ATI.TH.PROMOTION.DATA.MSG.IN          = R.ATI.TH.PROMOTION.DATA<PROMO.DATA.MSG.IN.RESULT, Y.VM>
	Y.ATI.TH.PROMOTION.PARAM.ID             = R.ATI.TH.PROMOTION.DATA<PROMO.DATA.ID.1>
	
	GOSUB GET.TIME ;* Calculate Buffer time based on Parameter(ATI.TH.INTF.GLOBAL.PARAM)
	
	IF Y.ATI.TH.PROMOTION.DATA.STATUS EQ "" AND Y.TIME.NOW GT Y.BUFFER.TIME THEN
		IF Y.ATI.TH.PROMOTION.DATA.MSG.IN NE "" THEN
			GOSUB PROCESS.PROMO
			GOSUB UPDATE.ATI.TH.PROMOTION.DATA
			GOSUB DELETE.PROMO.CONCAT
		END
	END
	
	CALL F.RELEASE(FN.ATI.TH.PROMOTION.DATA, Y.ATI.TH.PROMOTION.DATA.ID, F.ATI.TH.PROMOTION.DATA)
	
    RETURN
*-----------------------------------------------------------------------------
GET.TIME:
*-----------------------------------------------------------------------------
	
	Y.MINUTE = Y.ATI.TH.PROMOTION.DATA.DATE.TIME.TRANS[9,2]
	Y.HOUR   = Y.ATI.TH.PROMOTION.DATA.DATE.TIME.TRANS[7,2]
	
	Y.MINUTE += Y.ATI.TH.INTF.GLOBAL.PARAM.BUFFER.PROMO
	
	IF Y.MINUTE GT 60 THEN
		Y.MINUTE -= 60
		Y.HOUR   += 1
	END
	
	IF LEN(Y.MINUTE) EQ "1" THEN
		Y.MINUTE = "0":Y.MINUTE
	END
	
	IF LEN(Y.HOUR) EQ "1" THEN
		Y.HOUR = "0":Y.HOUR
	END
	
	Y.BUFFER.TIME = Y.HOUR:Y.MINUTE

	RETURN
*-----------------------------------------------------------------------------
PROCESS.PROMO:
*-----------------------------------------------------------------------------
	
	Y.OFS.SOURCE   = "GENERIC.OFS.PROCESS"
	Y.OFFLINE.FLAG = ""
	Y.OFS.LOG.NAME = "LOG.ERROR"
	
	Y.OFS.MESSAGE = Y.ATI.TH.PROMOTION.DATA.MSG.IN
	
	CALL OFS.CALL.BULK.MANAGER(Y.OFS.SOURCE, Y.OFS.MESSAGE, Y.OFS.RESPONSE, Y.TXN.RESULT)

	RETURN
*-----------------------------------------------------------------------------
DELETE.PROMO.CONCAT:
*-----------------------------------------------------------------------------
	
	CALL F.DELETE(FN.ATI.TT.PROMOTION.DATA.CONCAT, Y.ID.CONCAT)
	
	RETURN
*-----------------------------------------------------------------------------
UPDATE.ATI.TH.PROMOTION.DATA:
*-----------------------------------------------------------------------------
	
	Y.APP.ID = Y.OFS.RESPONSE["/",1,1]
    CHANGE "<requests><request>" TO "" IN Y.APP.ID
    Y.FLAG.OFS      = FIELD(Y.OFS.RESPONSE, ",", 1, 1)["/", 3, 1]
    Y.ERROR.MESSAGE = FIELD(Y.OFS.RESPONSE, "," , 2, 1)
	
	IF Y.FLAG.OFS EQ "1" THEN
		Y.STATUS = "SUCCESS"
		
		CALL F.READU(FN.ATI.TH.PROMOTION.PARAM, Y.ATI.TH.PROMOTION.PARAM.ID, R.ATI.TH.PROMOTION.PARAM, F.ATI.TH.PROMOTION.PARAM, ATI.TH.PROMOTION.PARAM.ERR, Y.RETRY.PARAM)
		
		R.ATI.TH.PROMOTION.PARAM<PROMO.PAR.TOTAL.TRANS> += 1
		
		CALL F.WRITE(FN.ATI.TH.PROMOTION.PARAM, Y.ATI.TH.PROMOTION.PARAM.ID, R.ATI.TH.PROMOTION.PARAM)
		CALL F.RELEASE(FN.ATI.TH.PROMOTION.PARAM, Y.ATI.TH.PROMOTION.PARAM.ID, F.ATI.TH.PROMOTION.PARAM)
	END ELSE
		Y.STATUS = "ERROR"
	END
	
	R.ATI.TH.PROMOTION.DATA<PROMO.DATA.STATUS.RESULT, Y.VM> = Y.STATUS
	R.ATI.TH.PROMOTION.DATA<PROMO.DATA.ID.RESULT, Y.VM>     = Y.APP.ID
	
	Y.ATI.TH.PROMOTION.PARAM.MSG.OUT.RESULT = ""
	Y.LOOP.OFS.OUT                          = 0
	Y.OFS.OUT.MESSAGE.CNT                   = LEN(Y.OFS.RESPONSE)
	Y.OFS.OUT.CNT                           = Y.OFS.OUT.MESSAGE.CNT / 500
	FINDSTR "." IN Y.OFS.OUT.CNT SETTING Y.POSF, Y.POSV, Y.POSS THEN
		Y.OFS.OUT.CNT         = FIELD(Y.OFS.OUT.CNT, ".", 1)
		Y.OFS.OUT.CNT        += 1
	END
	
	Y.LEN = 500
	Y.START = 1
	FOR Y.LOOP.OUT.CNT = 1 TO Y.OFS.OUT.CNT
		Y.ATI.TH.PROMOTION.PARAM.MSG.OUT.RESULT<1, 1, -1> = Y.OFS.RESPONSE[Y.START, Y.LEN]
		Y.START += Y.LEN
	NEXT Y.LOOP.OUT.CNT
	R.ATI.TH.PROMOTION.DATA<PROMO.DATA.MSG.OUT.RESULT, Y.VM> = Y.ATI.TH.PROMOTION.PARAM.MSG.OUT.RESULT
	
	CALL F.WRITE(FN.ATI.TH.PROMOTION.DATA, Y.ATI.TH.PROMOTION.DATA.ID, R.ATI.TH.PROMOTION.DATA)
		
	RETURN
*-----------------------------------------------------------------------------
END


