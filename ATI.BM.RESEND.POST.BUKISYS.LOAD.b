*-----------------------------------------------------------------------------
* <Rating>-181</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.BM.RESEND.POST.BUKISYS.LOAD
*-----------------------------------------------------------------------------
* Developer Name     : Dwi K
* Development Date   : 20190124
* Description        : Routine for resend posting journal Bukisys
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date            Modified by                Description
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
	$INSERT I_ATI.BM.RESEND.POST.BUKISYS.COMMON
	$INSERT I_F.ATI.TH.INTF.GLOBAL.PARAM

*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------
    GOSUB INIT

    RETURN

*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
    FN.ATI.TH.INTF.OUT.TRANSACTION = 'F.ATI.TH.INTF.OUT.TRANSACTION'
    F.ATI.TH.INTF.OUT.TRANSACTION  = ''
    CALL OPF(FN.ATI.TH.INTF.OUT.TRANSACTION, F.ATI.TH.INTF.OUT.TRANSACTION)
	
    FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER'
    F.FUNDS.TRANSFER  = ''
    CALL OPF(FN.FUNDS.TRANSFER, F.FUNDS.TRANSFER)
	
	FN.ATI.TH.INTF.GLOBAL.PARAM = 'F.ATI.TH.INTF.GLOBAL.PARAM'
	F.ATI.TH.INTF.GLOBAL.PARAM  = ''
	CALL OPF(FN.ATI.TH.INTF.GLOBAL.PARAM, F.ATI.TH.INTF.GLOBAL.PARAM)
	
	CALL F.READ(FN.ATI.TH.INTF.GLOBAL.PARAM, 'SYSTEM', R.ATI.TH.INTF.GLOBAL.PARAM, F.ATI.TH.INTF.GLOBAL.PARAM, ATI.TH.INTF.GLOBAL.PARAM.ERR)
	Y.RESEND.POST.TIME = R.ATI.TH.INTF.GLOBAL.PARAM<GLOBAL.PARAM.RESEND.POST.TIME>
	
*	Y.TRANSACTION.LIST     = 'ACSF'
*	Y.TRANSACTION.LIST<-1> = 'ACFA'
*	Y.TRANSACTION.LIST<-1> = 'ACSP'
		
    RETURN
	
*-----------------------------------------------------------------------------
END




