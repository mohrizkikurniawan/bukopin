    SUBROUTINE ATI.BM.AB.FORCE.MAJEUR.EXPIRY.LOAD
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
	$INSERT I_F.DATES
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
	FN.ATI.TH.AB.FORCE.MAJEUR = "F.ATI.TH.AB.FORCE.MAJEUR"
    CALL OPF(FN.ATI.TH.AB.FORCE.MAJEUR, F.ATI.TH.AB.FORCE.MAJEUR)
	
	FN.ATI.TH.AB.FORCE.MAJEUR.HIS = "F.ATI.TH.AB.FORCE.MAJEUR$HIS"
    CALL OPF(FN.ATI.TH.AB.FORCE.MAJEUR.HIS, F.ATI.TH.AB.FORCE.MAJEUR.HIS)

    FN.ATI.TH.AB.CUSTOMER = "F.ATI.TH.AB.CUSTOMER"
	CALL OPF(FN.ATI.TH.AB.CUSTOMER, F.ATI.TH.AB.CUSTOMER)
	
	Y.NEXT.WORKING.DAY = R.DATES(EB.DAT.NEXT.WORKING.DAY)

    RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------

    RETURN
*-----------------------------------------------------------------------------
END
