    SUBROUTINE ATI.BM.FT.OVRR.HOLIDAY.SELECT
*-----------------------------------------------------------------------------
* Developer Name     : 20171130
* Development Date   : Dwi K
* Description        : Routine to process FT override holiday
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date               : 
* Modified by        : 
* Description        : 
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ATI.BM.FT.OVRR.HOLIDAY.COMMON

    SEL.CMD = "SELECT " : FN.FUNDS.TRANSFER.NAU : " TRANSACTION.TYPE EQ 'ACSP' AND RECORD.STATUS EQ 'IHLD' AND DEBIT.VALUE.DATE EQ " : TODAY
    CALL EB.READLIST(SEL.CMD, SEL.LIST, "", SEL.CNT, SEL.ERR)

    CALL BATCH.BUILD.LIST("", SEL.LIST)

    RETURN
*-----------------------------------------------------------------------------
END

