*-----------------------------------------------------------------------------
    SUBROUTINE ATI.VIN.FT.P2P.PAYDET
*-----------------------------------------------------------------------------
* Developer Name     : Dhio Faizar Wahyudi
* Development Date   : 20180309
* Description        : Routine to update PAYMENT.DETAILS
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date            Modified by                Description
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------

	$INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.ATI.TH.NEED.MONEY

*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------

	GOSUB INIT
	GOSUB PROCESS

    RETURN

*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
	
	YAPP = "FUNDS.TRANSFER"
	YFLD = "ATI.NEED.MONEY"
	YPOS = ""
	
	CALL MULTI.GET.LOC.REF(YAPP, YFLD, YPOS)
	
	Y.ATI.NEED.MONEY.POS = YPOS<1, 1>
		
	FN.ATI.TH.NEED.MONEY = "F.ATI.TH.NEED.MONEY"
	F.ATI.TH.NEED.MONEY = ""
	CALL OPF(FN.ATI.TH.NEED.MONEY, F.ATI.TH.NEED.MONEY)	
	
	RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
	
	Y.ATI.TH.NEED.MONEY.ID = R.NEW(FT.LOCAL.REF)<1, Y.ATI.NEED.MONEY.POS>
	
	IF Y.ATI.TH.NEED.MONEY.ID EQ "" THEN
		Y.DESC = "P2P "
		GOSUB SET.PAYMENT.DETAILS
	END ELSE
		GOSUB CHECK.NEED.MONEY
		GOSUB SET.PAYMENT.DETAILS
	END

	RETURN
*-----------------------------------------------------------------------------
CHECK.NEED.MONEY:
*-----------------------------------------------------------------------------

	CALL F.READ(FN.ATI.TH.NEED.MONEY, Y.ATI.TH.NEED.MONEY.ID, R.ATI.TH.NEED.MONEY, F.ATI.TH.NEED.MONEY, ATI.TH.NEED.MONEY.ERR)
	Y.ATI.TH.SPLIT.BILL.ID = R.ATI.TH.NEED.MONEY<NEED.MONEY.SPLIT.BILL.ID>
	
	IF Y.ATI.TH.SPLIT.BILL.ID EQ "" THEN
		Y.DESC = "NEED MONEY "
	END ELSE
		Y.DESC = "SPLIT BILL "
	END

	RETURN
*-----------------------------------------------------------------------------
SET.PAYMENT.DETAILS:
*-----------------------------------------------------------------------------
		
	Y.FUNDS.TRANSFER.PAYMENT.DETAILS = R.NEW(FT.PAYMENT.DETAILS)
	CONVERT @VM TO "" IN Y.FUNDS.TRANSFER.PAYMENT.DETAILS
	Y.FUNDS.TRANSFER.PAYMENT.DETAILS = Y.DESC : Y.FUNDS.TRANSFER.PAYMENT.DETAILS
	Y.LEN = LEN(Y.FUNDS.TRANSFER.PAYMENT.DETAILS)
	Y.CNT = Y.LEN/35
	
	FINDSTR "." IN Y.CNT SETTING Y.POSF, Y.POSV, Y.POSS THEN
		Y.CNT  = FIELD(Y.CNT, ".", 1)
		Y.CNT += 1
	END
	
	R.NEW(FT.PAYMENT.DETAILS) = ""
	
	IF Y.LEN LE 35 THEN
		R.NEW(FT.PAYMENT.DETAILS) = Y.FUNDS.TRANSFER.PAYMENT.DETAILS
	END ELSE
		Y.MAX   = 35
		Y.START = 1
		FOR Y.LOOP = 1 TO Y.CNT 
			R.NEW(FT.PAYMENT.DETAILS)<1, Y.LOOP> = Y.FUNDS.TRANSFER.PAYMENT.DETAILS[Y.START, Y.MAX]
			Y.START += Y.MAX
		NEXT Y.LOOP
	END

	RETURN
*-----------------------------------------------------------------------------
END
