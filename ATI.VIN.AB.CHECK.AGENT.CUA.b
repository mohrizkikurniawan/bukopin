*-----------------------------------------------------------------------------
    SUBROUTINE ATI.VIN.AB.CHECK.AGENT.CUA
*-----------------------------------------------------------------------------
* Developer Name     : Fatkhur Rohman
* Development Date   : 20180412
* Description        : Routine to check customer and account inputted by user
*                      customer should has the same type as the agent type and
*                      account should be filled with its customer account

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
	$INSERT I_F.ATI.TH.AB.AGENT
	
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
    Y.FLD = "ATI.CUST.TYPE"
    Y.POS = ""
    CALL MULTI.GET.LOC.REF(Y.APP,Y.FLD,Y.POS)
	
	Y.ATI.CUST.TYPE.POS = Y.POS<1,1>
	
	FN.CUSTOMER = "F.CUSTOMER"
	F.CUSTOMER  = ""
	CALL OPF(FN.CUSTOMER, F.CUSTOMER)
	
	FN.CUSTOMER.ACCOUNT = "F.CUSTOMER.ACCOUNT"
	F.CUSTOMER.ACCOUNT  = ""
	CALL OPF(FN.CUSTOMER.ACCOUNT, F.CUSTOMER.ACCOUNT)

	RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
	Y.AGENT.TYPE  = R.NEW(AB.AGN.AGENT.TYPE)
	Y.CUSTOMER.ID = R.NEW(AB.AGN.CUSTOMER.ID)
	Y.ACCOUNT.NO  = R.NEW(AB.AGN.ACCOUNT.NO)
	
	CALL F.READ(FN.CUSTOMER, Y.CUSTOMER.ID, R.CUSTOMER, F.CUSTOMER, CUSTOMER.ERR)
	Y.ATI.CUST.TYPE = R.CUSTOMER<EB.CUS.LOCAL.REF, Y.ATI.CUST.TYPE.POS>
	
	CALL F.READ(FN.CUSTOMER.ACCOUNT, Y.CUSTOMER.ID, R.CUSTOMER.ACCOUNT, F.CUSTOMER.ACCOUNT, CUSTOMER.ACCOUNT.ERR)
	
	BEGIN CASE
	CASE Y.AGENT.TYPE EQ 'INDIVIDUAL'
		IF Y.ATI.CUST.TYPE EQ 'C' THEN
			ETEXT = 'EB-AB.INVALID.CUSTOMER.TYPE'
			AF    = AB.AGN.CUSTOMER.ID
			CALL STORE.END.ERROR
			
			RETURN
		END
		
		GOSUB CHECK.ACCOUNT
		
	CASE Y.AGENT.TYPE EQ 'CORPORATE'
		IF Y.ATI.CUST.TYPE NE 'C' THEN
			ETEXT = 'EB-AB.INVALID.CUSTOMER.TYPE'
			AF    = AB.AGN.CUSTOMER.ID
			CALL STORE.END.ERROR
			
			RETURN
		END
		
		GOSUB CHECK.ACCOUNT
		
	CASE 1
	END CASE
	
	RETURN

*-----------------------------------------------------------------------------
CHECK.ACCOUNT:
*-----------------------------------------------------------------------------
	IF R.CUSTOMER.ACCOUNT THEN
		FIND Y.ACCOUNT.NO IN R.CUSTOMER.ACCOUNT SETTING POSF, POSV, POSS ELSE
			ETEXT     = 'AA-ACCT.NOT.OF.CUSTOMER'
			ETEXT<-1> = Y.CUSTOMER.ID
			AF        = AB.AGN.ACCOUNT.NO
			CALL STORE.END.ERROR
			
			RETURN
		END
	END
	
	RETURN
	
*-----------------------------------------------------------------------------	
END
	