    SUBROUTINE ATI.VIN.CUS.CHECK.MIN.CHAR
*-----------------------------------------------------------------------------
* Developer Name     : Dhio Faizar Wahyudi
* Development Date   : 20181129
* Description        : Routine to validate minimum character
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date            Modified by                Description
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
	$INSERT I_F.CUSTOMER
	$INSERT I_F.ATI.TH.EC.USERNAME

*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------

	GOSUB INIT
	
	BEGIN CASE
	CASE APPLICATION EQ "CUSTOMER"
	     GOSUB PROCESS.CUSTOMER
	CASE APPLICATION EQ "ATI.TH.EC.USERNAME"
	     GOSUB PROCESS.ATI.TH.EC.USERNAME
	END CASE

    RETURN

*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
    
	YAPP = "CUSTOMER"
	YFLD = "ATI.ADDR.DOM" :@VM: "ATI.MOTH.MAIDEN"
	YPOS = ""
	
	CALL MULTI.GET.LOC.REF(YAPP, YFLD, YPOS)
	
	Y.ATI.ADDR.DOM.POS    = YPOS<1, 1>
	Y.ATI.MOTH.MAIDEN.POS = YPOS<1, 2>
	
    RETURN

*-----------------------------------------------------------------------------
PROCESS.CUSTOMER:
*-----------------------------------------------------------------------------

	Y.CUSTOMER.NAME            = R.NEW(EB.CUS.NAME.1)
	Y.CUSTOMER.SMS             = R.NEW(EB.CUS.SMS.1)
	Y.CUSTOMER.SHORT.NAME      = R.NEW(EB.CUS.SHORT.NAME)
	Y.CUSTOMER.ATI.ADDR.DOM    = R.NEW(EB.CUS.LOCAL.REF)<1, Y.ATI.ADDR.DOM.POS>
	Y.CUSTOMER.ATI.MOTH.MAIDEN = R.NEW(EB.CUS.LOCAL.REF)<1, Y.ATI.MOTH.MAIDEN.POS>
	
	Y.CUSTOMER.NAME.CNT            = LEN(Y.CUSTOMER.NAME)
	Y.CUSTOMER.SMS.CNT             = LEN(Y.CUSTOMER.SMS)
	Y.CUSTOMER.SHORT.NAME.CNT      = LEN(Y.CUSTOMER.SHORT.NAME)
	Y.CUSTOMER.ATI.ADDR.DOM.CNT    = LEN(Y.CUSTOMER.ATI.ADDR.DOM)
	Y.CUSTOMER.ATI.MOTH.MAIDEN.CNT = LEN(Y.CUSTOMER.ATI.MOTH.MAIDEN)
	
	IF Y.CUSTOMER.NAME.CNT LT 3 THEN
		ETEXT = "EB-CU.MIN.CHARACTER":FM:"3"
		AF    = EB.CUS.NAME.1
		CALL STORE.END.ERROR
	END
	
	IF Y.CUSTOMER.SMS.CNT LT 9 THEN
		ETEXT = "EB-CU.MIN.CHARACTER":FM:"9"
		AF    = EB.CUS.SMS.1
		CALL STORE.END.ERROR
	END
	
	IF Y.CUSTOMER.SHORT.NAME.CNT LT 3 THEN
		ETEXT = "EB-CU.MIN.CHARACTER":FM:"3"
		AF    = EB.CUS.SHORT.NAME
		CALL STORE.END.ERROR
	END
	
	IF Y.CUSTOMER.ATI.MOTH.MAIDEN.CNT LT 3 THEN
		ETEXT = "EB-CU.MIN.CHARACTER":FM:"3"
		AF    = EB.CUS.LOCAL.REF
		AV    = Y.ATI.MOTH.MAIDEN.POS
		CALL STORE.END.ERROR
	END
	
	IF Y.CUSTOMER.ATI.ADDR.DOM NE "" AND Y.CUSTOMER.ATI.ADDR.DOM.CNT LT 10 THEN
		ETEXT = "EB-CU.MIN.CHARACTER":FM:"10"
		AF    = EB.CUS.LOCAL.REF
		AV    = Y.ATI.ADDR.DOM.POS
		CALL STORE.END.ERROR
	END

	RETURN
*-----------------------------------------------------------------------------
PROCESS.ATI.TH.EC.USERNAME:
*-----------------------------------------------------------------------------

	Y.ATI.TH.EC.USERNAME.MOBILE.NO = R.NEW(EC.USER.MOBILE.NO)
	
	Y.ATI.TH.EC.USERNAME.MOBILE.NO.CNT = LEN(Y.ATI.TH.EC.USERNAME.MOBILE.NO)
	
	IF Y.ATI.TH.EC.USERNAME.MOBILE.NO.CNT LT 9 THEN
		ETEXT = "EB-CU.MIN.CHARACTER":FM:"9"
		AF    = EC.USER.MOBILE.NO
		CALL STORE.END.ERROR
	END

	RETURN
*-----------------------------------------------------------------------------

END
