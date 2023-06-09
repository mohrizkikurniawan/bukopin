*-----------------------------------------------------------------------------
* <Rating>26</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.VIN.FT.REF.ID.CASHWD
*-----------------------------------------------------------------------------
* Developer Name     : Dwi K
* Development Date   : 20180420
* Description        : 
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date            Modified by                Description
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
	$INSERT I_F.ATI.TT.AGENT.MONTHLY.TXN.ACT
    $INSERT I_F.ATI.TH.AB.BTUNAI.CASHWD.RSV
	$INSERT I_F.ATI.TH.AGENT.GLOBAL.PARAM

*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------
    IF V$FUNCTION EQ "R" OR V$FUNCTION EQ "D" THEN RETURN

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
    FN.ATI.TH.AB.BTUNAI.CASHWD.RSV = "F.ATI.TH.AB.BTUNAI.CASHWD.RSV"
    CALL OPF(FN.ATI.TH.AB.BTUNAI.CASHWD.RSV, F.ATI.TH.AB.BTUNAI.CASHWD.RSV)
	
	FN.ATI.TH.AGENT.GLOBAL.PARAM = "F.ATI.TH.AGENT.GLOBAL.PARAM"
	CALL OPF(FN.ATI.TH.AGENT.GLOBAL.PARAM, F.ATI.TH.AGENT.GLOBAL.PARAM)
	
    FN.ATI.TT.AGENT.MONTHLY.TXN.ACT = 'F.ATI.TT.AGENT.MONTHLY.TXN.ACT'
    CALL OPF(FN.ATI.TT.AGENT.MONTHLY.TXN.ACT,F.ATI.TT.AGENT.MONTHLY.TXN.ACT)

    Y.APP = "FUNDS.TRANSFER"
    Y.FLD = "ATI.REF.ID"
    Y.POS = ""
    CALL MULTI.GET.LOC.REF(Y.APP, Y.FLD, Y.POS)
    Y.ATI.REF.ID.POS  = Y.POS<1,1>

    Y.DATE      = OCONV(DATE(),"D-")
    Y.TIME      = TIMEDATE()
    Y.DATE.TIME = Y.DATE[9,2]:Y.DATE[1,2]:Y.DATE[4,2]:Y.TIME[1,2]:Y.TIME[4,2]:Y.TIME[7,2]
	
	CALL F.READ(FN.ATI.TH.AGENT.GLOBAL.PARAM, "SYSTEM", R.ATI.TH.AGENT.GLOBAL.PARAM, F.ATI.TH.AGENT.GLOBAL.PARAM, ATI.TH.AGENT.GLOBAL.PARAM.ERR)
	Y.MAX.AMT.DB    = R.ATI.TH.AGENT.GLOBAL.PARAM<AGENT.PARAM.MAX.AMT.DB>
	Y.TRANS.CODE.DB = R.ATI.TH.AGENT.GLOBAL.PARAM<AGENT.PARAM.TRANS.CODE.DB>
    Y.COT.BSA.WTD   = R.ATI.TH.AGENT.GLOBAL.PARAM<AGENT.PARAM.COT.BSA.WTD>

	Y.CURR.AMOUNT.DB   = 0
	Y.TOT.AMOUNT.DB    = 0

    RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
	Y.TRANSACTION.TYPE = R.NEW(FT.TRANSACTION.TYPE)
	Y.DEBIT.CUSTOMER   = R.NEW(FT.DEBIT.CUSTOMER)
    Y.DEBIT.ACCT.NO    = R.NEW(FT.DEBIT.ACCT.NO)
    Y.DEBIT.AMOUNT     = R.NEW(FT.DEBIT.AMOUNT)
	Y.AMOUNT.DEBITED   = R.NEW(FT.AMOUNT.DEBITED)[4,99]

	GOSUB VALIDATE
    GOSUB INPUT

    RETURN

