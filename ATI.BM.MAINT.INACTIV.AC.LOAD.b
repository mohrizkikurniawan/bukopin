*-----------------------------------------------------------------------------
* <Rating>-181</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.BM.MAINT.INACTIV.AC.LOAD
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
    $INSERT I_ATI.BM.MAINT.INACTIV.AC.COMMON

*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------
    GOSUB INIT

    RETURN

*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT  = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
	
    FN.ATI.TH.ACCT.INACTIVE = 'F.ATI.TH.ACCT.INACTIVE'
    F.ATI.TH.ACCT.INACTIVE  = ''
    CALL OPF(FN.ATI.TH.ACCT.INACTIVE,F.ATI.TH.ACCT.INACTIVE)
	
    FN.ATI.TL.IMB.ACCRUAL = 'F.ATI.TL.IMB.ACCRUAL'
    F.ATI.TL.IMB.ACCRUAL  = ''
    CALL OPF(FN.ATI.TL.IMB.ACCRUAL,F.ATI.TL.IMB.ACCRUAL)

    FN.ATI.TH.DORMANT.PARAM = 'F.ATI.TH.DORMANT.PARAM'
    F.ATI.TH.DORMANT.PARAM  = ''
    CALL OPF(FN.ATI.TH.DORMANT.PARAM,F.ATI.TH.DORMANT.PARAM)
	
	FN.FT.COMMISSION.TYPE = 'F.FT.COMMISSION.TYPE'
    F.FT.COMMISSION.TYPE  = ''
    CALL OPF(FN.FT.COMMISSION.TYPE,F.FT.COMMISSION.TYPE)
	
	FN.ATI.TL.IMB.ACCRUAL = 'F.ATI.TL.IMB.ACCRUAL'
	F.ATI.TL.IMB.ACCRUAL  = ''
	CALL OPF(FN.ATI.TL.IMB.ACCRUAL, F.ATI.TL.IMB.ACCRUAL)
	
    FN.LOCKING = 'F.LOCKING'
    F.LOCKING  = ''
    CALL OPF(FN.LOCKING,F.LOCKING)
	
	Y.LOCKING.ID     = "ATI.BUKO.DORMANT"
	Y.FLAG.CHG.PARAM = ""
	
	CALL F.READ(FN.LOCKING, Y.LOCKING.ID, R.LOCKING, F.LOCKING, LCK.ERR)
	IF R.LOCKING THEN
	   Y.FLAG.CHG.PARAM = 1
       Y.LOCKING.PARAM  = R.LOCKING
	END
	
	Y.DORMANT.PRM.ID = "SYSTEM"
	CALL F.READ(FN.ATI.TH.DORMANT.PARAM, Y.DORMANT.PRM.ID, R.ATI.TH.DORMANT.PARAM, F.ATI.TH.DORMANT.PARAM, DORMANT.PRM.ERR)
	
	Y.ID.FTCOMM = R.ATI.TH.DORMANT.PARAM<DORMANT.PRM.CHARGE.CODE>
	CALL F.READ(FN.FT.COMMISSION.TYPE, Y.ID.FTCOMM, R.FT.COMMISSION.TYPE, F.FT.COMMISSION.TYPE, FTCOMM.ERR)
	Y.FLAT.AMT = R.FT.COMMISSION.TYPE<FT4.FLAT.AMT>
	
    RETURN
*-----------------------------------------------------------------------------
END




