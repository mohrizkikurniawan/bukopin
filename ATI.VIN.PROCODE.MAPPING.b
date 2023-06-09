*-----------------------------------------------------------------------------
    SUBROUTINE ATI.VIN.PROCODE.MAPPING
*-----------------------------------------------------------------------------
* Developer Name     : Dhio Faizar Wahyudi
* Development Date   : 20181107
* Description        : Default Pro Code by ATI.TH.TRANS.PROCODE.MAPPING Table
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date            Modified by                Description
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
	$INSERT I_F.FUNDS.TRANSFER
	$INSERT I_F.ACCOUNT
	$INSERT I_F.AA.ARRANGEMENT
	$INSERT I_F.ATI.TH.TRANS.PROCODE.MAPPING

*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------
	
	GOSUB INIT
	GOSUB PROCESS
	
    RETURN

*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
	
	FN.ATI.TH.TRANS.PROCODE.MAPPING = "F.ATI.TH.TRANS.PROCODE.MAPPING"
	F.ATI.TH.TRANS.PROCODE.MAPPING = ""
	CALL OPF(FN.ATI.TH.TRANS.PROCODE.MAPPING, F.ATI.TH.TRANS.PROCODE.MAPPING)
	
	FN.ACCOUNT = "F.ACCOUNT"
	F.ACCOUNT = ""
	CALL OPF(FN.ACCOUNT, F.ACCOUNT)
	
	FN.AA.ARRANGEMENT = "F.AA.ARRANGEMENT"
	F.AA.ARRANGEMENT = ""
	CALL OPF(FN.AA.ARRANGEMENT, F.AA.ARRANGEMENT)
	
	YAPP = "FUNDS.TRANSFER"
	YFLD = "ATI.PRO.CODE"
	YPOS = ""
	CALL MULTI.GET.LOC.REF(YAPP, YFLD, YPOS)
	
	Y.ATI.PRO.CODE.POS = YPOS<1, 1>
	
	Y.AA.ARRANGEMENT.PRODUCT = ''
	Y.ACCOUNT.ARRANGEMENT.ID = ''
	
    RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
	
* Call ACCOUNT Records
	Y.FUNDS.TRANSFER.CREDIT.ACCT.NO = R.NEW(FT.CREDIT.ACCT.NO)
	CALL F.READ(FN.ACCOUNT, Y.FUNDS.TRANSFER.CREDIT.ACCT.NO, R.ACCOUNT, F.ACCOUNT, ACCOUNT.ERR)
	Y.ACCOUNT.ARRANGEMENT.ID = R.ACCOUNT<AC.ARRANGEMENT.ID>

	
* Call AA.ARRANGEMENT Records
	CALL F.READ(FN.AA.ARRANGEMENT, Y.ACCOUNT.ARRANGEMENT.ID, R.AA.ARRANGEMENT, F.AA.ARRANGEMENT, AA.ARRANGEMENT.ERR)
	Y.AA.ARRANGEMENT.PRODUCT = R.AA.ARRANGEMENT<AA.ARR.PRODUCT>
	
	
* Call ATI.TH.TRANS.PROCODE.MAPPING Records
	Y.ATI.TH.TRANS.PROCODE.MAPPING.ID = "SYSTEM"
	CALL F.READ(FN.ATI.TH.TRANS.PROCODE.MAPPING, Y.ATI.TH.TRANS.PROCODE.MAPPING.ID, R.ATI.TH.TRANS.PROCODE.MAPPING, F.ATI.TH.TRANS.PROCODE.MAPPING, ATI.TH.TRANS.PROCODE.MAPPING.ERR)
	
	R.ATI.TH.TRANS.PROCODE.MAPPING.PRODUCT  = R.ATI.TH.TRANS.PROCODE.MAPPING<TRANS.PROCODE.PRODUCT>
	R.ATI.TH.TRANS.PROCODE.MAPPING.PRO.CODE = R.ATI.TH.TRANS.PROCODE.MAPPING<TRANS.PROCODE.PRO.CODE>
	
	FIND Y.AA.ARRANGEMENT.PRODUCT IN R.ATI.TH.TRANS.PROCODE.MAPPING.PRODUCT SETTING POSF, POSV THEN
        R.NEW(FT.LOCAL.REF)<1, Y.ATI.PRO.CODE.POS> = R.ATI.TH.TRANS.PROCODE.MAPPING.PRO.CODE<1, POSV>
    END
	
	RETURN

*-----------------------------------------------------------------------------
END