*-----------------------------------------------------------------------------
VALIDATE:
*-----------------------------------------------------------------------------
*-Validate max transaction per month--------------------------------------------
	Y.ACTVT.ID = TODAY[1,6]:'*':Y.DEBIT.ACCT.NO
    CALL F.READ(FN.ATI.TT.AGENT.MONTHLY.TXN.ACT, Y.ACTVT.ID, R.ATI.TT.AGENT.MONTHLY.TXN.ACT, F.ATI.TT.AGENT.MONTHLY.TXN.ACT, ATI.TT.AGENT.MONTHLY.TXN.ACT.ERR)
	Y.TRANSACTION.TYPE = R.ATI.TT.AGENT.MONTHLY.TXN.ACT<TXN.ACT.TRANS.DB>
	Y.AMOUNT.DB        = R.ATI.TT.AGENT.MONTHLY.TXN.ACT<TXN.ACT.AMOUNT.DB>
	
    CONVERT SM TO VM IN Y.TRANSACTION.TYPE
	CONVERT SM TO VM IN Y.AMOUNT.DB
	
	Y.CNT.TRX = DCOUNT(Y.TRANSACTION.TYPE, VM)
	FOR YLOOP.TRX = 1 TO Y.CNT.TRX
	    Y.TRANS.TYPE = Y.TRANSACTION.TYPE<1,YLOOP.TRX>
		
		FIND Y.TRANS.TYPE IN Y.TRANS.CODE.DB SETTING POSF.DB, POSV.DB THEN
		    Y.CURR.AMOUNT.DB = Y.AMOUNT.DB<1,YLOOP.TRX>
			Y.TOT.AMOUNT.DB += Y.CURR.AMOUNT.DB
		END
	NEXT YLOOP.TRX
	
	Y.TOTAL.AMT = Y.TOT.AMOUNT.DB + Y.AMOUNT.DEBITED
	IF Y.TOTAL.AMT GT Y.MAX.AMT.DB THEN
		ETEXT = "FT-MAX.AMT.DB.AGENT"
		AF    = FT.DEBIT.AMOUNT
		CALL STORE.END.ERROR

        GOTO PROGRAM.ABORT
	END

    RETURN
	
*-----------------------------------------------------------------------------
INPUT:
*-----------------------------------------------------------------------------
*-Generate reference id------------------------------------------------------
*Use last digit from FT for reservation ID
	Y.BTUNAI.CASHWD.RSV.ID = ID.NEW[3,10]
    CALL F.READU(FN.ATI.TH.AB.BTUNAI.CASHWD.RSV, Y.BTUNAI.CASHWD.RSV.ID, R.ATI.TH.AB.BTUNAI.CASHWD.RSV, F.ATI.TH.AB.BTUNAI.CASHWD.RSV, ERR.ATI.TH.AB.BTUNAI.CASHWD.RSV, Y.RETRY)
	
*-Calculate expiry time-------------------------------------------------------
    PRECISION 0
    Y.START.H    = Y.TIME[1,2] * 3600
    Y.START.M    = Y.TIME[4,2] * 60
    Y.START.TIME = Y.START.H + Y.START.M

    Y.END.TIME = Y.START.TIME + Y.COT.BSA.WTD + 60
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
    R.ATI.TH.AB.BTUNAI.CASHWD.RSV<AB.WTD.RSV.CUSTOMER>      = Y.DEBIT.CUSTOMER
    R.ATI.TH.AB.BTUNAI.CASHWD.RSV<AB.WTD.RSV.STATUS>        = "REQUEST"
    R.ATI.TH.AB.BTUNAI.CASHWD.RSV<AB.WTD.RSV.VALUE.DATE>    = TODAY
    R.ATI.TH.AB.BTUNAI.CASHWD.RSV<AB.WTD.RSV.ACCOUNT.NO>    = Y.DEBIT.ACCT.NO
    R.ATI.TH.AB.BTUNAI.CASHWD.RSV<AB.WTD.RSV.AMOUNT>        = Y.DEBIT.AMOUNT
    R.ATI.TH.AB.BTUNAI.CASHWD.RSV<AB.WTD.RSV.FT.ID.RESV>    = ID.NEW
	R.ATI.TH.AB.BTUNAI.CASHWD.RSV<AB.WTD.RSV.BRANCH.ID.RESV>= ID.COMPANY
	R.ATI.TH.AB.BTUNAI.CASHWD.RSV<AB.WTD.RSV.DATE.TIME.RESV>= Y.DATE.TIME
	R.ATI.TH.AB.BTUNAI.CASHWD.RSV<AB.WTD.RSV.EXP.DATE.TIME> = Y.EXP.DATE.TIME

    CALL ID.LIVE.WRITE(FN.ATI.TH.AB.BTUNAI.CASHWD.RSV, Y.BTUNAI.CASHWD.RSV.ID, R.ATI.TH.AB.BTUNAI.CASHWD.RSV)
    CALL F.RELEASE(FN.ATI.TH.AB.BTUNAI.CASHWD.RSV, Y.BTUNAI.CASHWD.RSV.ID, F.ATI.TH.AB.BTUNAI.CASHWD.RSV)

*-Default value---------------------------------------------------------------
    R.NEW(FT.LOCAL.REF)<1, Y.ATI.REF.ID.POS> = Y.BTUNAI.CASHWD.RSV.ID

    RETURN

*-----------------------------------------------------------------------------
PROGRAM.ABORT:
*-----------------------------------------------------------------------------
    RETURN TO PROGRAM.ABORT

    RETURN
*-----------------------------------------------------------------------------
END
