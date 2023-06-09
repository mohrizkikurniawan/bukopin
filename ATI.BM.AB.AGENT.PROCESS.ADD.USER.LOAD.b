    SUBROUTINE ATI.BM.AB.AGENT.PROCESS.ADD.USER.LOAD
*-----------------------------------------------------------------------------
* Developer Name     : Fatkhur Rohman
* Development Date   : 20180711
* Description        : Subroutine to process add user agent
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date            Modified by                Description
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ATI.BM.AB.AGENT.PROCESS.ADD.USER.COMMON

*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------
    GOSUB INIT
    GOSUB PROCESS

    RETURN

*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
	FN.EB.EXTERNAL.USER = "F.EB.EXTERNAL.USER"
	CALL OPF(FN.EB.EXTERNAL.USER, F.EB.EXTERNAL.USER)
	
	FN.ATI.TH.AB.AGENT = "F.ATI.TH.AB.AGENT"
	CALL OPF(FN.ATI.TH.AB.AGENT, F.ATI.TH.AB.AGENT)
	
	FN.ATI.TH.INTF.INBOUND.WS.MAPPING = "F.ATI.TH.INTF.INBOUND.WS.MAPPING"
	CALL OPF(FN.ATI.TH.INTF.INBOUND.WS.MAPPING, F.ATI.TH.INTF.INBOUND.WS.MAPPING)
	
	Y.EXP.CHARS  = "`~!@#$%^&*()-_=+[{]}\|;:'"
	Y.EXP.CHARS := '",<.>/?1234567890'

    RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------

    RETURN
*-----------------------------------------------------------------------------
END
