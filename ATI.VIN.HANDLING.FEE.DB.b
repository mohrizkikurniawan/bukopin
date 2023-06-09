*-----------------------------------------------------------------------------
* <Rating>-30</Rating>
* 13:48:47 06 JUN 2016 * 13:33:11 06 JUN 2016 * 13:32:41 06 JUN 2016 * 13:32:02 06 JUN 2016 * 16:26:34 05 AUG 2015 * 10:04:04 05 AUG 2015 * 16:32:51 02 AUG 2015 * 16:32:25 02 AUG 2015 * 16:30:27 02 AUG 2015
* WIN-KVUAVRB60BE/R14 * WIN-KVUAVRB60BE/R14 * WIN-KVUAVRB60BE/R14 * WIN-KVUAVRB60BE/R14 * WIN-KVUAVRB60BE/R14 * WIN-KVUAVRB60BE/R14 * WIN-KVUAVRB60BE/R14 * WIN-KVUAVRB60BE/R14 * WIN-KVUAVRB60BE/R14
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.VIN.HANDLING.FEE.DB
*-----------------------------------------------------------------------------
* Developer Name     : Dwi K
* Development Date   : 20160202
* Description        : Routie for default handlingfee
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date               :
* Modified by        :
* Description        :
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.CURRENCY

*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------
    GOSUB INIT
    GOSUB PROCESS

    RETURN

*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------

    FN.CURR = "F.CURRENCY"
    F.CURR  = ""
    CALL OPF(FN.CURR,F.CURR)

    Y.APP      = 'FUNDS.TRANSFER'
    Y.APP<-1>  = 'CURRENCY'
    Y.FLD.NAME     = 'ATI.BIG.UNIT' :VM: 'ATI.SMALL.UNIT' :VM: 'ATI.CHARGE.CODE' :VM: 'ATI.CHARGE.AMT' :VM: 'ATI.HAND.FEE'
    Y.FLD.NAME<-1> = 'ATI.BIG.DENOM' :VM: 'ATI.SMALL.DENOM'
    Y.POS      = ''
    CALL MULTI.GET.LOC.REF(Y.APP,Y.FLD.NAME,Y.POS)
    ATI.BIG.UNIT.POS     = Y.POS<1,1>
    ATI.SMALL.UNIT.POS   = Y.POS<1,2>
    ATI.CHARGE.CODE.POS  = Y.POS<1,3>
    ATI.CHARGE.AMT.POS   = Y.POS<1,4>
    ATI.HAND.FEE.POS     = Y.POS<1,5>
    ATI.BIG.DENOM.POS    = Y.POS<2,1>
    ATI.SMALL.DENOM.POS  = Y.POS<2,2>

    RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    IF R.NEW(FT.DEBIT.CURRENCY) NE LCCY THEN
        IF R.NEW(FT.LOCAL.REF)<1,ATI.BIG.UNIT.POS> EQ '' THEN
            ETEXT = 'BIG UNIT IS REQUIRED'
            CALL STORE.END.ERROR
            RETURN
        END

        IF R.NEW(FT.LOCAL.REF)<1,ATI.SMALL.UNIT.POS> EQ '' THEN
            ETEXT = 'SMALL UNIT IS REQUIRED'
            CALL STORE.END.ERROR
            RETURN
        END

        IF ( R.NEW(FT.TREASURY.RATE) EQ '' ) AND ( R.NEW(FT.CREDIT.CURRENCY) NE R.NEW(FT.DEBIT.CURRENCY)) THEN
            ETEXT = 'TREASURY RATE IS REQUIRED'
            CALL STORE.END.ERROR
            RETURN
        END
    END

    Y.CREDIT.CURR = R.NEW(FT.CREDIT.CURRENCY)
    CALL F.READ(FN.CURR, Y.CREDIT.CURR, R.CURR, F.CURR, CURR.ERR)
    Y.FEE = ''

    Y.FEE  = R.NEW(FT.LOCAL.REF)<1,ATI.BIG.UNIT.POS> * R.CURR<EB.CUR.LOCAL.REF,ATI.BIG.DENOM.POS>
    Y.FEE += R.NEW(FT.LOCAL.REF)<1,ATI.SMALL.UNIT.POS> * R.CURR<EB.CUR.LOCAL.REF,ATI.SMALL.DENOM.POS>

    Y.CHARGE.CODE = R.NEW(FT.LOCAL.REF)<1,ATI.CHARGE.CODE.POS>
    LOCATE 'HANDLINGFEE' IN Y.CHARGE.CODE<1,1,1> SETTING Y.POS THEN
        IF Y.FEE NE '' THEN
            R.NEW(FT.LOCAL.REF)<1,ATI.CHARGE.AMT.POS,-1>  = Y.FEE
            R.NEW(FT.LOCAL.REF)<1,ATI.CHARGE.CODE.POS,-1> = 'HANDLINGFEE'
        END

    END

    IF R.NEW(FT.LOCAL.REF)<1,ATI.HAND.FEE.POS> EQ 'Y' THEN
        Y.TOT.CHG = SUM(R.NEW(FT.LOCAL.REF)<1,ATI.CHARGE.AMT.POS>) - Y.FEE
        R.NEW(FT.CREDIT.AMOUNT) = R.NEW(FT.RESERVED.5) - Y.TOT.CHG

        TEXT = "HANDLING FEE SHOULD BE NOTED"
        NO.OVER = DCOUNT(R.NEW(V-9),VM)+1
        CALL STORE.OVERRIDE(NO.OVER)

    END ELSE
        Y.TOT.CHG = SUM(R.NEW(FT.LOCAL.REF)<1,ATI.CHARGE.AMT.POS>)
        R.NEW(FT.CREDIT.AMOUNT) = R.NEW(FT.RESERVED.5) - Y.TOT.CHG
    END

    RETURN
*-----------------------------------------------------------------------------
END













