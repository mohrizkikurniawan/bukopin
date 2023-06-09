*-----------------------------------------------------------------------------
    SUBROUTINE ATI.VID.NM.CHECK.PROCESSED
*-----------------------------------------------------------------------------
* Developer Name     : Dhio Faizar Wahyudi
* Development Date   : 20170727
* Description        : Routine Checking NEED MONEY transaction
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date            Modified by                Description
*-----------------------------------------------------------------------------
	$INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ATI.TH.NEED.MONEY
	
*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------
	
	GOSUB INIT
	GOSUB PROCESS
	
    RETURN
	
*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
	FN.ATI.TH.NEED.MONEY = "F.ATI.TH.NEED.MONEY"
	F.ATI.TH.NEED.MONEY = ""
	CALL OPF(FN.ATI.TH.NEED.MONEY, F.ATI.TH.NEED.MONEY)

    RETURN
	
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
	
	Y.ATI.TH.NEED.MONEY.ID = COMI
	CALL F.READ(FN.ATI.TH.NEED.MONEY, Y.ATI.TH.NEED.MONEY.ID, R.ATI.TH.NEED.MONEY, F.ATI.TH.NEED.MONEY, ATI.TH.NEED.MONEY.ERR)
	
	IF R.ATI.TH.NEED.MONEY<NEED.MONEY.STATUS> NE "" THEN
		E = "EB-NEED.MONEY.PROCESSED"
		CALL ERR
	END
	
    RETURN
	
*-----------------------------------------------------------------------------
END
