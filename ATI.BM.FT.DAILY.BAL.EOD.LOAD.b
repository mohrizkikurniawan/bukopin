    SUBROUTINE ATI.BM.FT.DAILY.BAL.EOD.LOAD
*-----------------------------------------------------------------------------
* Developer Name     : 20160204
* Development Date   : Novi Leo
* Description        : Routine for daily balance
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date               : 20170620
* Modified by        : Natasha
* Description        : Removing process for CTR, point reward and updating ATI.SYSTAXABLE
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ATI.BM.FT.DAILY.BAL.EOD.COMMON
    $INSERT I_F.DATES
    $INSERT I_F.ATI.TH.WHT.TAX

*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------

    GOSUB INIT
    GOSUB PROCESS

    RETURN
*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------

    FN.AC = "F.ACCOUNT"
    F.AC  = ""
    CALL OPF(FN.AC, F.AC)

    FN.DAILY.BAL = "F.ATI.TL.DAILY.BAL"
    F.DAILY.BAL  = ""
    CALL OPF(FN.DAILY.BAL, F.DAILY.BAL)

    FN.CUS = "F.CUSTOMER"
    F.CUS  = ""
    CALL OPF(FN.CUS, F.CUS)

    FN.CUST.ARR = "F.AA.CUSTOMER.ARRANGEMENT"
    F.CUST.ARR  = ""
    CALL OPF(FN.CUST.ARR, F.CUST.ARR)

    FN.AA.ARR = "F.AA.ARRANGEMENT"
    F.AA.ARR  = ""
    CALL OPF(FN.AA.ARR, F.AA.ARR)

    FN.TAX = "F.ATI.TH.WHT.TAX"
    F.TAX  = ""
    CALL OPF(FN.TAX,F.TAX)
	
	FN.CUSTOMER.CHARGE = "F.CUSTOMER.CHARGE"
	F.CUSTOMER.CHARGE  = ""
	CALL OPF(FN.CUSTOMER.CHARGE, F.CUSTOMER.CHARGE)

    Y.NWORK.DAY = R.DATES(EB.DAT.NEXT.WORKING.DAY)
    Y.TODAY     = TODAY

    Y.APP      = "CUSTOMER"
    Y.FLD.NAME = "ATI.SYSTAXABLE"
    Y.POS      = ""
    CALL MULTI.GET.LOC.REF(Y.APP,Y.FLD.NAME,Y.POS)
    Y.SYSTAXABLE.POS = Y.POS<1, 1>

    RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------

    CALL F.READ(FN.TAX,"SYSTEM",R.TAX,F.TAX,TAX.ERR)
    Y.PERIOD.INT = R.TAX<HRP.PERIOD.INT> 'R%2'
    Y.TAX.CATEG  = R.TAX<HRP.CATEGORY>
    Y.THRESHOLD  = R.TAX<HRP.THRESHOLDTAX>
    
    RETURN
*-----------------------------------------------------------------------------
END
