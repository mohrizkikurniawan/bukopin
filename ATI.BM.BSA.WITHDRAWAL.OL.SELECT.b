*-----------------------------------------------------------------------------
* <Rating>-40</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.BM.BSA.WITHDRAWAL.OL.SELECT
*-----------------------------------------------------------------------------
* Developer Name     : Dwi K
* Development Date   : 20180502
* Description        : Service BSA withdrawal
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date            Modified by                Description
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ATI.TH.AB.BTUNAI.CASHWD.RSV
    $INSERT I_ATI.BM.BSA.WITHDRAWAL.OL.COMMON

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
    SEL.CMD = "SELECT " : FN.ATI.TH.AB.BTUNAI.CASHWD.RSV : " WITH STATUS EQ 'REQUEST'"
    CALL EB.READLIST(SEL.CMD, SEL.LIST, "", SEL.CNT, SEL.ERR)

    CALL BATCH.BUILD.LIST("", SEL.LIST)

    RETURN
*-----------------------------------------------------------------------------
END
