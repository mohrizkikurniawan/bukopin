*-----------------------------------------------------------------------------
    SUBROUTINE ATI.TH.SMS.MAPPING.VALIDATE
*-----------------------------------------------------------------------------
* Developer Name     : Dwi K
* Development Date   : 20180406
* Description        : Validate field SMS Mapping
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date            Modified by                Description
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ATI.TH.SMS.MAPPING
    $INSERT I_F.STANDARD.SELECTION

*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------
    GOSUB INIT
    GOSUB PROCESS

    RETURN

*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
    FN.STANDARD.SELECTION = "F.STANDARD.SELECTION"
    CALL OPF(FN.STANDARD.SELECTION, F.STANDARD.SELECTION)

    RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    Y.APPLICATION     = R.NEW(SMS.MAP.APPLICATION)
    Y.FIELD.NAME.LIST = R.NEW(SMS.MAP.FIELD.NAME)
    Y.FIELD.NAME.CNT  = DCOUNT(Y.FIELD.NAME.LIST, VM)

    CALL F.READ(FN.STANDARD.SELECTION, Y.APPLICATION, R.STANDARD.SELECTION, F.STANDARD.SELECTION, ERR.STANDARD.SELECTION)
    Y.SS.FIELD.NAME.LIST = R.STANDARD.SELECTION<SSL.SYS.FIELD.NAME> : VM : R.STANDARD.SELECTION<SSL.USR.FIELD.NAME>

    FOR I = 1 TO Y.FIELD.NAME.CNT
        Y.FIELD.NAME = Y.FIELD.NAME.LIST<1, I>
        FIND Y.FIELD.NAME IN Y.SS.FIELD.NAME.LIST SETTING POSF, POSV, POSS THEN END ELSE
            AF    = SMS.MAP.FIELD.NAME
            AV    = I
            ETEXT = "EB-FIELD.NO.FOUND"
            CALL STORE.END.ERROR
        END
    NEXT I

    RETURN
*-----------------------------------------------------------------------------
END

