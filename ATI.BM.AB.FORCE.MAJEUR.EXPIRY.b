    SUBROUTINE ATI.BM.AB.FORCE.MAJEUR.EXPIRY(Y.ID)
*-----------------------------------------------------------------------------
* Developer Name     : Fatkhur Rohman
* Development Date   : 20180604
* Description        : Subroutine to set flag expired force majeur
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date            Modified by                Description
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ATI.TH.AB.FORCE.MAJEUR
	$INSERT I_F.ATI.TH.AB.CUSTOMER
    $INSERT I_ATI.BM.AB.FORCE.MAJEUR.EXPIRY.COMMON

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
    CALL F.READ(FN.ATI.TH.AB.FORCE.MAJEUR, Y.ID, R.ATI.TH.AB.FORCE.MAJEUR, F.ATI.TH.AB.FORCE.MAJEUR, ERR.ATI.TH.AB.FORCE.MAJEUR)
	
	Y.ACCOUNT.NO = R.ATI.TH.AB.FORCE.MAJEUR<AB.FRC.MAJ.ACCOUNT.NO>
	Y.CURR.NO    = R.ATI.TH.AB.FORCE.MAJEUR<AB.FRC.MAJ.CURR.NO>

*update force majeur flag to null
	Y.AB.CUSTOMER.ID = "+": Y.ACCOUNT.NO
    
	CALL F.READ(FN.ATI.TH.AB.CUSTOMER, Y.AB.CUSTOMER.ID, R.ATI.TH.AB.CUSTOMER, F.ATI.TH.AB.CUSTOMER, ERR.ATI.TH.AB.CUSTOMER)
	R.ATI.TH.AB.CUSTOMER<AB.CUS.FORCE.MAJEUR> = ''
	
	CALL ID.LIVE.WRITE(FN.ATI.TH.AB.CUSTOMER, Y.AB.CUSTOMER.ID, R.ATI.TH.AB.CUSTOMER)
*

*move force majeur record to history file
	Y.ID.HIS = Y.ID : ";" : Y.CURR.NO
	
	R.ATI.TH.AB.FORCE.MAJEUR.HIS = R.ATI.TH.AB.FORCE.MAJEUR
	R.ATI.TH.AB.FORCE.MAJEUR.HIS<AB.FRC.MAJ.RECORD.STATUS> = 'MAT'
	
	CALL F.WRITE(FN.ATI.TH.AB.FORCE.MAJEUR.HIS, Y.ID.HIS, R.ATI.TH.AB.FORCE.MAJEUR.HIS)
	
	CALL F.DELETE(FN.ATI.TH.AB.FORCE.MAJEUR, Y.ID)
*

    RETURN

*-----------------------------------------------------------------------------
END
