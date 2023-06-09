*-----------------------------------------------------------------------------
* <Rating>-181</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.BM.CREATE.BMONEY.LOAD
*-----------------------------------------------------------------------------
* Developer Name     : Dwi K
* Development Date   : 2018
* Description        : Routine for create bmoney account
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date            Modified by                Description
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ATI.BM.CREATE.BMONEY.COMMON
	$INSERT I_F.ATI.TH.INTF.GLOBAL.PARAM

*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------
    GOSUB INIT
	
    RETURN

*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
    FN.ATI.TH.EC.USERNAME = 'F.ATI.TH.EC.USERNAME'
    F.ATI.TH.EC.USERNAME  = ''
    CALL OPF(FN.ATI.TH.EC.USERNAME,F.ATI.TH.EC.USERNAME)

    FN.ATI.TH.INTF.GLOBAL.PARAM = 'F.ATI.TH.INTF.GLOBAL.PARAM'
    F.ATI.TH.INTF.GLOBAL.PARAM  = ''
    CALL OPF(FN.ATI.TH.INTF.GLOBAL.PARAM,F.ATI.TH.INTF.GLOBAL.PARAM)
	
	FN.EB.EXTERNAL.USER = 'F.EB.EXTERNAL.USER'
	F.EB.EXTERNAL.USER  = ''
	CALL OPF(FN.EB.EXTERNAL.USER, F.EB.EXTERNAL.USER)
	
	CALL F.READ(FN.ATI.TH.INTF.GLOBAL.PARAM, "SYSTEM", R.ATI.TH.INTF.GLOBAL.PARAM, F.ATI.TH.INTF.GLOBAL.PARAM, ATI.TH.INTF.GLOBAL.PARAM.ERR)
	Y.WALLET.REGISTER   = R.ATI.TH.INTF.GLOBAL.PARAM<GLOBAL.PARAM.WALLET.REGISTER>
	Y.WALLET.UNREGISTER = R.ATI.TH.INTF.GLOBAL.PARAM<GLOBAL.PARAM.WALLET.UNREGISTER>

    RETURN
	
*-----------------------------------------------------------------------------
END




