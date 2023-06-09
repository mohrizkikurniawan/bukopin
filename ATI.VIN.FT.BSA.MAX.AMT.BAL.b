*-----------------------------------------------------------------------------
* <Rating>-181</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.VIN.FT.BSA.MAX.AMT.BAL
*-----------------------------------------------------------------------------
* Developer Name     : Dwi K
* Development Date   : 20180423
* Description        : Routine to validate maximum amount balance
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date            Modified by                Description
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
	$INSERT I_F.ATI.TH.AGENT.GLOBAL.PARAM
    $INSERT I_F.ACCOUNT

*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------
    GOSUB INIT
    GOSUB PROCESS

    RETURN

*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
    FN.ATI.TH.AGENT.GLOBAL.PARAM = 'F.ATI.TH.AGENT.GLOBAL.PARAM'
	F.ATI.TH.AGENT.GLOBAL.PARAM  = ''
	CALL OPF(FN.ATI.TH.AGENT.GLOBAL.PARAM, F.ATI.TH.AGENT.GLOBAL.PARAM)
	
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT  = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

	CALL F.READ(FN.ATI.TH.AGENT.GLOBAL.PARAM, "SYSTEM", R.ATI.TH.AGENT.GLOBAL.PARAM, F.ATI.TH.AGENT.GLOBAL.PARAM, ATI.TH.AGENT.GLOBAL.PARAM.ERR)
	Y.MAX.AMT.CR    = R.ATI.TH.AGENT.GLOBAL.PARAM<AGENT.PARAM.MAX.AMT.CR>

    RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    Y.AMOUNT   = R.NEW(FT.AMOUNT.CREDITED)[4,99]
	Y.ACCOUNT  = R.NEW(FT.CREDIT.ACCT.NO)
	CALL F.READ(FN.ACCOUNT, Y.ACCOUNT, R.ACCOUNT, F.ACCOUNT, ACCT.ERR)
	Y.ONLINE.ACTUAL.BAL = R.ACCOUNT<AC.ONLINE.ACTUAL.BAL>
	Y.TOTAL.AMT         = Y.ONLINE.ACTUAL.BAL + Y.AMOUNT
	IF Y.TOTAL.AMT GT Y.MAX.AMT.CR THEN
	   ETEXT = "FT-MAX.AMT.BAL.AGENT"
	   AF    = FT.DEBIT.AMOUNT
	   CALL STORE.END.ERROR
	END
	
    RETURN
*-----------------------------------------------------------------------------
END




