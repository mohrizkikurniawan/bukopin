*-----------------------------------------------------------------------------
* <Rating>-46</Rating>
* 13:38:13 29 SEP 2016 * 13:33:13 29 SEP 2016 * 12:46:22 29 SEP 2016 * 12:21:36 29 SEP 2016 * 14:54:55 19 MAR 2015 * 14:51:17 19 MAR 2015 * 16:58:29 13 MAR 2015 * 13:54:15 16 AUG 2015 * 13:48:32 16 AUG 2015 * 19:06:46 04 AUG 2015 
* WIN-KVUAVRB60BE/R14 * WIN-KVUAVRB60BE/R14 * WIN-KVUAVRB60BE/R14 * WIN-KVUAVRB60BE/R14 * WIN-KVUAVRB60BE/R14 * WIN-KVUAVRB60BE/R14 * WIN-KVUAVRB60BE/R14 * WIN-KVUAVRB60BE/R14 * WIN-KVUAVRB60BE/R14 * WIN-KVUAVRB60BE/R14 
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.VIN.FT.VAL.UD
*-----------------------------------------------------------------------------
* Developer Name     : Dwi K
* Development Date   : 20160202
* Description        : Routine for validation SP/UD , and default field UD amount in FT
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date               : Julian Gerry
* Modified by        : 20160929
* Description        : Unify all UD/SP process
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.ATI.TH.PARAM.FOREX.UD
    $INSERT I_F.ATI.TH.FOREX.CUST.UD
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER

*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------

*---20160929 Julian Gerry---
    IF R.NEW(FT.CREDIT.CURRENCY) NE LCCY AND R.NEW(FT.DEBIT.CURRENCY) EQ LCCY ELSE
        RETURN
    END
*/---20160929 Julian Gerry---
    
    GOSUB INIT
    GOSUB PROCESS

    RETURN

*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
    FN.ACC = 'F.ACCOUNT'
    F.ACC  = ''
    CALL OPF(FN.ACC,F.ACC)
    
    FN.CUST = 'F.CUSTOMER'
    F.CUST	= ''
    CALL OPF(FN.CUST, F.CUST)

    FN.FX.CUST.UD = 'F.ATI.TH.FOREX.CUST.UD'
    F.FX.CUST.UD  = ''
    CALL OPF(FN.FX.CUST.UD,F.FX.CUST.UD)

    FN.PARAM.FX.UD = 'F.ATI.TH.PARAM.FOREX.UD'
    F.PARAM.FX.UD  = ''
    CALL OPF(FN.PARAM.FX.UD,F.PARAM.FX.UD)

    Y.APP      = 'FUNDS.TRANSFER'
    Y.FLD.NAME = 'ATI.UD.SP':VM:'ATI.UD.AMT' :VM : 'ATI.WIC.FLAG' : VM : 'ATI.WIC.ID' : VM : 'ATI.RELATED.TXN'
    Y.POS      = ''
    CALL MULTI.GET.LOC.REF(Y.APP,Y.FLD.NAME,Y.POS)
    ATI.UD.SP.POS  		= Y.POS<1,1>
    ATI.UD.AMT.POS 		= Y.POS<1,2>
    ATI.WIC.FLAG.POS  = Y.POS<1,3>
    ATI.WIC.ID.POS 		= Y.POS<1,4>
    ATI.REL.TXN.POS		= Y.POS<1,5>
    Y.CUST.UD					= ""

    RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------

*---20160929 Julian Gerry---
    Y.CR.ACCT = R.NEW(FT.CREDIT.ACCT.NO)
    Y.DB.ACCT = R.NEW(FT.DEBIT.ACCT.NO)
    BEGIN CASE
    CASE NOT(NUM(Y.CR.ACCT)) AND NOT(NUM(Y.DB.ACCT))
        IF R.NEW(FT.LOCAL.REF)<1, ATI.WIC.ID.POS> EQ "Y" THEN
            Y.CUST.UD = R.NEW(FT.LOCAL.REF)<1, ATI.WIC.ID.POS>
            Y.TEMP.AF = FT.LOCAL.REF
            Y.TEMP.AV = ATI.WIC.ID.POS
        END ELSE
            Y.CUST.UD = R.NEW(FT.LOCAL.REF)<1, ATI.REL.TXN.POS>
            Y.TEMP.AF = FT.LOCAL.REF
            Y.TEMP.AV = ATI.REL.TXN.POS
            CALL F.READ (FN.CUST, Y.CUST.UD, R.CUST, F.CUST, CUST.ERR)
            IF Y.CUST.UD EQ '' OR NOT(R.CUST) THEN
                AF = Y.TEMP.AF
                AV = Y.TEMP.AV
                ETEXT = "AC-INP.MAND"
                CALL STORE.END.ERROR
                RETURN
            END
        END
        IF Y.CUST.UD EQ '' THEN
           
        END
    CASE NUM(Y.CR.ACCT)
        CALL F.READ(FN.ACC, Y.CR.ACCT, R.ACC, F.ACC, ACC.ERR)
        Y.CUST.UD = R.ACC<AC.CUSTOMER>
        Y.TEMP.AF	= FT.CREDIT.ACCT.NO
        Y.TEMP.AV = 1
    CASE NOT(NUM(Y.CR.ACCT))
        CALL F.READ(FN.ACC, Y.DB.ACCT, R.ACC, F.ACC, ACC.ERR)
        Y.CUST.UD = R.ACC<AC.CUSTOMER>
        Y.TEMP.AF	= FT.DEBIT.ACCT.NO
        Y.TEMP.AV = 1
    END CASE
