*-----------------------------------------------------------------------------
* <Rating>26</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.VIN.FT.CARDLESS.WTD
*-----------------------------------------------------------------------------
* Developer Name     : ATI Juan Felix
* Development Date   : 20170619
* Description        : Funds Transfer validate and create record cardless withdrawal
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date            Modified by                Description
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ATI.TH.CARDLESS.WITHDRAWAL
    $INSERT I_F.ATI.TH.CARDLESS.WITHDRAWAL.ACT
    $INSERT I_F.ATI.TH.INTF.GLOBAL.PARAM

*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------
    IF V$FUNCTION EQ "R" THEN RETURN

    AF.TEMP = AF
    AV.TEMP = AV

    GOSUB INIT
    GOSUB PROCESS

    AF = AF.TEMP
    AV = AV.TEMP

    RETURN

*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
    FN.CUSTOMER = "F.CUSTOMER"
    CALL OPF(FN.CUSTOMER, F.CUSTOMER)

    FN.ATI.TH.CARDLESS.WITHDRAWAL = "F.ATI.TH.CARDLESS.WITHDRAWAL"
    CALL OPF(FN.ATI.TH.CARDLESS.WITHDRAWAL, F.ATI.TH.CARDLESS.WITHDRAWAL)

    FN.ATI.TH.CARDLESS.WITHDRAWAL.ACT = "F.ATI.TH.CARDLESS.WITHDRAWAL.ACT"
    CALL  OPF(FN.ATI.TH.CARDLESS.WITHDRAWAL.ACT, F.ATI.TH.CARDLESS.WITHDRAWAL.ACT)

    FN.ATI.TH.INTF.GLOBAL.PARAM = "F.ATI.TH.INTF.GLOBAL.PARAM"
    CALL OPF(FN.ATI.TH.INTF.GLOBAL.PARAM, F.ATI.TH.INTF.GLOBAL.PARAM)

    Y.APP = "FUNDS.TRANSFER"
    Y.FLD = "ATI.CL.WTD"
    Y.POS = ""
    CALL MULTI.GET.LOC.REF(Y.APP, Y.FLD, Y.POS)
    Y.ATI.CL.WTD.POS  = Y.POS<1,1>

    Y.DATE      = OCONV(DATE(),"D-")
    Y.TIME      = TIMEDATE()
    Y.DATE.TIME = Y.DATE[9,2]:Y.DATE[1,2]:Y.DATE[4,2]:Y.TIME[1,2]:Y.TIME[4,2]

    Y.REF.ID = ""

    RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    Y.CUSTOMER.ID   = R.NEW(FT.DEBIT.CUSTOMER)
    Y.DEBIT.ACCT.NO = R.NEW(FT.DEBIT.ACCT.NO)
    Y.DEBIT.AMOUNT  = R.NEW(FT.DEBIT.AMOUNT)

    CALL F.READ(FN.CUSTOMER, Y.CUSTOMER.ID, R.CUSTOMER, F.CUSTOMER, ERR.CUSTOMER)
    Y.SMS.1 = R.CUSTOMER<EB.CUS.SMS.1>
    CHANGE "+62" TO "0" IN Y.SMS.1

    CALL F.READ(FN.ATI.TH.INTF.GLOBAL.PARAM, "SYSTEM", R.ATI.TH.INTF.GLOBAL.PARAM, F.ATI.TH.INTF.GLOBAL.PARAM, ERR.ATI.TH.INTF.GLOBAL.PARAM)
    Y.COT.WTD.ATM = R.ATI.TH.INTF.GLOBAL.PARAM<GLOBAL.PARAM.COT.WTD.ATM>
    Y.REF.WTD.LEN = R.ATI.TH.INTF.GLOBAL.PARAM<GLOBAL.PARAM.REF.WTD.LEN>
    Y.MAX.WTD.AMT = R.ATI.TH.INTF.GLOBAL.PARAM<GLOBAL.PARAM.MAX.WTD.AMT>

    GOSUB VALIDATE
    GOSUB INPUT

    RETURN

*-----------------------------------------------------------------------------
VALIDATE:
*-----------------------------------------------------------------------------
*-Validate max transaction per day--------------------------------------------
    Y.CARDLESS.WITHDRAWAL.ACT.ID = Y.SMS.1 : "-" : TODAY
    CALL F.READ(FN.ATI.TH.CARDLESS.WITHDRAWAL.ACT, Y.CARDLESS.WITHDRAWAL.ACT.ID, R.ATI.TH.CARDLESS.WITHDRAWAL.ACT, F.ATI.TH.CARDLESS.WITHDRAWAL.ACT, ERR.ATI.TH.CARDLESS.WITHDRAWAL.ACT)
    Y.TOTAL.AMOUNT   = R.ATI.TH.CARDLESS.WITHDRAWAL.ACT<CL.WTD.ACT.TOTAL.AMOUNT>
    Y.TOTAL.AMOUNT.2 = Y.TOTAL.AMOUNT + Y.DEBIT.AMOUNT

    IF Y.TOTAL.AMOUNT.2 GT Y.MAX.WTD.AMT THEN
        AF    = ""
        ETEXT = "EB-ATI.CL.WTD.MAX.TRANS"
        CALL STORE.END.ERROR

        GOTO PROGRAM.ABORT
    END

    RETURN

