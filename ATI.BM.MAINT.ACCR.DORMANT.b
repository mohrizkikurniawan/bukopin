*-----------------------------------------------------------------------------
* <Rating>-181</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.BM.MAINT.ACCR.DORMANT(Y.AC.INACTIVE.ID)
*-----------------------------------------------------------------------------
* Developer Name     : Dwi K
* Development Date   : 20171011
* Description        : Routine for
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date            Modified by                Description
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
	$INSERT I_F.ACCOUNT
	$INSERT I_F.ATI.TH.ACCT.INACTIVE
	$INSERT I_F.ATI.TL.IMB.ACCRUAL
	$INSERT I_F.FT.COMMISSION.TYPE
	$INSERT I_F.ATI.TH.DORMANT.PARAM
	$INSERT I_ATI.BM.MAINT.ACCR.DORMANT.COMMON

*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------
    GOSUB INIT
    GOSUB PROCESS

    RETURN

*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
    Y.AC.ID = FIELDS(Y.AC.INACTIVE.ID,"]",1)
	
    RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
	CALL F.READ(FN.ACCOUNT, Y.AC.ID, R.ACCOUNT, F.ACCOUNT, AC.ERR)
	Y.CUSTOMER = R.ACCOUNT<AC.CUSTOMER>
	Y.CURRENCY = R.ACCOUNT<AC.CURRENCY>
	Y.CO.CODE  = R.ACCOUNT<AC.CO.CODE>
	Y.CATEGORY = R.ACCOUNT<AC.CATEGORY>

*--------SUB AC STO---------
	IF Y.CATEGORY EQ "6011" THEN 
	   RETURN
	END
*--------SUB AC STO---------
	
	Y.DORMANT.PRM.ID = "SYSTEM"
	CALL F.READ(FN.ATI.TH.DORMANT.PARAM, Y.DORMANT.PRM.ID, R.ATI.TH.DORMANT.PARAM, F.ATI.TH.DORMANT.PARAM, DORMANT.PRM.ERR)
	
	Y.ID.FTCOMM = R.ATI.TH.DORMANT.PARAM<DORMANT.PRM.CHARGE.CODE>
	CALL F.READ(FN.FT.COMMISSION.TYPE, Y.ID.FTCOMM, R.FT.COMMISSION.TYPE, F.FT.COMMISSION.TYPE, FTCOMM.ERR)
	
	Y.ID.ACCR = Y.AC.ID:"-DORMANT"
    CALL F.READ(FN.ATI.TL.IMB.ACCRUAL,Y.ID.ACCR,R.ATI.TL.IMB.ACCRUAL,F.ATI.TL.IMB.ACCRUAL,ATI.TL.IMB.ACCRUAL.ERR)
	Y.MATURE.DATE = R.ATI.TL.IMB.ACCRUAL<ACR.MATURE.DATE>
	IF TODAY[1,6] NE Y.MATURE.DATE[1,6] THEN
		Y.FREQUENCY   = "M01" : Y.MATURE.DATE[2]
		CALL MULTI.CFQ(Y.MATURE.DATE, Y.FREQUENCY, "1", Y.NEXT.DATE)
		
		R.ATI.TL.IMB.ACCRUAL<ACR.MATURE.DATE>   = Y.NEXT.DATE
		R.ATI.TL.IMB.ACCRUAL<ACR.NEXT.POST.DT>  = Y.NEXT.DATE
		R.ATI.TL.IMB.ACCRUAL<ACR.SCHD.AMT>      = R.FT.COMMISSION.TYPE<FT4.FLAT.AMT>
		R.ATI.TL.IMB.ACCRUAL<ACR.SCHD.POST>     = "Y"
		R.ATI.TL.IMB.ACCRUAL<ACR.CUSTOMER>      = Y.CUSTOMER
		R.ATI.TL.IMB.ACCRUAL<ACR.CURRENCY>      = Y.CURRENCY
		R.ATI.TL.IMB.ACCRUAL<ACR.DB.ACCT>       = Y.AC.ID
		R.ATI.TL.IMB.ACCRUAL<ACR.CR.ACCT>       = R.FT.COMMISSION.TYPE<FT4.CATEGORY.ACCOUNT>
		R.ATI.TL.IMB.ACCRUAL<ACR.DB.TXN.CODE>   = R.FT.COMMISSION.TYPE<FT4.TXN.CODE.DB>
		R.ATI.TL.IMB.ACCRUAL<ACR.CR.TXN.CODE>   = R.FT.COMMISSION.TYPE<FT4.TXN.CODE.CR>
		R.ATI.TL.IMB.ACCRUAL<ACR.FREQ.POST>     = R.ATI.TH.DORMANT.PARAM<DORMANT.PRM.FREQUENCY> : TODAY[2]
		R.ATI.TL.IMB.ACCRUAL<ACR.CO.CODE>       = Y.CO.CODE
		
		CALL F.WRITE(FN.ATI.TL.IMB.ACCRUAL,Y.ID.ACCR,R.ATI.TL.IMB.ACCRUAL)
	END
	
	CALL F.READ(FN.ATI.TH.ACCT.INACTIVE, Y.AC.ID, R.ATI.TH.ACCT.INACTIVE, F.ATI.TH.ACCT.INACTIVE, ATI.TH.ACCT.INACTIVE.ERR)
	R.ATI.TH.ACCT.INACTIVE<ACCT.INATIV.START.DATE> = TODAY
	CALL F.WRITE(FN.ATI.TH.ACCT.INACTIVE, Y.AC.ID, R.ATI.TH.ACCT.INACTIVE)
	
    RETURN
*-----------------------------------------------------------------------------
END




