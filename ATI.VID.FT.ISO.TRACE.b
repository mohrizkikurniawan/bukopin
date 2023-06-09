*-----------------------------------------------------------------------------
* <Rating>20</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.VID.FT.ISO.TRACE
*-----------------------------------------------------------------------------
* Developer Name     : ATI Juan Felix
* Development Date   : 20170705
* Description        : Routine ID for convert ISO Trace to FT
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date            Modified by                Description
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ATI.TT.ISO.TRACE.CONCAT

*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------
    IF COMI[1,2] NE "FT" THEN 
        GOSUB INIT
        GOSUB PROCESS
    END

    RETURN

*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
    FN.ATI.TT.ISO.TRACE.CONCAT = "F.ATI.TT.ISO.TRACE.CONCAT"
    CALL OPF(FN.ATI.TT.ISO.TRACE.CONCAT, F.ATI.TT.ISO.TRACE.CONCAT)

    RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    CALL F.READ(FN.ATI.TT.ISO.TRACE.CONCAT, COMI, R.ATI.TT.ISO.TRACE.CONCAT, F.ATI.TT.ISO.TRACE.CONCAT, ERR.ATI.TT.ISO.TRACE.CONCAT)
    IF R.ATI.TT.ISO.TRACE.CONCAT THEN
        COMI = R.ATI.TT.ISO.TRACE.CONCAT<1>
    END
    ELSE
        E = "Reference is not valid"
    END

    RETURN
*-----------------------------------------------------------------------------
END


