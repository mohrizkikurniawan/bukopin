    SUBROUTINE ATI.BM.AA.CHG.PRD.LOAD
*-----------------------------------------------------------------------------
* Developer Name     : 20171118
* Development Date   : Dwi K
* Description        : Routine 
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date               : 
* Modified by        : 
* Description        : 
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ATI.BM.AA.CHG.PRD.COMMON

*-----------------------------------------------------------------------------
    
    FN.AA.ARRANGEMENT = "F.AA.ARRANGEMENT"
    F.AA.ARRANGEMENT  = ""
    CALL OPF(FN.AA.ARRANGEMENT, F.AA.ARRANGEMENT)
	
    RETURN
*-----------------------------------------------------------------------------
END




