    SUBROUTINE ATI.BM.STO.AC.CLOSE.LOAD
*-----------------------------------------------------------------------------
* Developer Name     : 20171118
* Development Date   : Dwi K
* Description        : Routine to close account STO
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date               : 20180418
* Modified by        : Dhio Faizar Wahyudi
* Description        : Change OFS to write ATI.TT.INTF.ORK.BKP
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ATI.BM.STO.AC.CLOSE.COMMON

*-----------------------------------------------------------------------------
    
    FN.STANDING.ORDER = "F.STANDING.ORDER"
    F.STANDING.ORDER  = ""
    CALL OPF(FN.STANDING.ORDER, F.STANDING.ORDER)

    FN.ACCOUNT = "F.ACCOUNT"
    F.ACCOUNT  = ""
    CALL OPF(FN.ACCOUNT, F.ACCOUNT)
	
*<20180418_Dhio
	FN.ATI.TH.INTF.ORK.DATA = "F.ATI.TH.INTF.ORK.DATA"
	F.ATI.TH.INTF.ORK.DATA = ""
	CALL OPF(FN.ATI.TH.INTF.ORK.DATA, F.ATI.TH.INTF.ORK.DATA)
	
	FN.ATI.TT.INTF.ORK.BKP = "F.ATI.TT.INTF.ORK.BKP"
	F.ATI.TT.INTF.ORK.BKP = ""
	CALL OPF(FN.ATI.TT.INTF.ORK.BKP, F.ATI.TT.INTF.ORK.BKP)
*>20180418_Dhio
	
	Y.APP      = 'ACCOUNT'
	Y.FLD.NAME = 'ATI.AUTO.CLOSE'
    Y.POS      = ''
    CALL MULTI.GET.LOC.REF(Y.APP,Y.FLD.NAME,Y.POS)
    Y.ATI.AUTO.CLOSE.POS   = Y.POS<1,1>	
	
    RETURN
*-----------------------------------------------------------------------------
END




