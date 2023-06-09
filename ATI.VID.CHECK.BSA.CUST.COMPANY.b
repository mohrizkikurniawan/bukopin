    SUBROUTINE ATI.VID.CHECK.BSA.CUST.COMPANY
*-----------------------------------------------------------------------------
* Developer Name     : Fatkhur Rohman
* Development Date   : 20180417
* Description        : ID Routine to check company user access only for
*                      BSA customer (checked by field ATI.AGENT.ID)
*
*                      user access from BNK can input/amend all customer, else
*                      restricted to its company
*
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
    Y.APP = "CUSTOMER"
    Y.FLD = "ATI.AGENT.ID"
    Y.POS = ""
    CALL MULTI.GET.LOC.REF(Y.APP,Y.FLD,Y.POS)
    Y.ATI.AGENT.ID.POS = Y.POS<1,1>

	FN.CUSTOMER = "F.CUSTOMER"
	F.CUSTOMER  = ""
	CALL OPF(FN.CUSTOMER, F.CUSTOMER)
	
	Y.ID.NEW = ""
	IF COMI THEN
		Y.ID.NEW = COMI
	END ELSE
		Y.ID.NEW = ID.NEW
	END

    RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    CALL F.READ(FN.CUSTOMER, Y.ID.NEW, R.CUSTOMER, F.CUSTOMER, CUSTOMER.ERR)
	
	Y.COMPANY.BOOK = R.CUSTOMER<EB.CUS.COMPANY.BOOK>
	Y.ATI.AGENT.ID = R.CUSTOMER<EB.CUS.LOCAL.REF, Y.ATI.AGENT.ID.POS>
	
	IF (ID.COMPANY NE 'ID0010001') AND (Y.COMPANY.BOOK NE ID.COMPANY) AND (Y.ATI.AGENT.ID) THEN
		E = 'EB-OTHER.COMPANY.ACCESS'
	END

    RETURN

*-----------------------------------------------------------------------------
END