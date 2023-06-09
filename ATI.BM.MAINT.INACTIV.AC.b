*-----------------------------------------------------------------------------
* <Rating>-181</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.BM.MAINT.INACTIV.AC(Y.AC.ID)
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
	$INSERT I_ATI.BM.MAINT.INACTIV.AC.COMMON

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
	CALL F.READ(FN.ACCOUNT, Y.AC.ID, R.ACCOUNT, F.ACCOUNT, AC.ERR)
	Y.INACTIV.MARKER = R.ACCOUNT<AC.INACTIV.MARKER>
	
    CALL F.READ(FN.ATI.TH.ACCT.INACTIVE, Y.AC.ID, R.ATI.TH.ACCT.INACTIVE, F.ATI.TH.ACCT.INACTIVE, ATI.TH.ACCT.INACTIVE.ERR)

	IF Y.INACTIV.MARKER EQ "" THEN
	* update ke history + isi end date
	   R.ATI.TH.ACCT.INACTIVE<ACCT.INACTIV.END.DATE> = TODAY
	   CALL ID.LIVE.WRITE(FN.ATI.TH.ACCT.INACTIVE, Y.AC.ID, R.ATI.TH.ACCT.INACTIVE)
	   
	   DELETE F.ATI.TH.ACCT.INACTIVE, Y.AC.ID
	   DELETE F.ATI.TL.IMB.ACCRUAL, Y.AC.ID
	END ELSE
       IF Y.FLAG.CHG.PARAM EQ 1 THEN
		*maintenance change parameter
		Y.ID.ACCR = Y.AC.ID:"-DORMANT"
		CALL F.READ(FN.ATI.TL.IMB.ACCRUAL,Y.ID.ACCR,R.ATI.TL.IMB.ACCRUAL,F.ATI.TL.IMB.ACCRUAL,ATI.TL.IMB.ACCRUAL.ERR)
		R.ATI.TL.IMB.ACCRUAL<ACR.SCHD.AMT> = Y.FLAT.AMT
		CALL F.WRITE(FN.ATI.TL.IMB.ACCRUAL,Y.ID.ACCR,R.ATI.TL.IMB.ACCRUAL)
	   END
	END
	
    RETURN
*-----------------------------------------------------------------------------
END




