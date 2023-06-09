*-----------------------------------------------------------------------------
* <Rating>-32</Rating>
* 09:57:58 05 FEB 2015 * 16:02:59 09 AUG 2015 * 16:01:38 09 AUG 2015 * 16:00:54 09 AUG 2015 * 16:58:37 28 JUL 2015
* WIN-KVUAVRB60BE/R14 * WIN-KVUAVRB60BE/R14 * WIN-KVUAVRB60BE/R14 * WIN-KVUAVRB60BE/R14 * WIN-KVUAVRB60BE/R14
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.VIN.HANDLING.FEE.CR
*-----------------------------------------------------------------------------
* Developer Name        : Novi Leo
* Development Date      : 20160127
* Description           : Routine to set charges
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.CURRENCY

*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------

    GOSUB INIT

    IF Y.CR.CUR NE LCCY THEN
        GOSUB PROCESS
    END

    RETURN

*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------

    FN.CURR = "F.CURRENCY"
    F.CURR  = ""
    CALL OPF(FN.CURR, F.CURR)

    Y.APP       = "FUNDS.TRANSFER":FM:"CURRENCY"
    Y.FLD.NAME  = "ATI.BIG.UNIT":VM:"ATI.SMALL.UNIT":VM:"ATI.CHARGE.AMT"
    Y.FLD.NAME := VM:"ATI.CHARGE.CODE":VM:"ATI.HAND.FEE"
    Y.FLD.NAME := FM:"ATI.BIG.DENOM":VM:"ATI.SMALL.DENOM"
    Y.POS       = ""
    CALL MULTI.GET.LOC.REF(Y.APP, Y.FLD.NAME, Y.POS)
    Y.BIG.UNIT.POS   = Y.POS<1,1>
    Y.SMALL.UNIT.POS = Y.POS<1,2>
    Y.CHARGE.AMT.POS = Y.POS<1,3>
    Y.CHARGE.CD.POS  = Y.POS<1,4>
    Y.HAND.FEE.POS   = Y.POS<1,5>

    Y.BIG.DENOM.POS   = Y.POS<2,1>
    Y.SMALL.DENOM.POS = Y.POS<2,2>

    Y.FEE         = ""
    Y.CR.CUR      = R.NEW(FT.CREDIT.CURRENCY)
    Y.TREASURY.RT = R.NEW(FT.TREASURY.RATE)
    Y.BIG.UNIT    = R.NEW(FT.LOCAL.REF)<1,Y.BIG.UNIT.POS>
    Y.SMALL.UNIT  = R.NEW(FT.LOCAL.REF)<1,Y.SMALL.UNIT.POS>
    Y.HAND.FEE    = R.NEW(FT.LOCAL.REF)<1,Y.HAND.FEE.POS>
    Y.CHG.AMT     = R.NEW(FT.LOCAL.REF)<1,Y.CHARGE.CD.POS>

    RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    IF Y.CR.CUR NE LCCY THEN

        IF Y.BIG.UNIT EQ '' THEN
            ETEXT = "BIG UNIT IS REQUIRED"
            AF    = FT.LOCAL.REF
            AV    = Y.BIG.UNIT.POS
            CALL STORE.END.ERROR
        END
        IF Y.SMALL.UNIT EQ '' THEN
            ETEXT = "SMALL UNIT IS REQUIRED"
            AF    = FT.LOCAL.REF
            AV    = Y.SMALL.UNIT.POS
            CALL STORE.END.ERROR
        END
        *IF Y.TREASURY.RT EQ '' THEN
            *ETEXT = "TREASURY RATE IS REQUIRED"
            *AF    = FT.TREASURY.RATE
            *CALL STORE.END.ERROR
        *END

        CALL F.READ(FN.CURR, Y.CR.CUR, R.CURR, F.CURR, CURR.ERR)
        Y.BIG.DENOM   = R.CURR<EB.CUR.LOCAL.REF,Y.BIG.DENOM.POS>
        Y.SMALL.DENOM = R.CURR<EB.CUR.LOCAL.REF,Y.SMALL.DENOM.POS>

        Y.FEE  = Y.BIG.UNIT * Y.BIG.DENOM
        Y.FEE += Y.SMALL.UNIT * Y.SMALL.DENOM

        Y.CNT.CHG.AMT = DCOUNT(Y.CHG.AMT, SM)
        Y.POS.CHG.AMT = Y.CNT.CHG.AMT + 1

        IF Y.FEE THEN
            FIND "HANDLINGFEE" IN Y.CHG.AMT SETTING POSF,POSV,POSS THEN
                R.NEW(FT.LOCAL.REF)<1,Y.CHARGE.AMT.POS,POSS> = Y.FEE
                R.NEW(FT.LOCAL.REF)<1,Y.CHARGE.CD.POS,POSS>  = "HANDLINGFEE"
            END
            ELSE
                R.NEW(FT.LOCAL.REF)<1,Y.CHARGE.AMT.POS,Y.POS.CHG.AMT> = Y.FEE
                R.NEW(FT.LOCAL.REF)<1,Y.CHARGE.CD.POS,Y.POS.CHG.AMT>  = "HANDLINGFEE"
            END
        END

    END

    IF Y.HAND.FEE EQ "Y" THEN
        TEXT        = "FT.HAND.FEE.NOTED"
        NO.OF.OVERR = DCOUNT(R.NEW(V-9),VM)+1
        CALL STORE.OVERRIDE(NO.OF.OVERR)
    END ELSE
        R.NEW(FT.DEBIT.AMOUNT) += Y.FEE
    END


    RETURN
*-----------------------------------------------------------------------------
END











