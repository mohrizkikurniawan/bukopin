*-----------------------------------------------------------------------------
* <Rating>-30</Rating>
* 13:55:19 26 JUN 2015 
* WIN-KVUAVRB60BE/R14 
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.VIN.FT.CHK.TXN
*-----------------------------------------------------------------------------
* Developer Name        : ATI-YUDISTIA ADNAN
* Development Date      : 03 DECEMBER 2015
* Description           : This routine used to check FT teller transaction.
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date                      :
* Modified by           :
* Description           :
* No Log            :
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER

*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------
    GOSUB INIT
    GOSUB PROCESS

    RETURN

*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
    FN.FT = "F.FUNDS.TRANSFER"
    F.FT  = ""
    CALL OPF(FN.FT, F.FT)

    FN.FT.HIS = "F.FUNDS.TRANSFER$HIS"
    F.FT.HIS  = ""
    CALL OPF(FN.FT.HIS, F.FT.HIS)

    FN.TT.TXN = "F.ATI.TT.TELLER.TXN"
    F.TT.TXN  = ""
    CALL OPF(FN.TT.TXN,F.TT.TXN)

    Y.APP = "FUNDS.TRANSFER"
    Y.FLD = "ATI.TELLER.ID"
    Y.POS = ""
    CALL MULTI.GET.LOC.REF(Y.APP,Y.FLD,Y.POS)

    Y.TELLER.ID.POS = Y.POS<1,1>

    Y.TODAY = TODAY
    RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    Y.TT.ID  = R.NEW(FT.LOCAL.REF)<1,Y.TELLER.ID.POS>

    CALL F.READ(FN.TT.TXN, Y.TT.ID, R.TT.TXN, F.TT.TXN, ERR.TT.TXN)

    Y.TT.CNT = DCOUNT(R.TT.TXN, FM)
    Y.FT.ID  = R.TT.TXN<Y.TT.CNT>

    CALL F.READ(FN.FT, Y.FT.ID, R.FT, F.FT, ERR.FT)

    IF NOT(R.FT) THEN
        CALL EB.READ.HISTORY.REC(F.FT.HIS, Y.FT.ID, R.FT.HIS, FT.HIS.ERR)

        Y.PROCESS.DATE = R.FT.HIS<FT.PROCESSING.DATE>

        IF Y.PROCESS.DATE EQ Y.TODAY THEN
            TEXT = "FT.TELLER.CLOSE"
            NO.OVER = DCOUNT(R.NEW(V-9),VM)+1
            CALL STORE.OVERRIDE(NO.OVER)
        END

    END

    RETURN
*-----------------------------------------------------------------------------
END






