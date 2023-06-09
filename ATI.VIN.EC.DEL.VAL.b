*-----------------------------------------------------------------------------
    SUBROUTINE ATI.VIN.EC.DEL.VAL
*-----------------------------------------------------------------------------
* Developer Name     : Dhio Faizar Wahyudi
* Development Date   : 20180201
* Description        : Routine to check Onboarding status when delete user
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date            Modified by                Description
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ATI.TH.EC.USERNAME
	
*-----------------------------------------------------------------------------	
MAIN:
*-----------------------------------------------------------------------------

	GOSUB INIT
	GOSUB PROCESS
	
	RETURN
	
*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
	
	RETURN
	
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
	
	IF V$FUNCTION EQ "R" THEN
		Y.ATI.TH.EC.USERNAME.CUST.ONBOARD.ORK    = R.NEW(EC.USER.CUST.ONBOARD.ORK)
		Y.ATI.TH.EC.USERNAME.CUST.ONBOARD.STATUS = R.NEW(EC.USER.CUST.ONBOARD.STATUS)
		
		IF Y.ATI.TH.EC.USERNAME.CUST.ONBOARD.ORK NE '' AND Y.ATI.TH.EC.USERNAME.CUST.ONBOARD.STATUS NE '' THEN
			ETEXT = "EB-EC.USER.DEL"
			CALL STORE.END.ERROR
		END
	END
	
	RETURN
	
*-----------------------------------------------------------------------------
END