*/---20160929 Julian Gerry---
    
*    Y.CREDIT.ACCT = R.NEW(FT.CREDIT.ACCT.NO)
*    CALL F.READ(FN.ACC, Y.CREDIT.ACCT, R.ACC, F.ACC, ACC.ERR)
*    Y.CUST.UD = R.ACC<AC.CUSTOMER>

    Y.ID.FX.CUST.UD = TODAY[1,6]:'*':Y.CUST.UD
    CALL F.READ(FN.FX.CUST.UD, Y.ID.FX.CUST.UD, R.FX.CUST.UD, F.FX.CUST.UD, FX.CUST.UD.ERR)
    IF NOT(R.FX.CUST.UD) THEN
        AF    = Y.TEMP.AF
        AV		= Y.TEMP.AV
        ETEXT = 'Customer Have Not Make Any Document'
        CALL STORE.END.ERROR
        RETURN
    END

    CALL F.READ(FN.PARAM.FX.UD, 'SYSTEM', R.PARAM.FX.UD, F.PARAM.FX.UD, PARAM.FX.UD.ERR)

    IF R.NEW(FT.LOCAL.REF)<1,ATI.UD.SP.POS> EQ 'SP' THEN
        Y.CUR = R.PARAM.FX.UD<UD.PARAM.SP.CURRENCY>
        GOSUB GET.AMT.CHK
        IF Y.AMT.CHK GT R.FX.CUST.UD<UD.SP.AVAILABLE.AMT> THEN
            AF    = Y.TEMP.AF
            AV		= Y.TEMP.AV
            ETEXT = 'Available Amount SP is not Enough'
            CALL STORE.END.ERROR
        END

    END ELSE
        IF R.FX.CUST.UD<UD.UD.STATUS> EQ 'DISABLE' THEN
            AF    = Y.TEMP.AF
            AV		= Y.TEMP.AV
            ETEXT = 'UD DISABLED'
            CALL STORE.END.ERROR
            RETURN
        END

        Y.CUR = R.PARAM.FX.UD<UD.PARAM.UD.CURRENCY>
        GOSUB GET.AMT.CHK
        IF Y.AMT.CHK GT R.FX.CUST.UD<UD.UD.AVAILABLE.AMT> THEN
            AF    = Y.TEMP.AF
            AV		= Y.TEMP.AV
            ETEXT = 'Available Amount UD is not Enough'
            CALL STORE.END.ERROR
        END

    END

    RETURN
*-----------------------------------------------------------------------------
GET.AMT.CHK:
*-----------------------------------------------------------------------------
    Y.DB.CUR = R.NEW(FT.DEBIT.CURRENCY)
    Y.CR.CUR = R.NEW(FT.CREDIT.CURRENCY)

    IF Y.CUR EQ Y.CR.CUR THEN
        Y.AMT.CHK = R.NEW(FT.AMOUNT.CREDITED)[4,99]
    END ELSE
        IF Y.CUR EQ Y.DB.CUR THEN
            Y.AMT.CHK = R.NEW(FT.AMOUNT.DEBITED)[4,99]
        END ELSE
            Y.AMT       = R.NEW(FT.AMOUNT.DEBITED)[4,99]
            Y.AMT.CHK   = ''
            Y.EXCH.RATE = ''
            CALL EXCHRATE(1, Y.DB.CUR, Y.AMT, Y.CUR, Y.AMT.CHK,'', Y.EXCH.RATE,'','','')
            CALL EB.ROUND.AMOUNT(Y.CUR,Y.AMT.CHK,'','')
        END
    END

    R.NEW(FT.LOCAL.REF)<1,ATI.UD.AMT.POS> = Y.AMT.CHK

    RETURN

*-----------------------------------------------------------------------------
END









