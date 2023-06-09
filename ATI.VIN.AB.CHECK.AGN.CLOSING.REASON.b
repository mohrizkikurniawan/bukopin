*-----------------------------------------------------------------------------
    SUBROUTINE ATI.VIN.AB.CHECK.AGN.CLOSING.REASON
*-----------------------------------------------------------------------------
* Developer Name     : Fatkhur Rohman
* Development Date   : 20180525
* Description        : Routine to check agent closing reason
*                      field OTH.CLOSE.RESN is mandatory if user choose closing reason
*                      "3 - Lainnya (wajib mengisi alasan penutupan)"
*
*                      for Agent Banking (lakupandai)
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date               :
* Modified by        :
* Description        :
*-----------------------------------------------------------------------------
	$INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ATI.TU.AB.AGENT.CLOSURE
	
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
	Y.CLOSING.REASON = R.NEW(AB.AGN.CLS.CLOSING.REASON)
	Y.OTH.CLOSE.RESN = R.NEW(AB.AGN.CLS.OTH.CLOSE.RESN)
	
	IF (Y.CLOSING.REASON EQ '3') AND NOT(Y.OTH.CLOSE.RESN) THEN
		AF    = AB.AGN.CLS.OTH.CLOSE.RESN
*		AV    = 1
		ETEXT = 'EB-MAND.INP'
		CALL STORE.END.ERROR
	END
	
	IF (Y.CLOSING.REASON NE '3') AND (Y.OTH.CLOSE.RESN) THEN
		AF    = AB.AGN.CLS.OTH.CLOSE.RESN
*		AV    = 1
		ETEXT = 'EB-AB.MUST.BE.BLANK'
		CALL STORE.END.ERROR
	END

	RETURN

*-----------------------------------------------------------------------------	
END
