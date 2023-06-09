*-----------------------------------------------------------------------------
* <Rating>-181</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.BM.ACCT.ZERO.BAL.LOAD
*-----------------------------------------------------------------------------
* Developer Name     : Dwi K
* Development Date   : 20171222
* Description        : Routine for
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date            Modified by                Description
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ATI.BM.ACCT.ZERO.BAL.COMMON
	$INSERT I_F.ATI.TH.INTF.GLOBAL.PARAM
	
*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------
    GOSUB INIT

    RETURN

*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT  = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
	
    FN.ATI.TH.INTF.GLOBAL.PARAM = 'F.ATI.TH.INTF.GLOBAL.PARAM'
    F.ATI.TH.INTF.GLOBAL.PARAM  = ''
    CALL OPF(FN.ATI.TH.INTF.GLOBAL.PARAM,F.ATI.TH.INTF.GLOBAL.PARAM)

    Y.APP      = 'ACCOUNT'
    Y.FLD.NAME = 'ATI.ZERO.BAL' :VM: 'ATI.LAST.ZERO'
    Y.POS      = ''
    CALL MULTI.GET.LOC.REF(Y.APP,Y.FLD.NAME,Y.POS)
    Y.ATI.ZERO.BAL.POS  = Y.POS<1,1>
	Y.ATI.LAST.ZERO.POS = Y.POS<1,2>
	
	CALL F.READ(FN.ATI.TH.INTF.GLOBAL.PARAM, "SYSTEM", R.ATI.TH.INTF.GLOBAL.PARAM, F.ATI.TH.INTF.GLOBAL.PARAM, GLB.PRM.ERR)
	Y.CLOSE.ZERO.BAL = R.ATI.TH.INTF.GLOBAL.PARAM<GLOBAL.PARAM.CLOSE.ZERO.BAL>

    RETURN

*-----------------------------------------------------------------------------
END




