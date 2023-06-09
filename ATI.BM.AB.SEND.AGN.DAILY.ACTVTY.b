    SUBROUTINE ATI.BM.AB.SEND.AGN.DAILY.ACTVTY(Y.ID)
*-----------------------------------------------------------------------------
* Developer Name     : Fatkhur Rohman
* Development Date   : 20180724
* Description        : Subroutine to send agent daily activity summary via email
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date            Modified by                Description
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
	$INSERT I_F.ATI.TH.AB.AGENT
	$INSERT I_F.ATI.TH.AGENT.ACTIVITY.SUM
    $INSERT I_ATI.BM.AB.SEND.AGN.DAILY.ACTVTY.COMMON

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
    Y.AGENT.ID = Y.ID
	CALL F.READ(FN.ATI.TH.AB.AGENT, Y.AGENT.ID, R.ATI.TH.AB.AGENT, F.ATI.TH.AB.AGENT, ERR.ATI.TH.AB.AGENT)
	
	Y.AAS.ID = Y.AGENT.ID :'-': Y.TODAY
	CALL F.READ(FN.ATI.TH.AGENT.ACTIVITY.SUM, Y.AAS.ID, R.ATI.TH.AGENT.ACTIVITY.SUM, F.ATI.TH.AGENT.ACTIVITY.SUM, ERR.ATI.TH.AGENT.ACTIVITY.SUM)
	
	R.ATI.TH.AGENT.ACTIVITY.SUM<AGN.ACTVY.SUM.AGENT.ID>      = Y.AGENT.ID
	R.ATI.TH.AGENT.ACTIVITY.SUM<AGN.ACTVY.SUM.NAME>          = R.ATI.TH.AB.AGENT<AB.AGN.NAME>
	R.ATI.TH.AGENT.ACTIVITY.SUM<AGN.ACTVY.SUM.ACTIVITY.DATE> = Y.TODAY
	
    GOSUB GEN.PDF.FILE
	
	R.ATI.TH.AGENT.ACTIVITY.SUM<AGN.ACTVY.SUM.PDF.FILE> = Y.PDF.FILE
	
	IF NOT(Y.ERROR.MESSAGE) THEN
		R.ATI.TH.AGENT.ACTIVITY.SUM<AGN.ACTVY.SUM.PDF.STATUS> = 'DONE'
		R.ATI.TH.AGENT.ACTIVITY.SUM<AGN.ACTVY.SUM.ERROR.MSG>  = ''
	END ELSE
		R.ATI.TH.AGENT.ACTIVITY.SUM<AGN.ACTVY.SUM.PDF.STATUS> = 'ERROR'
		R.ATI.TH.AGENT.ACTIVITY.SUM<AGN.ACTVY.SUM.ERROR.MSG>  = Y.ERROR.MESSAGE
	END

    GOSUB SEND.EMAIL
	
	CALL ID.LIVE.WRITE(FN.ATI.TH.AGENT.ACTIVITY.SUM, Y.AAS.ID, R.ATI.TH.AGENT.ACTIVITY.SUM)

    RETURN

*-----------------------------------------------------------------------------
GEN.PDF.FILE:
*-----------------------------------------------------------------------------
    Y.PDF.MAPPING = 'AGENT.DAILY.ACTIVITY'

    Y.APPLICATION = 'ATI.TH.AB.AGENT'
	R.APP         = R.ATI.TH.AB.AGENT

    CALL ATI.CONV.HTML2PDF.PROCESS(Y.PDF.MAPPING, Y.APPLICATION, R.APP, Y.PDF.FILE, Y.ERROR.MESSAGE)

    RETURN

*-----------------------------------------------------------------------------
SEND.EMAIL:
*-----------------------------------------------------------------------------
	Y.CUSTOMER = R.ATI.TH.AB.AGENT<AB.AGN.CUSTOMER.ID>
	Y.TO       = R.ATI.TH.AB.AGENT<AB.AGN.EMAIL>
    Y.APP      = 'ATI.TH.AGENT.ACTIVITY.SUM'
	R.APP      = R.ATI.TH.AGENT.ACTIVITY.SUM
    
    CALL ATI.EMAIL.SMS.WRITE("EMAIL", "AGENT.ACTIVITY.SUMMARY", Y.CUSTOMER, Y.TO, Y.APP, "", R.APP, Y.ERROR)

    RETURN

*-----------------------------------------------------------------------------
END
