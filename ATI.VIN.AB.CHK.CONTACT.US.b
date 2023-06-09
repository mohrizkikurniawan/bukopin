*-----------------------------------------------------------------------------
* <Rating>-181</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.VIN.AB.CHK.CONTACT.US
*-----------------------------------------------------------------------------
* Developer Name     : Fatkhur Rohman
* Development Date   : 20180827
* Description        : Routine for validating contact us menu access for BTunai
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date            Modified by                Description
*-----------------------------------------------------------------------------
* 20191022		  Dwi K						 - Account validation only for type CUSTOMER
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
	$INSERT I_F.ATI.TH.AB.CONTACT.US
	$INSERT I_F.ATI.TH.AB.CUSTOMER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER

*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------

    GOSUB INIT
    GOSUB PROCESS

    RETURN

*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT  = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
	
	FN.CUSTOMER = 'F.CUSTOMER'
	F.CUSTOMER  = ''
	CALL OPF(FN.CUSTOMER, F.CUSTOMER)
	
    FN.ATI.TH.AB.CUSTOMER = 'F.ATI.TH.AB.CUSTOMER'
	F.ATI.TH.AB.CUSTOMER  = ''
	CALL OPF(FN.ATI.TH.AB.CUSTOMER, F.ATI.TH.AB.CUSTOMER)

    RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
*/20191022-DWK
    IF R.NEW(AB.CONT.US.TYPE) EQ 'AGENT' THEN
	   RETURN
	END
*\20191022-DWK
	
    Y.BSA.ID = "+" : R.NEW(AB.CONT.US.ACCOUNT.NO)
	CALL F.READ(FN.ATI.TH.AB.CUSTOMER, Y.BSA.ID, R.ATI.TH.AB.CUSTOMER, F.ATI.TH.AB.CUSTOMER, ERR.ATI.TH.AB.CUSTOMER)

	IF NOT(R.ATI.TH.AB.CUSTOMER) THEN
		AF    = AB.CONT.US.ACCOUNT.NO
		ETEXT = 'EB-ENQ.AB.INVALID.CUST'
		CALL STORE.END.ERROR
		
		RETURN
	END
	
	Y.CUSTOMER   = R.ATI.TH.AB.CUSTOMER<AB.CUS.CUSTOMER>
	Y.ACCOUNT.NO = R.ATI.TH.AB.CUSTOMER<AB.CUS.ACCOUNT.NO>
	
	CALL F.READ(FN.CUSTOMER, Y.CUSTOMER, R.CUSTOMER, F.CUSTOMER, ERR.CUSTOMER)
	Y.CUST.RESTRICT = R.CUSTOMER<EB.CUS.POSTING.RESTRICT>
	
    CALL F.READ(FN.ACCOUNT, Y.ACCOUNT.NO, R.ACCOUNT, F.ACCOUNT, ERR.ACCOUNT)
	Y.AC.RESTRICT = R.ACCOUNT<AC.POSTING.RESTRICT>
	
	IF (Y.CUST.RESTRICT NE '') OR (Y.AC.RESTRICT NE '') THEN
		AF    = AB.CONT.US.ACCOUNT.NO
		ETEXT = 'EB-AC.IS.RESTRICTED'
		CALL STORE.END.ERROR
		
		RETURN
	END
		
    RETURN
*-----------------------------------------------------------------------------
END




