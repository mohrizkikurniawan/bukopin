*-----------------------------------------------------------------------------
* <Rating>-30</Rating>
* 08:36:06 18 JUL 2017 
* JFT/t24r11 
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.VIN.EC.USER.CUS.ONBOARD.RB
*-----------------------------------------------------------------------------
* Developer Name     : Dhio Faizar Wahyudi
* Development Date   : 20200515
* Description        : Copy From ATI.VIN.EC.USER.CUS.ONBOARD
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date            Modified by                Description
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ATI.TH.EC.USERNAME
    $INSERT I_F.ATI.TH.INTF.ORK.DATA
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
    FN.ATI.TH.EC.USERNAME = "F.ATI.TH.EC.USERNAME"
    CALL OPF(FN.ATI.TH.EC.USERNAME, F.ATI.TH.EC.USERNAME)

    FN.CUSTOMER = "F.CUSTOMER"
    CALL OPF(FN.CUSTOMER, F.CUSTOMER)
	
	FN.ATI.TH.INTF.ORK.DATA = "F.ATI.TH.INTF.ORK.DATA"
	F.ATI.TH.INTF.ORK.DATA = ""
	CALL OPF(FN.ATI.TH.INTF.ORK.DATA, F.ATI.TH.INTF.ORK.DATA)

    Y.APP = "CUSTOMER"
    Y.FLD = "ATI.LEGACY.AC"
    CALL MULTI.GET.LOC.REF(Y.APP, Y.FLD, Y.POS)
    Y.ATI.LEGACY.AC.POS = Y.POS<1, 1>	

    RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    Y.CUSTOMER                = R.NEW(EC.USER.CUSTOMER)
	Y.ATI.TH.INTF.ORK.DATA.ID = R.NEW(EC.USER.CUST.ONBOARD.ORK)
	
	IF Y.ATI.TH.INTF.ORK.DATA.ID THEN
		CALL F.READ(FN.ATI.TH.INTF.ORK.DATA, Y.ATI.TH.INTF.ORK.DATA.ID, R.ATI.TH.INTF.ORK.DATA, F.ATI.TH.INTF.ORK.DATA, ERR.ATI.TH.INTF.ORK.DATA)
		Y.MAPPING    = R.ATI.TH.INTF.ORK.DATA<ORK.DATA.MAPPING>
		Y.FIELD.LIST = R.ATI.TH.INTF.ORK.DATA<ORK.DATA.FIELD>
		Y.VALUE.LIST = R.ATI.TH.INTF.ORK.DATA<ORK.DATA.VALUE>
		
		FIND "STATUS.ONBOARDING" IN Y.FIELD.LIST SETTING POSF, POSV THEN
			Y.STATUS.ONBOARDING = Y.VALUE.LIST<1, POSV>
		END
	END
	
	IF Y.STATUS.ONBOARDING EQ "PENDING" THEN
		CALL F.READ(FN.CUSTOMER, Y.CUSTOMER, R.CUSTOMER, F.CUSTOMER, ERR.CUSTOMER)
		Y.ATI.LEGACY.AC = R.CUSTOMER<EB.CUS.LOCAL.REF, Y.ATI.LEGACY.AC.POS>

		IF NOT(Y.ATI.LEGACY.AC) THEN
			R.NEW(EC.USER.CUST.ONBOARD.STATUS) = "PENDING LEGACY"
		END
		ELSE
			R.NEW(EC.USER.CUST.ONBOARD.STATUS) = "DONE"
		END
	END ELSE
		R.NEW(EC.USER.CUST.ONBOARD.STATUS) = Y.STATUS.ONBOARDING
	END

    RETURN
*-----------------------------------------------------------------------------
END
