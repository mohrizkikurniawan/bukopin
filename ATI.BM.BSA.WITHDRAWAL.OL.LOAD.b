*-----------------------------------------------------------------------------
* <Rating>-30</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.BM.BSA.WITHDRAWAL.OL.LOAD
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
    FN.ATI.TH.AB.BTUNAI.CASHWD.RSV = "F.ATI.TH.AB.BTUNAI.CASHWD.RSV"
    CALL OPF(FN.ATI.TH.AB.BTUNAI.CASHWD.RSV, F.ATI.TH.AB.BTUNAI.CASHWD.RSV)

    FN.ATI.TH.AB.BTUNAI.CASHWD.RSV.HIS = "F.ATI.TH.AB.BTUNAI.CASHWD.RSV$HIS"
    CALL OPF(FN.ATI.TH.AB.BTUNAI.CASHWD.RSV.HIS, F.ATI.TH.AB.BTUNAI.CASHWD.RSV.HIS)

    RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------

    RETURN
*-----------------------------------------------------------------------------
END
