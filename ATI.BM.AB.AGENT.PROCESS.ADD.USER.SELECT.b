    SUBROUTINE ATI.BM.AB.AGENT.PROCESS.ADD.USER.SELECT
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

    RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    SEL.CMD  = "SELECT " : FN.ATI.TH.AB.AGENT : " WITH AGENT.STATUS EQ 'ACTIVE'"
    SEL.CMD := " AND (USER.REG.STATUS EQ 'PROCESS' OR USER.REG.STATUS EQ 'ERROR')"
    CALL EB.READLIST(SEL.CMD, SEL.LIST, "", SEL.CNT, SEL.ERR)

    CALL BATCH.BUILD.LIST("", SEL.LIST)

    RETURN
*-----------------------------------------------------------------------------
END
