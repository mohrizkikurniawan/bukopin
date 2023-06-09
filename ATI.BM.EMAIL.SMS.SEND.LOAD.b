*-----------------------------------------------------------------------------
* <Rating>20</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.BM.EMAIL.SMS.SEND.LOAD
*-----------------------------------------------------------------------------
* Developer Name     : ATI Juan Felix
* Development Date   : 20170703
* Description        : Batch routine for send Email / SMS
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date            Modified by                Description
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ATI.TH.EMAIL.SMS.DATA
    $INSERT I_F.ATI.TT.EMAIL.SMS.OUT
    $INSERT I_ATI.BM.EMAIL.SMS.SEND.COMMON
    $INSERT I_DE.GENERIC.DATA

*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------
    GOSUB INIT
    GOSUB PROCESS

    RETURN

*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
    FN.ATI.TH.EMAIL.SMS.DATA = "F.ATI.TH.EMAIL.SMS.DATA"
    CALL OPF(FN.ATI.TH.EMAIL.SMS.DATA, F.ATI.TH.EMAIL.SMS.DATA)

    FN.ATI.TT.EMAIL.SMS.OUT = "F.ATI.TT.EMAIL.SMS.OUT"
    CALL OPF(FN.ATI.TT.EMAIL.SMS.OUT, F.ATI.TT.EMAIL.SMS.OUT)

    RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------

    RETURN
*-----------------------------------------------------------------------------
END
