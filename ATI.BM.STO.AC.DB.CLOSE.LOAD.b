    SUBROUTINE ATI.BM.STO.AC.DB.CLOSE.LOAD
*-----------------------------------------------------------------------------
* Developer Name     : 20180530
* Development Date   : Dhio
* Description        : Routine to close account STO Date Based
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ATI.BM.STO.AC.DB.CLOSE.COMMON
    $INSERT I_F.ATI.TT.STO.DB.CLOSE
    $INSERT I_F.ATI.TH.INTF.ORK.DATA
    $INSERT I_F.STANDING.ORDER

*-----------------------------------------------------------------------------
    
	FN.ATI.TT.STO.DB.CLOSE = "F.ATI.TT.STO.DB.CLOSE"
	F.ATI.TT.STO.DB.CLOSE = ""
	CALL OPF(FN.ATI.TT.STO.DB.CLOSE, F.ATI.TT.STO.DB.CLOSE)
	
	FN.ATI.TH.INTF.ORK.DATA = "F.ATI.TH.INTF.ORK.DATA"
	F.ATI.TH.INTF.ORK.DATA = ""
	CALL OPF(FN.ATI.TH.INTF.ORK.DATA, F.ATI.TH.INTF.ORK.DATA)
	
	FN.ATI.TT.INTF.ORK.BKP = "F.ATI.TT.INTF.ORK.BKP"
	F.ATI.TT.INTF.ORK.BKP = ""
	CALL OPF(FN.ATI.TT.INTF.ORK.BKP, F.ATI.TT.INTF.ORK.BKP)
	
	FN.STANDING.ORDER.HIS = "F.STANDING.ORDER$HIS"
	F.STANDING.ORDER.HIS = ""
	CALL OPF(FN.STANDING.ORDER.HIS, F.STANDING.ORDER.HIS)
	
    RETURN
*-----------------------------------------------------------------------------
END




