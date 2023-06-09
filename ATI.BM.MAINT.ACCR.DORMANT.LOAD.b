*-----------------------------------------------------------------------------
* <Rating>-181</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.BM.MAINT.ACCR.DORMANT.LOAD
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
    $INSERT I_ATI.BM.MAINT.ACCR.DORMANT.COMMON

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
	
    FN.ACCOUNT.INACTIVE = 'F.ACCOUNT.INACTIVE'
    F.ACCOUNT.INACTIVE  = ''
    CALL OPF(FN.ACCOUNT.INACTIVE,F.ACCOUNT.INACTIVE)
	
    FN.ATI.TH.ACCT.INACTIVE = 'F.ATI.TH.ACCT.INACTIVE'
    F.ATI.TH.ACCT.INACTIVE  = ''
    CALL OPF(FN.ATI.TH.ACCT.INACTIVE,F.ATI.TH.ACCT.INACTIVE)
	
    FN.ATI.TL.IMB.ACCRUAL = 'F.ATI.TL.IMB.ACCRUAL'
    F.ATI.TL.IMB.ACCRUAL  = ''
    CALL OPF(FN.ATI.TL.IMB.ACCRUAL,F.ATI.TL.IMB.ACCRUAL)	

	FN.FT.COMMISSION.TYPE = 'F.FT.COMMISSION.TYPE'
    F.FT.COMMISSION.TYPE  = ''
    CALL OPF(FN.FT.COMMISSION.TYPE,F.FT.COMMISSION.TYPE)
	
    FN.ATI.TH.DORMANT.PARAM = 'F.ATI.TH.DORMANT.PARAM'
    F.ATI.TH.DORMANT.PARAM  = ''
    CALL OPF(FN.ATI.TH.DORMANT.PARAM,F.ATI.TH.DORMANT.PARAM)
	
    RETURN
*-----------------------------------------------------------------------------
END




