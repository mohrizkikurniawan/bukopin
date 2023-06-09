    SUBROUTINE ATI.VID.REPRINT.FT
*-----------------------------------------------------------------------------
* Developer Name     : Dwi K
* Development Date   : 20190326
* Description        : Routine to validate ft id
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
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
	
	FN.FUNDS.TRANSFER = "F.FUNDS.TRANSFER"
	F.FUNDS.TRANSFER  = ""
	CALL OPF(FN.FUNDS.TRANSFER, F.FUNDS.TRANSFER)
	
    RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------

    Y.ID = COMI
    CALL F.READ(FN.FUNDS.TRANSFER, Y.ID, R.FUNDS.TRANSFER, F.FUNDS.TRANSFER, FT.ERR)
    IF NOT(R.FUNDS.TRANSFER) THEN
       E = "Nomor FT tidak ditemukan"
	   CALL STORE.END.ERROR
    END
	
	Y.TRANSACTION.TYPE = R.FUNDS.TRANSFER<FT.TRANSACTION.TYPE>
	Y.VERSION          = APPLICATION:PGM.VERSION
	
	BEGIN CASE
	CASE Y.TRANSACTION.TYPE EQ "ACTP" AND Y.VERSION NE "ATI.TH.REPRINT.DEALSLIP,FT.TXN"
	   E = "Nomor FT untuk setoran tunai"
	   CALL STORE.END.ERROR
	CASE Y.TRANSACTION.TYPE EQ "ACWD" AND Y.VERSION NE "ATI.TH.REPRINT.DEALSLIP,FT.WTD.TXN"
	   E = "Nomor FT untuk tarik tunai"
	   CALL STORE.END.ERROR
	END CASE
	
	RETURN

*-----------------------------------------------------------------------------
END











