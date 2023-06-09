    SUBROUTINE ATI.BM.STO.AC.CLOSE.SELECT
*-----------------------------------------------------------------------------
* Developer Name     : 20171118
* Development Date   : Dwi K
* Description        : Routine to close account STO
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date               : 
* Modified by        : 
* Description        : 
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ATI.BM.STO.AC.CLOSE.COMMON

    SEL.CMD = "SELECT " : FN.STANDING.ORDER : " WITH CURRENT.END.DATE EQ " : TODAY
    CALL EB.READLIST(SEL.CMD, SEL.LIST, "", SEL.CNT, SEL.ERR)

    CALL BATCH.BUILD.LIST("", SEL.LIST)

    RETURN
*-----------------------------------------------------------------------------
END

