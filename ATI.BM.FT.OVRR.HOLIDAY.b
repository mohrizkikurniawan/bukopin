    SUBROUTINE ATI.BM.FT.OVRR.HOLIDAY(Y.FT.ID)
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
	$INSERT I_F.FUNDS.TRANSFER
    $INSERT I_ATI.BM.FT.OVRR.HOLIDAY.COMMON

*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------

    GOSUB INIT
    GOSUB PROCESS

    RETURN
*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
    
    RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    CALL F.READ(FN.FUNDS.TRANSFER.NAU, Y.FT.ID, R.FUNDS.TRANSFER.NAU, F.FUNDS.TRANSFER.NAU, FT.NAU.ERR)
	
    Y.OFS.MESSAGE = ''
    OFS.HDR       = ''
    OFS.DTL       = ''
	Y.CO.CODE     = R.FUNDS.TRANSFER.NAU<FT.CO.CODE>

    OFS.HDR  = "FUNDS.TRANSFER,ATI.STO//PROCESS,//" : Y.CO.CODE : "," : Y.FT.ID

    Y.OFS.MESSAGE = OFS.HDR:OFS.DTL
    GOSUB GEN.OFS
	
	RETURN
*-----------------------------------------------------------------------------
GEN.OFS:
*-----------------------------------------------------------------------------
    Y.OFS.SOURCE = "GENERIC.OFS.PROCESS"
	CALL OFS.INITIALISE.SOURCE(Y.OFS.SOURCE,"","LOG.ERROR")
    CALL OFS.BULK.MANAGER(Y.OFS.MESSAGE, Y.PROCESS.FLAG, "")

	RETURN
*-----------------------------------------------------------------------------
END











