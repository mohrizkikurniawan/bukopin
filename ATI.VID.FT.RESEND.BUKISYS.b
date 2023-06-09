*-----------------------------------------------------------------------------
* <Rating>-181</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.VID.FT.RESEND.BUKISYS
*-----------------------------------------------------------------------------
* Developer Name     : Dwi K
* Development Date   : 20180905
* Description        : Routine for checking value date
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date            Modified by                Description
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ATI.TH.INTF.OUT.TRANSACTION

*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------
    GOSUB INIT
    GOSUB PROCESS

    RETURN

*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
    FN.ATI.TH.INTF.OUT.TRANSACTION = 'F.ATI.TH.INTF.OUT.TRANSACTION'
    F.ATI.TH.INTF.OUT.TRANSACTION  = ''
    CALL OPF(FN.ATI.TH.INTF.OUT.TRANSACTION,F.ATI.TH.INTF.OUT.TRANSACTION)

    RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    Y.ID = COMI
	CALL F.READ(FN.ATI.TH.INTF.OUT.TRANSACTION, Y.ID, R.ATI.TH.INTF.OUT.TRANSACTION, F.ATI.TH.INTF.OUT.TRANSACTION, ATI.TH.INTF.OUT.TRANSACTION.ERR)
	Y.VALUE.DATE = R.ATI.TH.INTF.OUT.TRANSACTION<INTF.OUT.TRANS.VALUE.DATE>
	
	IF Y.VALUE.DATE NE TODAY THEN
	   E = "Transaksi Expired"
	   CALL ERR
	END
	
    RETURN
*-----------------------------------------------------------------------------
END




