*-----------------------------------------------------------------------------
* <Rating>-30</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.BM.CARDLESS.WITHDRAWAL.OL.LOAD
*-----------------------------------------------------------------------------
* Developer Name     : ATI Juan Felix
* Development Date   : 20170620
* Description        : Service cardless withdrawal
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date            Modified by                Description
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ATI.TH.CARDLESS.WITHDRAWAL
    $INSERT I_ATI.BM.CARDLESS.WITHDRAWAL.OL.COMMON

*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------
    GOSUB INIT
    GOSUB PROCESS

    RETURN

*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
    FN.ATI.TH.CARDLESS.WITHDRAWAL = "F.ATI.TH.CARDLESS.WITHDRAWAL"
    CALL OPF(FN.ATI.TH.CARDLESS.WITHDRAWAL, F.ATI.TH.CARDLESS.WITHDRAWAL)

    FN.ATI.TH.CARDLESS.WITHDRAWAL.HIS = "F.ATI.TH.CARDLESS.WITHDRAWAL$HIS"
    CALL OPF(FN.ATI.TH.CARDLESS.WITHDRAWAL.HIS, F.ATI.TH.CARDLESS.WITHDRAWAL.HIS)

    FN.ATI.TT.ISO.TRACE.CONCAT = "F.ATI.TT.ISO.TRACE.CONCAT"
    CALL OPF(FN.ATI.TT.ISO.TRACE.CONCAT, F.ATI.TT.ISO.TRACE.CONCAT)

    RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------

    RETURN
*-----------------------------------------------------------------------------
END
