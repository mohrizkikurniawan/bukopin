*-----------------------------------------------------------------------------
    SUBROUTINE ATI.BM.DEL.CUST.ONBOARD.LOAD
*-----------------------------------------------------------------------------
* Developer Name     : Dhio Faizar Wahyudi
* Development Date   : 20170816
* Description        : Routine Delete Customer Onboarding with status pending on ATI.TH.INTF.ORK.DATA
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date               :
* Modified by        :
* Description        :
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ATI.TH.INTF.ORK.DATA
    $INSERT I_F.ATI.TH.INTF.GLOBAL.PARAM
    $INSERT I_ATI.BM.DEL.CUST.ONBOARD.COMMON

*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------
    GOSUB INIT
    GOSUB PROCESS

    RETURN

*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
    FN.ATI.TH.INTF.ORK.DATA = 'F.ATI.TH.INTF.ORK.DATA'
	F.ATI.TH.INTF.ORK.DATA  = ''
	CALL OPF(FN.ATI.TH.INTF.ORK.DATA, F.ATI.TH.INTF.ORK.DATA)
	
	FN.ATI.TH.INTF.ORK.DATA.NAU = 'F.ATI.TH.INTF.ORK.DATA$NAU'
	F.ATI.TH.INTF.ORK.DATA.NAU  = ''
	CALL OPF(FN.ATI.TH.INTF.ORK.DATA.NAU, F.ATI.TH.INTF.ORK.DATA.NAU)
	
	FN.ATI.TH.INTF.GLOBAL.PARAM = "F.ATI.TH.INTF.GLOBAL.PARAM"
	F.ATI.TH.INTF.GLOBAL.PARAM = ""
	CALL OPF(FN.ATI.TH.INTF.GLOBAL.PARAM, F.ATI.TH.INTF.GLOBAL.PARAM)
	
*	YAPP = "ATI.TH.INTF.GLOBAL.PARAM"
*	YFLD = "CUS.ONBOARD.PEN"
*	YPOS = ""
	
*	CALL MULTI.GET.LOC.REF(YAPP, YFLD, YPOS)
	
*	CUS.ONBOARD.PEN.POS = YPOS<1, 1>
	
    RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    
	Y.ATI.TH.INTF.GLOBAL.PARAM.ID = "SYSTEM"
	CALL F.READ(FN.ATI.TH.INTF.GLOBAL.PARAM, Y.ATI.TH.INTF.GLOBAL.PARAM.ID, R.ATI.TH.INTF.GLOBAL.PARAM, F.ATI.TH.INTF.GLOBAL.PARAM, ATI.TH.INTF.GLOBAL.PARAM.ERR)
*	Y.CUS.ONBOARD.PENDING.PAR = R.ATI.TH.INTF.GLOBAL.PARAM<GLOBAL.PARAM.LOCAL.REF, CUS.ONBOARD.PEN.POS>
	Y.CUS.ONBOARD.PENDING.PAR = R.ATI.TH.INTF.GLOBAL.PARAM<GLOBAL.PARAM.CUS.ONBOARD.PEN>
	
    RETURN
*-----------------------------------------------------------------------------
END


