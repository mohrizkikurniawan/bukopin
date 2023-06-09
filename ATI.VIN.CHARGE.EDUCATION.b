    SUBROUTINE ATI.VIN.CHARGE.EDUCATION
*-----------------------------------------------------------------------------
* Developer Name     : Dhio Faizar Wahyudi
* Development Date   : 20181126
* Description        : Routine to default charge for EDUCATION
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ATI.TH.MERCHANT
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
	
	FN.ATI.TH.MERCHANT = "F.ATI.TH.MERCHANT"
	F.ATI.TH.MERCHANT = ""
	CALL OPF(FN.ATI.TH.MERCHANT, F.ATI.TH.MERCHANT)
	
	YAPP = "FUNDS.TRANSFER"
	YFLD = "ATI.UNIVERSITY" :@VM: "ATI.CLASS.TYPE"
	YPOS = ""
	
	CALL MULTI.GET.LOC.REF(YAPP, YFLD, YPOS)
	
	Y.UNIVERSITY.POS = YPOS<1, 1>
	Y.CLASS.TYPE.POS = YPOS<1, 2>
	
    RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------

	Y.VM = 1
	
	Y.FUNDS.TRANSFER.UNIVERSITY = COMI
	Y.FUNDS.TRANSFER.CLASS.TYPE = R.NEW(FT.LOCAL.REF)<1, Y.CLASS.TYPE.POS>
	
	IF Y.FUNDS.TRANSFER.UNIVERSITY EQ "" AND Y.FUNDS.TRANSFER.CLASS.TYPE EQ "" THEN
		RETURN
	END
	
	CALL F.READ(FN.ATI.TH.MERCHANT, Y.FUNDS.TRANSFER.UNIVERSITY, R.ATI.TH.MERCHANT, F.ATI.TH.MERCHANT, ATI.TH.MERCHANT.ERR)
	Y.ATI.TH.MERCHANT.PURCHASE.CHARGE = R.ATI.TH.MERCHANT<MERCHANT.PURCHASE.CHARGE>
	Y.ATI.TH.MERCHANT.PURCHASE.INFO   = R.ATI.TH.MERCHANT<MERCHANT.PURCHASE.INFO>
	Y.CNT = DCOUNT(Y.ATI.TH.MERCHANT.PURCHASE.CHARGE, @VM)
	
	FOR Y.LOOP = 1 TO Y.CNT
		IF Y.ATI.TH.MERCHANT.PURCHASE.INFO<1, Y.LOOP> EQ Y.FUNDS.TRANSFER.CLASS.TYPE THEN
			R.NEW(FT.COMMISSION.AMT)<1, Y.VM> = "IDR" : Y.ATI.TH.MERCHANT.PURCHASE.CHARGE<1, Y.LOOP>
			Y.VM += 1
		END
	NEXT Y.LOOP
	
	RETURN

*-----------------------------------------------------------------------------
END











