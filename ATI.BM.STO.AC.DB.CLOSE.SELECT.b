    SUBROUTINE ATI.BM.STO.AC.DB.CLOSE.SELECT
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

*-----------------------------------------------------------------------------
    
	SEL.CMD = "SELECT " : FN.ATI.TT.STO.DB.CLOSE
	CALL EB.READLIST(SEL.CMD, SEL.LIST, "", NO.OF.REC, RET.CODE)
	CALL BATCH.BUILD.LIST("", SEL.LIST)
	
    RETURN
*-----------------------------------------------------------------------------
END




