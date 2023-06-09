*-----------------------------------------------------------------------------
* <Rating>-181</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.VIN.CHECK.BTUNAI.AC
*-----------------------------------------------------------------------------
* Developer Name     : Dwi K
* Development Date   : 20180821
* Description        : Routine for validating btunai account
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
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT  = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
	
    FN.ATI.TH.AGENT.GLOBAL.PARAM = 'F.ATI.TH.AGENT.GLOBAL.PARAM'
	F.ATI.TH.AGENT.GLOBAL.PARAM  = ''
    CALL OPF(FN.ATI.TH.AGENT.GLOBAL.PARAM, F.ATI.TH.AGENT.GLOBAL.PARAM)
	
	CALL F.READ(FN.ATI.TH.AGENT.GLOBAL.PARAM, "SYSTEM", R.ATI.TH.AGENT.GLOBAL.PARAM, F.ATI.TH.AGENT.GLOBAL.PARAM, ATI.TH.AGENT.GLOBAL.PARAM.ERR)
	Y.PROD.CAT.BSA = R.ATI.TH.AGENT.GLOBAL.PARAM<AGENT.PARAM.PROD.CAT.BSA>

    RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    Y.ACCT.NO = R.NEW(FT.CREDIT.ACCT.NO)
    CALL F.READ(FN.ACCOUNT, Y.ACCT.NO, R.ACCOUNT, F.ACCOUNT, ACCT.ERR)
	Y.CATEGORY = R.ACCOUNT<AC.CATEGORY>
	
	IF Y.PROD.CAT.BSA EQ Y.CATEGORY THEN
	   ETEXT = 'FT-BTUNAI.NOT.ALLOWED'
	   CALL STORE.END.ERROR
	END
		
    RETURN
*-----------------------------------------------------------------------------
END




