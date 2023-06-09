    SUBROUTINE ATI.BM.FT.OVRR.HOLIDAY.LOAD
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

*-----------------------------------------------------------------------------
    
    FN.FUNDS.TRANSFER.NAU = "F.FUNDS.TRANSFER$NAU"
    F.FUNDS.TRANSFER.NAU  = ""
    CALL OPF(FN.FUNDS.TRANSFER.NAU, F.FUNDS.TRANSFER.NAU)
	
    RETURN
*-----------------------------------------------------------------------------
END




