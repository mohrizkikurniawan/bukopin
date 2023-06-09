*-----------------------------------------------------------------------------
    SUBROUTINE ATI.TH.TRANS.LIMIT.PARAM.AUTHORISE
*-----------------------------------------------------------------------------
* Developer Name     : Dhio Faizar Wahyudi
* Development Date   : 20171011
* Description        : Table of Transfer Online Parameter
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

*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------
    GOSUB INIT
    GOSUB PROCESS

    RETURN

*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
	
	FN.ATI.TT.TRANS.LIMIT.PARAM.CONCAT = "F.ATI.TT.TRANS.LIMIT.PARAM.CONCAT"
	F.ATI.TT.TRANS.LIMIT.PARAM.CONCAT = ""
	CALL OPF(FN.ATI.TT.TRANS.LIMIT.PARAM.CONCAT, F.ATI.TT.TRANS.LIMIT.PARAM.CONCAT)
	
    RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
	Y.GROUP.ID             = ID.NEW
	Y.TRANSACTION.TYPE     = R.NEW(TRANS.LIM.PARAM.TRANSACTION.TYPE)
	Y.CNT                  = DCOUNT(Y.TRANSACTION.TYPE, @VM)
	Y.TRANSACTION.TYPE.OLD = R.OLD(TRANS.LIM.PARAM.TRANSACTION.TYPE)
	Y.CNT.OLD              = DCOUNT(Y.TRANSACTION.TYPE.OLD, @VM)
	
	GOSUB DELETE.OLD.RECORD
	GOSUB ADD.NEW.RECORD
	
	RETURN
	
*-----------------------------------------------------------------------------
DELETE.OLD.RECORD:
*-----------------------------------------------------------------------------

	FOR Y.LOOP.OLD = 1 TO Y.CNT.OLD
		Y.TRANSACTION.TYPE.OLD.CUR = Y.TRANSACTION.TYPE.OLD<1, Y.LOOP.OLD>
		LOCATE Y.TRANSACTION.TYPE.OLD.CUR IN Y.TRANSACTION.TYPE SETTING Y.POS.FM ELSE
			CALL F.READU(FN.ATI.TT.TRANS.LIMIT.PARAM.CONCAT, Y.TRANSACTION.TYPE.OLD.CUR, R.ATI.TT.TRANS.LIMIT.PARAM.CONCAT, F.ATI.TT.TRANS.LIMIT.PARAM.CONCAT, ATI.TT.TRANS.LIMIT.PARAM.CONCAT.ERR, Y.RETRY)
			IF R.ATI.TT.TRANS.LIMIT.PARAM.CONCAT THEN
				LOCATE ID.NEW IN R.ATI.TT.TRANS.LIMIT.PARAM.CONCAT SETTING Y.POS.CONCAT.FM THEN
					DEL R.ATI.TT.TRANS.LIMIT.PARAM.CONCAT<Y.POS.CONCAT.FM>
					
					IF R.ATI.TT.TRANS.LIMIT.PARAM.CONCAT EQ "" THEN
						CALL F.DELETE(FN.ATI.TT.TRANS.LIMIT.PARAM.CONCAT, Y.TRANSACTION.TYPE.OLD.CUR)
						CALL F.RELEASE(FN.ATI.TT.TRANS.LIMIT.PARAM.CONCAT, Y.TRANSACTION.TYPE.OLD.CUR, F.ATI.TT.TRANS.LIMIT.PARAM.CONCAT)
					END ELSE
						CALL F.WRITE(FN.ATI.TT.TRANS.LIMIT.PARAM.CONCAT, Y.TRANSACTION.TYPE.OLD.CUR, R.ATI.TT.TRANS.LIMIT.PARAM.CONCAT)
						CALL F.RELEASE(FN.ATI.TT.TRANS.LIMIT.PARAM.CONCAT, Y.TRANSACTION.TYPE.OLD.CUR, F.ATI.TT.TRANS.LIMIT.PARAM.CONCAT)
					END
				END
			END
		END
	NEXT Y.LOOP.OLD

	RETURN
	
*-----------------------------------------------------------------------------
ADD.NEW.RECORD:
*-----------------------------------------------------------------------------
	
	FOR Y.LOOP = 1 TO Y.CNT
		Y.TRANSACTION.TYPE.CUR = Y.TRANSACTION.TYPE<1, Y.LOOP>
		CALL F.READU(FN.ATI.TT.TRANS.LIMIT.PARAM.CONCAT, Y.TRANSACTION.TYPE.CUR, R.ATI.TT.TRANS.LIMIT.PARAM.CONCAT, F.ATI.TT.TRANS.LIMIT.PARAM.CONCAT, ATI.TT.TRANS.LIMIT.PARAM.CONCAT.ERR, Y.RETRY)
		LOCATE Y.GROUP.ID IN R.ATI.TT.TRANS.LIMIT.PARAM.CONCAT SETTING POS.GROUP ELSE
			R.ATI.TT.TRANS.LIMIT.PARAM.CONCAT<-1> = Y.GROUP.ID
			
			CALL F.WRITE(FN.ATI.TT.TRANS.LIMIT.PARAM.CONCAT, Y.TRANSACTION.TYPE.CUR, R.ATI.TT.TRANS.LIMIT.PARAM.CONCAT)
			CALL F.RELEASE(FN.ATI.TT.TRANS.LIMIT.PARAM.CONCAT, Y.TRANSACTION.TYPE.CUR, F.ATI.TT.TRANS.LIMIT.PARAM.CONCAT)
		END
	NEXT Y.LOOP
	
	RETURN
*-----------------------------------------------------------------------------
END
