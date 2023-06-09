    SUBROUTINE ATI.BM.AB.SEND.AGENT.DAILY.ACTIVITY.SELECT
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
    $INSERT I_ATI.BM.AB.SEND.AGENT.DAILY.ACTIVITY.COMMON

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
    LIST.PARAM<1> = ""
    LIST.PARAM<2> = FN.ATI.TH.AB.AGENT
    LIST.PARAM<3> = "AGENT.STATUS EQ 'ACTIVE'"
    LIST.PARAM<6> = ""
    LIST.PARAM<7> = ""

    CALL BATCH.BUILD.LIST(LIST.PARAM,"")

    RETURN
*-----------------------------------------------------------------------------
END
