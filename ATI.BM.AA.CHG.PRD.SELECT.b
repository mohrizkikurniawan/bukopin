    SUBROUTINE ATI.BM.AA.CHG.PRD.SELECT
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

    SEL.CMD = "SELECT " : FN.AA.ARRANGEMENT
    CALL EB.READLIST(SEL.CMD, SEL.LIST, "", SEL.CNT, SEL.ERR)

    CALL BATCH.BUILD.LIST("", SEL.LIST)

    RETURN
*-----------------------------------------------------------------------------
END

