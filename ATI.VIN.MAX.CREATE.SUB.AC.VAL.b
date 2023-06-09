    SUBROUTINE ATI.VIN.MAX.CREATE.SUB.AC.VAL
*-----------------------------------------------------------------------------
* Developer Name     : Dhio Faizar Wahyudi
* Development Date   : 20180626
* Description        : Routine to validate max create sub ac based on parameter(ATI.TH.INTF.GLOBAL.PARAM)
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ATI.TH.INTF.GLOBAL.PARAM
    $INSERT I_F.ATI.TH.EC.USERNAME
	$INSERT I_F.ATI.TH.INTF.ORK.DATA
	$INSERT I_F.CUSTOMER
	$INSERT I_F.ACCOUNT

*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------

    GOSUB INIT
    GOSUB PROCESS

    RETURN
*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
	
	FN.ATI.TH.INTF.GLOBAL.PARAM = "F.ATI.TH.INTF.GLOBAL.PARAM"
	F.ATI.TH.INTF.GLOBAL.PARAM = ""
	CALL OPF(FN.ATI.TH.INTF.GLOBAL.PARAM, F.ATI.TH.INTF.GLOBAL.PARAM)
	
	FN.ATI.TH.EC.USERNAME = "F.ATI.TH.EC.USERNAME"
	F.ATI.TH.EC.USERNAME = ""
	CALL OPF(FN.ATI.TH.EC.USERNAME, F.ATI.TH.EC.USERNAME)
	
	FN.CUSTOMER = "F.CUSTOMER"
	F.CUSTOMER = ""
	CALL OPF(FN.CUSTOMER, F.CUSTOMER)
	
	FN.ACCOUNT = "F.ACCOUNT"
	F.ACCOUNT = ""
	CALL OPF(FN.ACCOUNT, F.ACCOUNT)

	CALL F.READ(FN.ATI.TH.INTF.GLOBAL.PARAM, "SYSTEM", R.ATI.TH.INTF.GLOBAL.PARAM, F.ATI.TH.INTF.GLOBAL.PARAM, ATI.TH.INTF.GLOBAL.PARAM.ERR)
	Y.ATI.TH.INTF.GLOBAL.PARAM.MAX.SUB.AC = R.ATI.TH.INTF.GLOBAL.PARAM<GLOBAL.PARAM.MAX.SUB.AC>
	
	Y.ATI.TH.INTF.ORK.DATA.FIELD = R.NEW(ORK.DATA.FIELD)
	Y.ATI.TH.INTF.ORK.DATA.VALUE = R.NEW(ORK.DATA.VALUE)
	
	FIND "CUSTOMER.ID" IN Y.ATI.TH.INTF.ORK.DATA.FIELD SETTING Y.POSF.ORK, Y.POSV.ORK THEN
		Y.CUSTOMER.ID = Y.ATI.TH.INTF.ORK.DATA.VALUE<1, Y.POSV.ORK>
	END
	
	Y.TOTAL.SUB.AC = 0
	
    RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
	
	IF Y.CUSTOMER.ID EQ "" THEN RETURN
	
	CALL F.READ(FN.CUSTOMER, Y.CUSTOMER.ID, R.CUSTOMER, F.CUSTOMER, CUSTOMER.ERR)
	Y.CUSTOMER.EMAIL.1 = R.CUSTOMER<EB.CUS.EMAIL.1, 1>
    
*	SEL.CMD = "SELECT " : FN.ATI.TH.EC.USERNAME : " WITH CUSTOMER EQ " : Y.CUSTOMER.ID
*	CALL EB.READLIST(SEL.CMD, SEL.LIST, "", NO.OF.REC, RET.CODE)
	
	Y.ATI.TH.EC.USERNAME.ID = Y.CUSTOMER.EMAIL.1
	CALL F.READ(FN.ATI.TH.EC.USERNAME, Y.ATI.TH.EC.USERNAME.ID, R.ATI.TH.EC.USERNAME, F.ATI.TH.EC.USERNAME, ATI.TH.EC.USERNAME.ERR)
	
	IF R.ATI.TH.EC.USERNAME EQ "" THEN RETURN
	
	Y.CNT.SUB.AC = DCOUNT(R.ATI.TH.EC.USERNAME<EC.USER.SUB.AC>, @VM)
	
	FOR Y.LOOP = 1 TO Y.CNT.SUB.AC
		Y.ACCOUNT.ID = R.ATI.TH.EC.USERNAME<EC.USER.SUB.AC, Y.LOOP>
		CALL F.READ(FN.ACCOUNT, Y.ACCOUNT.ID, R.ACCOUNT, F.ACCOUNT, ACCOUNT.ERR)
		IF R.ACCOUNT<AC.CATEGORY> NE "6002" THEN
			Y.TOTAL.SUB.AC += 1
		END
	NEXT Y.LOOP
	
	IF Y.TOTAL.SUB.AC GE Y.ATI.TH.INTF.GLOBAL.PARAM.MAX.SUB.AC THEN
		AF = ""
		ETEXT = "EB-ATI.SUB.AC.MAX"
		CALL STORE.END.ERROR
	END
	
	RETURN

*-----------------------------------------------------------------------------
END











