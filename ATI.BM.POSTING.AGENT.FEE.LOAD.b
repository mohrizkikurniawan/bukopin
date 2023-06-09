*-----------------------------------------------------------------------------
* <Rating>-1</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.BM.POSTING.AGENT.FEE.LOAD
*-----------------------------------------------------------------------------
* Developer Name     : Dwi K
* Development Date   : 20180725
* Description        : Routine to post agent fee
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date            Modified by                Description
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
	$INSERT I_F.ATI.TH.AGENT.GLOBAL.PARAM
    $INSERT I_ATI.BM.POSTING.AGENT.FEE.COMMON
	
*-----------------------------------------------------------------------------	
MAIN:
*-----------------------------------------------------------------------------

	GOSUB INIT
	
	RETURN
	
*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
	
	FN.ATI.TH.AB.BTUNAI.CASHWD.RSV = 'F.ATI.TH.AB.BTUNAI.CASHWD.RSV'
	F.ATI.TH.AB.BTUNAI.CASHWD.RSV = ''
	CALL OPF(FN.ATI.TH.AB.BTUNAI.CASHWD.RSV, F.ATI.TH.AB.BTUNAI.CASHWD.RSV)

	FN.ATI.TH.AGENT.GLOBAL.PARAM = 'F.ATI.TH.AGENT.GLOBAL.PARAM'
	F.ATI.TH.AGENT.GLOBAL.PARAM = ''
	CALL OPF(FN.ATI.TH.AGENT.GLOBAL.PARAM, F.ATI.TH.AGENT.GLOBAL.PARAM)
	
	CALL F.READ(FN.ATI.TH.AGENT.GLOBAL.PARAM, "SYSTEM", R.ATI.TH.AGENT.GLOBAL.PARAM, F.ATI.TH.AGENT.GLOBAL.PARAM, ERR.ATI.TH.AGENT.GLOBAL.PARAM)
	Y.PL.CATEG.FEE = R.ATI.TH.AGENT.GLOBAL.PARAM<AGENT.PARAM.PL.CATEG.FEE>
	
	RETURN
*-----------------------------------------------------------------------------	
END


