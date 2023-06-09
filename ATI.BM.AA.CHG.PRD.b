    SUBROUTINE ATI.BM.AA.CHG.PRD(Y.ARR.ID)
*-----------------------------------------------------------------------------
* Developer Name     : 20171123
* Development Date   : Dwi K
* Description        : Routine to change product AA
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
    $INSERT I_F.AA.ARRANGEMENT

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
    CALL F.READ(FN.AA.ARRANGEMENT, Y.ARR.ID, R.AA.ARRANGEMENT, F.AA.ARRANGEMENT, ATI.ARR.ERR)
	Y.CUSTOMER    = R.AA.ARRANGEMENT<AA.ARR.CUSTOMER>
	Y.CURRENCY    = R.AA.ARRANGEMENT<AA.ARR.CURRENCY>
	Y.ARR.PRODUCT = R.AA.ARRANGEMENT<AA.ARR.PRODUCT>
	
    IF Y.ARR.PRODUCT NE "BUKO.ISR" THEN
		Y.OFS.MESSAGE = ''
		OFS.HDR       = ''
		OFS.DTL       = ''
		Y.CO.CODE     = R.AA.ARRANGEMENT<AA.ARR.CO.CODE>
	
		OFS.HDR  = "AA.ARRANGEMENT.ACTIVITY,ATI.CHG.PRD//PROCESS,//" : Y.CO.CODE : ","
		OFS.DTL := ",ARRANGEMENT::=" : Y.ARR.ID
		OFS.DTL := ",CUSTOMER::=" : Y.CUSTOMER
		OFS.DTL := ",CURRENCY::=" : Y.CURRENCY
		OFS.DTL := ",ACTIVITY::=ACCOUNTS-CHANGE.PRODUCT-ARRANGEMENT"
		OFS.DTL := ",EFFECTIVE.DATE::=" : TODAY
		OFS.DTL := ",PRODUCT::=" : Y.ARR.PRODUCT
	
		Y.OFS.MESSAGE = OFS.HDR:OFS.DTL
		GOSUB GEN.OFS
	END
	
	RETURN
*-----------------------------------------------------------------------------
GEN.OFS:
*-----------------------------------------------------------------------------
    Y.OFS.SOURCE = "AA.COB"
	CALL OFS.INITIALISE.SOURCE(Y.OFS.SOURCE,"","LOG.ERROR")
    CALL OFS.BULK.MANAGER(Y.OFS.MESSAGE, Y.PROCESS.FLAG, "")

	RETURN
*-----------------------------------------------------------------------------
END











