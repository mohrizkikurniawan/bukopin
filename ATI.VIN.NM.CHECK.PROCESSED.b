*-----------------------------------------------------------------------------
    SUBROUTINE ATI.VIN.NM.CHECK.PROCESSED
*-----------------------------------------------------------------------------
* Developer Name     : Dhio Faizar Wahyudi
* Development Date   : 20171109
* Description        : Routine to cek NEED MONEY PROCESSED
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date            Modified by                Description
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ATI.TH.NEED.MONEY
    $INSERT I_F.FUNDS.TRANSFER
	
	
*-----------------------------------------------------------------------------	
MAIN:
*-----------------------------------------------------------------------------

	GOSUB INIT
	GOSUB PROCESS
	
	RETURN
	
*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
	
	FN.ATI.TH.NEED.MONEY = 'F.ATI.TH.NEED.MONEY'
	F.ATI.TH.NEED.MONEY = ''
	CALL OPF(FN.ATI.TH.NEED.MONEY, F.ATI.TH.NEED.MONEY)
	
	YAPP = "FUNDS.TRANSFER"
	YFLD = "ATI.NEED.MONEY"
	YPOS = ""
	
	CALL MULTI.GET.LOC.REF(YAPP, YFLD, YPOS)
	
	Y.ATI.NEED.MONEY.POS = YPOS<1, 1>
	
	RETURN
	
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------

	Y.ATI.TH.NEED.MONEY.ID = R.NEW(FT.LOCAL.REF)<1, Y.ATI.NEED.MONEY.POS>
	
	IF Y.ATI.TH.NEED.MONEY.ID THEN
		CALL F.READ(FN.ATI.TH.NEED.MONEY, Y.ATI.TH.NEED.MONEY.ID, R.ATI.TH.NEED.MONEY, F.ATI.TH.NEED.MONEY, ATI.TH.NEED.MONEY.ERR)
		IF R.ATI.TH.NEED.MONEY THEN
			Y.NEED.MONEY.STATUS = R.ATI.TH.NEED.MONEY<NEED.MONEY.STATUS>
			
			IF Y.NEED.MONEY.STATUS NE '' THEN
				ETEXT = "EB-NEED.MONEY.PROCESSED"
				CALL STORE.END.ERROR
			END
		END
	END
	
	RETURN
	
*-----------------------------------------------------------------------------

END