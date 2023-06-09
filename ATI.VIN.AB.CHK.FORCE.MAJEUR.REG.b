*-----------------------------------------------------------------------------
    SUBROUTINE ATI.VIN.AB.CHK.FORCE.MAJEUR.REG
*-----------------------------------------------------------------------------
* Developer Name     : Fatkhur Rohman
* Development Date   : 20180604
* Description        : Routine to check account status for force majeur
*                      cash withdrawal transaction

*                      for Agent Banking (lakupandai)
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date               :
* Modified by        :
* Description        :
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
	CALL OPF(FN.FUNDS.TRANSFER, F.FUNDS.TRANSFER)
	
	FN.ATI.TH.AB.FORCE.MAJEUR = "F.ATI.TH.AB.FORCE.MAJEUR"
	CALL OPF(FN.ATI.TH.AB.FORCE.MAJEUR, F.ATI.TH.AB.FORCE.MAJEUR)

	RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
	Y.DEBIT.ACCT.NO = R.NEW(FT.DEBIT.ACCT.NO)
	
*check registered force majeur record in live record
	SEL.CMD = "SELECT ":FN.ATI.TH.AB.FORCE.MAJEUR:" WITH ACCOUNT.NO EQ ":Y.DEBIT.ACCT.NO
	CALL EB.READLIST(SEL.CMD, SEL.LIST, "", NO.OF.REC, ERR.SEL)
	
	IF NOT(SEL.LIST) THEN
		ETEXT = "EB-AB.FRC.MAJ.ACCT.NOT.REGISTERED"
		AF    = FT.DEBIT.ACCT.NO
		CALL STORE.END.ERROR
		
		RETURN
	END
*
	
	RETURN
	
*-----------------------------------------------------------------------------	
END
	