*-----------------------------------------------------------------------------
INPUT:
*-----------------------------------------------------------------------------
*-Generate reference id------------------------------------------------------
    GOSUB GENERATE.REF.ID

*-Calculate expiry time-------------------------------------------------------
    PRECISION 0
    Y.START.H    = Y.TIME[1,2] * 3600
    Y.START.M    = Y.TIME[4,2] * 60
    Y.START.TIME = Y.START.H + Y.START.M

    Y.END.TIME = Y.START.TIME + Y.COT.WTD.ATM + 60
    Y.END.H    = Y.END.TIME/3600
    Y.END.MOD  = MOD(Y.END.TIME, 3600)
    Y.END.M    = Y.END.MOD/60

    IF Y.END.H GE 24 THEN
        Y.END.H = "00"
        Y.DATE = "20":Y.DATE[9,2]:Y.DATE[1,2]:Y.DATE[4,2]
    
        CALL CDT("", Y.DATE, "+1C")
        Y.DATE = Y.DATE[5,2] : "-" : Y.DATE[2] : "-" : Y.DATE[1,4]
    END
	
    Y.EXP.DATE.TIME = Y.DATE[9,2]:Y.DATE[1,2]:Y.DATE[4,2]:FMT(Y.END.H, "R%2"):FMT(Y.END.M, "R%2"):Y.TIME[7,2]

*-Write Cardless Withdrawal Table---------------------------------------------
    R.ATI.TH.CARDLESS.WITHDRAWAL<CL.WTD.CUSTOMER>      = Y.CUSTOMER.ID
    R.ATI.TH.CARDLESS.WITHDRAWAL<CL.WTD.STATUS>        = "REQUEST"
    R.ATI.TH.CARDLESS.WITHDRAWAL<CL.WTD.VALUE.DATE>    = TODAY
    R.ATI.TH.CARDLESS.WITHDRAWAL<CL.WTD.ACCOUNT>       = Y.DEBIT.ACCT.NO
    R.ATI.TH.CARDLESS.WITHDRAWAL<CL.WTD.AMOUNT>        = Y.DEBIT.AMOUNT
    R.ATI.TH.CARDLESS.WITHDRAWAL<CL.WTD.FT.ID>         = ID.NEW
    R.ATI.TH.CARDLESS.WITHDRAWAL<CL.WTD.EXP.DATE.TIME> = Y.EXP.DATE.TIME

    CALL ID.LIVE.WRITE(FN.ATI.TH.CARDLESS.WITHDRAWAL, Y.CARDLESS.WITHDRAWAL.ID, R.ATI.TH.CARDLESS.WITHDRAWAL)
    CALL F.RELEASE(FN.ATI.TH.CARDLESS.WITHDRAWAL, Y.CARDLESS.WITHDRAWAL.ID, F.ATI.TH.CARDLESS.WITHDRAWAL)

*-Default value---------------------------------------------------------------
    R.NEW(FT.LOCAL.REF)<1, Y.ATI.CL.WTD.POS> = Y.CARDLESS.WITHDRAWAL.ID

    RETURN

*-----------------------------------------------------------------------------
GENERATE.REF.ID:
*-----------------------------------------------------------------------------
*<20180305_Dhio
	Y.REF.ID = ''
*>20180305_Dhio

    IF NOT(Y.REF.WTD.LEN) THEN
        Y.REF.WTD.LEN = 6
    END

    FOR I = 1 TO Y.REF.WTD.LEN
        Y.VALUE = RND(9)

        Y.REF.ID := Y.VALUE
    NEXT I

    Y.CARDLESS.WITHDRAWAL.ID = Y.SMS.1 : "-" :Y.REF.ID

    CALL F.READU(FN.ATI.TH.CARDLESS.WITHDRAWAL, Y.CARDLESS.WITHDRAWAL.ID, R.ATI.TH.CARDLESS.WITHDRAWAL, F.ATI.TH.CARDLESS.WITHDRAWAL, ERR.ATI.TH.CARDLESS.WITHDRAWAL, Y.RETRY)

    IF R.ATI.TH.CARDLESS.WITHDRAWAL THEN
        CALL F.RELEASE(FN.ATI.TH.CARDLESS.WITHDRAWAL, Y.CARDLESS.WITHDRAWAL.ID, F.ATI.TH.CARDLESS.WITHDRAWAL)
        GOSUB GENERATE.REF.ID
    END

    RETURN

*-----------------------------------------------------------------------------
PROGRAM.ABORT:
*-----------------------------------------------------------------------------
    RETURN TO PROGRAM.ABORT

    RETURN
*-----------------------------------------------------------------------------
END
