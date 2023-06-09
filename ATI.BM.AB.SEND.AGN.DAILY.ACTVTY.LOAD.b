    SUBROUTINE ATI.BM.AB.SEND.AGN.DAILY.ACTVTY.LOAD
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
    $INSERT I_ATI.BM.AB.SEND.AGN.DAILY.ACTVTY.COMMON
	$INSERT I_F.DATES

*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------
    GOSUB INIT
    GOSUB PROCESS

    RETURN

*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
	FN.ATI.TH.AB.AGENT = 'F.ATI.TH.AB.AGENT'
	CALL OPF(FN.ATI.TH.AB.AGENT, F.ATI.TH.AB.AGENT)
	
	FN.ATI.TH.AGENT.ACTIVITY.SUM = 'F.ATI.TH.AGENT.ACTIVITY.SUM'
	CALL OPF(FN.ATI.TH.AGENT.ACTIVITY.SUM, F.ATI.TH.AGENT.ACTIVITY.SUM)
	
*Y.TODAY = TODAY
	Y.TODAY = R.DATES(EB.DAT.LAST.WORKING.DAY)

    RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------

    RETURN
*-----------------------------------------------------------------------------
END
