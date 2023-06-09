*-----------------------------------------------------------------------------
    SUBROUTINE ATI.TH.NEED.MONEY.AUTHORISE
*-----------------------------------------------------------------------------
* Developer Name     : Dhio Faizar Wahyudi
* Development Date   : 20171002
* Description        : Create FT for NEED MONEY
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date               :
* Modified by        :
* Description        :
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
	
	FN.ATI.TH.NEED.MONEY = "F.ATI.TH.NEED.MONEY"
	F.ATI.TH.NEED.MONEY = ""
	CALL OPF(FN.ATI.TH.NEED.MONEY, F.ATI.TH.NEED.MONEY)
	
	YAPP = "FUNDS.TRANSFER"
	YFLD = "ATI.SPLIT.BILL" :@VM: "ATI.NEED.MONEY" :@VM: "ATI.TRANS.CATEG"
	YPOS = ""
	
	CALL MULTI.GET.LOC.REF(YAPP, YFLD, YPOS)
	
	Y.ATI.SPLIT.BILL.POS   = YPOS<1, 1>
	Y.ATI.NEED.MONEY.POS   = YPOS<1, 2>
	Y.ATI.TRANS.CATEG.POS = YPOS<1, 3>
	
	
    RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
	
	BEGIN CASE
	
	CASE R.NEW(NEED.MONEY.STATUS) EQ "APPROVE"
		GOSUB CREATE.FT.NEED.MONEY
	CASE 1
		RETURN
	END CASE
	
	RETURN
*-----------------------------------------------------------------------------
CREATE.FT.NEED.MONEY:
*-----------------------------------------------------------------------------

	Y.APPLICATION   = "FUNDS.TRANSFER"
	
	R.APPLICATION<FT.DEBIT.ACCT.NO>                    = R.NEW(NEED.MONEY.DB.ACCOUNT)
	R.APPLICATION<FT.DEBIT.AMOUNT>                     = R.NEW(NEED.MONEY.AMOUNT)
	R.APPLICATION<FT.CREDIT.ACCT.NO>                   = R.NEW(NEED.MONEY.CR.ACCOUNT)
	R.APPLICATION<FT.PAYMENT.DETAILS>                  = R.NEW(NEED.MONEY.NOTES)
	R.APPLICATION<FT.LOCAL.REF, Y.ATI.SPLIT.BILL.POS>   = R.NEW(NEED.MONEY.SLIT.BILL.ID)
	R.APPLICATION<FT.LOCAL.REF, Y.ATI.NEED.MONEY.POS>   = ID.NEW
	R.APPLICATION<FT.LOCAL.REF, Y.ATI.TRANS.CATEG.POS> = R.NEW(NEED.MONEY.TRANS.CATEG)
	
	Y.FUNCTION       = "I"
	Y.PROCESS        = "PROCESS"
	Y.VERSION.ID     = "FUNDS.TRANSFER,ATI.NEED.MONEY"
	Y.GTSMODE        = ""
	Y.NO.OF.AUTH     = "0"
	Y.TRANSACTION.ID = ""
	
	CALL OFS.BUILD.RECORD(Y.APPLICATION, Y.FUNCTION, Y.PROCESS, Y.VERSION.ID, Y.GTSMODE, Y.NO.OF.AUTH, Y.TRANSACTION.ID, R.APPLICATION, Y.OFS.TEMP.MESSAGE)
	
	Y.OFS.SOURCE = "GENERIC.OFS.PROCESS"
	
    CALL OFS.CALL.BULK.MANAGER(Y.OFS.SOURCE, Y.OFS.TEMP.MESSAGE, Y.OFS.RESPONSE, Y.TXN.RESULT)

    RETURN
END
