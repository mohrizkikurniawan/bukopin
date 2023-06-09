*-----------------------------------------------------------------------------
* <Rating>-30</Rating>
* 14:12:28 26 JUN 2015 * 13:55:19 26 JUN 2015
* WIN-KVUAVRB60BE/R14 * WIN-KVUAVRB60BE/R14
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.VIN.FT.CHK.DENOM
*-----------------------------------------------------------------------------
* Create by   : Shokhib
* Create Date : 03 Des 2015
* Description : Routine to defaulting TELLER.ID
*-----------------------------------------------------------------------------
* Modification History:
* Mod by      :
* Mod date    :
* Mod Reason  :
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.ATI.TH.TELLER.DENOM

    GOSUB INIT
    GOSUB PROCESS

    RETURN

*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
    FN.DENOM  = 'F.ATI.TH.TELLER.DENOM'
    F.DENOM   = ''
    CALL OPF(FN.DENOM,F.DENOM)

    FN.FT = 'F.FUNDS.TRANSFER'
    F.FT  = ''
    CALL OPF(FN.FT,F.FT)

    Y.APP    = 'FUNDS.TRANSFER'
    Y.FIELD  = 'ATI.DENOM' : VM : 'ATI.DENOM.UNIT' : VM : 'ATI.TOT.DEN.AMT'
    LREF.POS = ''

    CALL MULTI.GET.LOC.REF(Y.APP, Y.FIELD, LREF.POS)
    Y.DENOM.POS      = LREF.POS<1,1>
    Y.DENOM.UNIT.POS = LREF.POS<1,2>
    Y.DENOM.AMT.POS  = LREF.POS<1,3>

    Y.DENOM         = R.NEW(FT.LOCAL.REF)<1,Y.DENOM.POS>
    Y.DENOM.UNIT    = R.NEW(FT.LOCAL.REF)<1,Y.DENOM.UNIT.POS>
    Y.TOT.DENOM.AMT = R.NEW(FT.LOCAL.REF)<1,Y.DENOM.AMT.POS>
    Y.DEBIT.AMT     = R.NEW(FT.DEBIT.AMOUNT)
    Y.CREDIT.ACCT   = R.NEW(FT.CREDIT.ACCT.NO)

    RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------

    CALL F.READ(FN.DENOM, Y.CREDIT.ACCT, R.DENOM, F.DENOM, DENOM.ERR)
    IF R.DENOM THEN
        Y.DENOM.TT      = R.DENOM<TILL.DNM.DENOMINATION>
        Y.DENOM.UNIT.TT = R.DENOM<TILL.DNM.UNIT>

        Y.DENOM.REC      = Y.DENOM.TT
        Y.DENOM.UNIT.REC = Y.DENOM.UNIT.TT

        Y.DNM.MAX = DCOUNT(Y.DENOM,SM)

        FOR I = 1 TO Y.DNM.MAX
            IF Y.DENOM.UNIT<1,1,I> NE '' THEN
                GOSUB CHECK.DENOM.UNIT
            END
        NEXT I

        Y.TOTAL.AMT = SUM(Y.TOT.DENOM.AMT)
        IF Y.TOTAL.AMT NE Y.DEBIT.AMT THEN
            ETEXT = 'FT-ERR.AMOUNT'
            AF    = FT.LOCAL.REF
            AV    = Y.DENOM.AMT.POS
            AS    = Y.DNM.MAX
            CALL STORE.END.ERROR
        END
    END ELSE
        ETEXT = 'EB-FT.DENOM.FIND.ERROR'
        AF    = FT.LOCAL.REF
        AV    = Y.DENOM.POS
        AS    = Y.DNM.MAX
        CALL STORE.END.ERROR
    END

    RETURN

*-------------------------------------------------------------------------------
CHECK.DENOM.UNIT:
*-------------------------------------------------------------------------------
    FIND Y.DENOM<1,1,I> IN Y.DENOM.REC SETTING POSFM, POSVM, POSSM THEN
        Y.DNM.POS = Y.DENOM.UNIT.REC<POSFM,POSVM,POSSM>

        IF Y.DENOM.UNIT<1,1,I> GT Y.DNM.POS THEN
            ETEXT = 'EB-FT.DENOM.ERROR'
            AF    = FT.LOCAL.REF
            AV    = Y.DENOM.POS
            AS    = I
            CALL STORE.END.ERROR
        END
    END ELSE
        ETEXT = 'EB-FT.DENOM.ERROR'
        AF    = FT.LOCAL.REF
        AV    = Y.DENOM.POS
        AS    = I
        CALL STORE.END.ERROR
    END

    RETURN
*-------------------------------------------------------------------------------
END























