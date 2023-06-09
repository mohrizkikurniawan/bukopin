*-----------------------------------------------------------------------------
* <Rating>-51</Rating>
* 08:57:38 14 NOV 2017 
* JFT/t24r11 
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.VIN.FT.AC.CLOSURE
*-----------------------------------------------------------------------------
* Developer Name     : ATI Juan Felix
* Development Date   : 20171114
* Description        : Routine for calculate amount account close
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date            Modified by                Description
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ATI.TH.EC.USERNAME
    $INSERT I_F.AA.INTEREST
    $INSERT I_F.FUNDS.TRANSFER

*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------
    PRECISION 9

    GOSUB INIT
    GOSUB PROCESS

    RETURN

*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
    FN.ACCOUNT = "F.ACCOUNT"
    CALL OPF(FN.ACCOUNT, F.ACCOUNT)

    FN.CUSTOMER = "F.CUSTOMER"
    CALL OPF(FN.CUSTOMER, F.CUSTOMER)

    FN.ATI.TH.EC.USERNAME = "F.ATI.TH.EC.USERNAME"
    CALL OPF(FN.ATI.TH.EC.USERNAME, F.ATI.TH.EC.USERNAME)

    RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    Y.DEBIT.ACCT.NO = COMI
	
    CALL F.READ(FN.ACCOUNT, Y.DEBIT.ACCT.NO, R.ACCOUNT, F.ACCOUNT, ERR.ACCOUNT)
    Y.CUSTOMER        = R.ACCOUNT<AC.CUSTOMER>
    Y.WORKING.BALANCE = R.ACCOUNT<AC.WORKING.BALANCE>
    Y.ARRANGEMENT.ID  = R.ACCOUNT<AC.ARRANGEMENT.ID>

    GOSUB CALC.ACCRUE
    GOSUB GET.MAIN.ACCOUNT

    R.NEW(FT.DEBIT.AMOUNT) = DROUND(Y.WORKING.BALANCE + Y.ACCRUE.INTEREST.AMOUNT + Y.ACCRUE.INTEREST.AMOUNT.TODAY, 2)

    IF NOT(R.NEW(FT.CREDIT.ACCT.NO)) THEN
        R.NEW(FT.CREDIT.ACCT.NO) = Y.SAVING.AC
    END

    RETURN

*-----------------------------------------------------------------------------
CALC.ACCRUE:
*-----------------------------------------------------------------------------
    Y.OPTIONS<2> = "ALL"
    CALL AA.GET.PERIOD.BALANCES(Y.DEBIT.ACCT.NO, "ACCCRINTEREST", Y.OPTIONS, TODAY, TODAY, "", Y.BAL.ACCCRINTEREST, "")
    Y.ACCRUE.INTEREST.AMOUNT = ABS(Y.BAL.ACCCRINTEREST<4>)

*-Calculate accrue today------------------------------------------------------
    CALL AA.GET.PROPERTY.RECORD("", Y.ARRANGEMENT.ID, "CRINTEREST", "INTEREST", "", "", R.INTEREST, ERR.INTEREST)
    Y.RATE.TIER.TYPE   = R.INTEREST<AA.INT.RATE.TIER.TYPE>
    Y.FIXED.RATE.LIST  = R.INTEREST<AA.INT.FIXED.RATE>
    Y.FIXED.RATE.CNT   = DCOUNT(Y.FIXED.RATE.LIST, VM)
    Y.TIER.AMOUNT.LIST = R.INTEREST<AA.INT.TIER.AMOUNT>

    BEGIN CASE
    CASE Y.RATE.TIER.TYPE EQ "BAND"

    CASE Y.RATE.TIER.TYPE EQ "LEVEL"
        FOR I = 1 TO Y.FIXED.RATE.CNT
            Y.FIXED.RATE  = Y.FIXED.RATE.LIST<1, I>
            Y.TIER.AMOUNT = Y.TIER.AMOUNT.LIST<1, I>

            IF Y.WORKING.BALANCE LE Y.TIER.AMOUNT THEN
                Y.FIXED.RATE = Y.FIXED.RATE.LIST<1, I>
                BREAK
            END

            IF I EQ Y.FIXED.RATE.CNT THEN
                Y.FIXED.RATE = Y.FIXED.RATE.LIST<1, I>
            END
        NEXT I

    CASE Y.RATE.TIER.TYPE EQ "SINGLE"
        Y.FIXED.RATE = Y.FIXED.RATE.LIST<1, 1>

    END CASE

    Y.ACCRUE.INTEREST.AMOUNT.TODAY = Y.WORKING.BALANCE * (Y.FIXED.RATE / 100) * (1/365)

    RETURN

*-----------------------------------------------------------------------------
GET.MAIN.ACCOUNT:
*-----------------------------------------------------------------------------
    CALL F.READ(FN.CUSTOMER, Y.CUSTOMER, R.CUSTOMER, F.CUSTOMER, ERR.CUSTOMER)
    Y.EMAIL.1 = R.CUSTOMER<EB.CUS.EMAIL.1>

    CALL F.READ(FN.ATI.TH.EC.USERNAME, Y.EMAIL.1, R.ATI.TH.EC.USERNAME, F.ATI.TH.EC.USERNAME, ERR.ATI.TH.EC.USERNAME)
    IF R.ATI.TH.EC.USERNAME THEN
        Y.SAVING.AC = R.ATI.TH.EC.USERNAME<EC.USER.SAVING.AC>
    END

    RETURN
*-----------------------------------------------------------------------------
END
