*-----------------------------------------------------------------------------
    SUBROUTINE ATI.TH.SPLIT.BILL.AUTHORISE
*-----------------------------------------------------------------------------
* Developer Name     : Dhio Faizar Wahyudi
* Development Date   : 20171002
* Description        : Create FT for SPLIT BILL
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date               :
* Modified by        :
* Description        :
*-----------------------------------------------------------------------------
	$INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ATI.TH.SPLIT.BILL
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
    FN.ATI.TH.SPLIT.BILL = "F.ATI.TH.SPLIT.BILL"
	F.ATI.TH.SPLIT.BILL = ""
	CALL OPF(FN.ATI.TH.SPLIT.BILL, F.ATI.TH.SPLIT.BILL)
	
	YAPP = "FUNDS.TRANSFER"
	YFLD = "ATI.SPLIT.BILL" :@VM: "ATI.TRANS.CATEG"
	YPOS = ""
	
	CALL MULTI.GET.LOC.REF(YAPP, YFLD, YPOS)
	
	Y.ATI.SPLIT.BILL.POS   = YPOS<1, 1>
	Y.ATI.TRANS.CATEG.POS = YPOS<1, 2>

    RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
	DEBUG
	Y.APPLICATION   = "FUNDS.TRANSFER"
	
	R.FUNDS.TRANSFER.OFS<FT.DEBIT.ACCT.NO>                    = R.NEW(SPLIT.BILL.ACCOUNT.MST)
	R.FUNDS.TRANSFER.OFS<FT.DEBIT.AMOUNT>                     = R.NEW(SPLIT.BILL.AMOUNT.TOT)
	R.FUNDS.TRANSFER.OFS<FT.PAYMENT.DETAILS>                  = R.NEW(SPLIT.BILL.NOTES)
	R.FUNDS.TRANSFER.OFS<FT.LOCAL.REF, Y.ATI.TRANS.CATEG.POS> = R.NEW(SPLIT.BILL.TRANS.CATEG)
	R.FUNDS.TRANSFER.OFS<FT.LOCAL.REF, Y.ATI.SPLIT.BILL.POS>  = ID.NEW
	
	Y.FUNCTION       = "I"
	Y.PROCESS        = "PROCESS"
	Y.VERSION.ID     = "FUNDS.TRANSFER,ATI.SPLIT.BILL"
	Y.GTSMODE        = ""
	Y.NO.OF.AUTH     = "0"
	Y.TRANSACTION.ID = ""
	
	CALL OFS.BUILD.RECORD(Y.APPLICATION, Y.FUNCTION, Y.PROCESS, Y.VERSION.ID, Y.GTSMODE, Y.NO.OF.AUTH, Y.TRANSACTION.ID, R.FUNDS.TRANSFER.OFS, Y.OFS.TEMP.MESSAGE)
	
	Y.OFS.SOURCE = "GENERIC.OFS.PROCESS"
	
    CALL OFS.CALL.BULK.MANAGER(Y.OFS.SOURCE, Y.OFS.TEMP.MESSAGE, Y.OFS.RESPONSE, Y.TXN.RESULT)
	
	Y.FT.ID = FIELD(Y.OFS.RESPONSE, "/", 1)
	R.NEW(SPLIT.BILL.FT.ID) = Y.FT.ID

	
    RETURN
END
