*-----------------------------------------------------------------------------
* <Rating>-40</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.BM.DEL.RECORD.NAU(Y.ID)
*-----------------------------------------------------------------------------
* Developer Name     : Novi Leo
* Development Date   : 20151030
* Description        : Delete INAU Record based on parameter
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date               :
* Modified by        :
* Description        :
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FILE.CONTROL
    $INSERT I_ATI.BM.DEL.RECORD.NAU.COMMON
    $INSERT I_BATCH.FILES

*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------

    GOSUB INIT
    GOSUB PROCESS

    RETURN

*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
    Y.FILE.NAME = CONTROL.LIST<1,1>
    Y.FILE.ID   = Y.ID

    FN.FILE.NAU = "F.":Y.FILE.NAME:"$NAU"
    CALL OPF(FN.FILE.NAU, F.FILE.NAU)

    CALL GET.STANDARD.SELECTION.DETS(Y.FILE.NAME,R.STANDARD.SELECTION)
    CALL FIELD.NAMES.TO.NUMBERS('CO.CODE', R.STANDARD.SELECTION, Y.CO.CODE.POS, "", "", "", "", ERR.MSG)

    RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    CALL F.READ(FN.FILE.NAU, Y.FILE.ID, R.FILE.NAU, F.FILE.NAU, ERR.FILE.NAU)
    Y.CO.CODE = R.FILE.NAU<Y.CO.CODE.POS>

    Y.OFS.SOURCE = "GENERIC.OFS.PROCESS"
    Y.OFS.MESSAGE = Y.FILE.NAME:",/D/PROCESS//0,//":Y.CO.CODE:"," :Y.FILE.ID

    CALL OFS.GLOBUS.MANAGER(Y.OFS.SOURCE, Y.OFS.MESSAGE)

    RETURN
*-----------------------------------------------------------------------------
END






