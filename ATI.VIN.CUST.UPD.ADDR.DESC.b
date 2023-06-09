    SUBROUTINE ATI.VIN.CUST.UPD.ADDR.DESC
*-----------------------------------------------------------------------------
* Developer Name     : Fatkhur Rohman
* Development Date   : 20180418
* Description        : Routine to update province, city, district, municipal
*                      description/name from the ID list
*
*                      only update if the ID's address field is not empty
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date            Modified by                Description
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ATI.TH.ID.PROVINCE
	$INSERT I_F.ATI.TH.ID.CITY
	$INSERT I_F.ATI.TH.ID.DISTRICT
	$INSERT I_F.ATI.TH.ID.MUNICIPAL
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
    FN.ATI.TH.ID.PROVINCE = "F.ATI.TH.ID.PROVINCE"
	F.ATI.TH.ID.PROVINCE  = ""
	CALL OPF(FN.ATI.TH.ID.PROVINCE, F.ATI.TH.ID.PROVINCE)
	
	FN.ATI.TH.ID.CITY     = "F.ATI.TH.ID.CITY"
	F.ATI.TH.ID.CITY      = ""
	CALL OPF(FN.ATI.TH.ID.CITY, F.ATI.TH.ID.CITY)
	
	FN.ATI.TH.ID.DISTRICT = "F.ATI.TH.ID.DISTRICT"
	F.ATI.TH.ID.DISTRICT  = ""
	CALL OPF(FN.ATI.TH.ID.DISTRICT, F.ATI.TH.ID.DISTRICT)
	
	FN.ATI.TH.ID.MUNICIPAL = "F.ATI.TH.ID.MUNICIPAL"
	F.ATI.TH.ID.MUNICIPAL  = ""
	CALL OPF(FN.ATI.TH.ID.MUNICIPAL, F.ATI.TH.ID.MUNICIPAL)
	
    Y.APP = "CUSTOMER"
    Y.FLD = "ATI.PROVINCE.ID":VM:"ATI.CITY.ID":VM:"ATI.DISTRICT.ID":VM:"ATI.MUNICPAL.ID"
	Y.FLD := VM :"ATI.PROVINCE":VM:"ATI.CITY":VM:"ATI.DISTRICT"
    Y.POS = ""
    CALL MULTI.GET.LOC.REF(Y.APP,Y.FLD,Y.POS)
	
    Y.ATI.PROVINCE.ID.POS = Y.POS<1,1>
    Y.ATI.CITY.ID.POS     = Y.POS<1,2>
    Y.ATI.DISTRICT.ID.POS = Y.POS<1,3>
    Y.ATI.MUNICPAL.ID.POS = Y.POS<1,4>
	Y.ATI.PROVINCE.POS    = Y.POS<1,5>
	Y.ATI.CITY.POS        = Y.POS<1,6>
	Y.ATI.DISTRICT.POS    = Y.POS<1,7>

    RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    GOSUB CHECK.UPDATE.PROVINCE
	GOSUB CHECK.UPDATE.CITY
	GOSUB CHECK.UPDATE.DISTRICT
	GOSUB CHECK.UPDATE.MUNICIPAL

    RETURN

*-----------------------------------------------------------------------------
CHECK.UPDATE.PROVINCE:
*-----------------------------------------------------------------------------
	Y.ATI.PROVINCE.ID = R.NEW(EB.CUS.LOCAL.REF)<1, Y.ATI.PROVINCE.ID.POS>
	
	IF NOT(Y.ATI.PROVINCE.ID) THEN
		RETURN
	END
	
	CALL F.READ(FN.ATI.TH.ID.PROVINCE, Y.ATI.PROVINCE.ID, R.ATI.TH.ID.PROVINCE, F.ATI.TH.ID.PROVINCE, ATI.TH.ID.PROVINCE.ERR)
	
	R.NEW(EB.CUS.LOCAL.REF)<1, Y.ATI.PROVINCE.POS> = R.ATI.TH.ID.PROVINCE<ID.PROVINCE.NAME, 1, 1>

    RETURN

*-----------------------------------------------------------------------------
CHECK.UPDATE.CITY:
*-----------------------------------------------------------------------------
	Y.ATI.CITY.ID = R.NEW(EB.CUS.LOCAL.REF)<1, Y.ATI.CITY.ID.POS>
	
	IF NOT(Y.ATI.CITY.ID) THEN
		RETURN
	END
	
	CALL F.READ(FN.ATI.TH.ID.CITY, Y.ATI.CITY.ID, R.ATI.TH.ID.CITY, F.ATI.TH.ID.CITY, ATI.TH.ID.CITY.ERR)
	
	R.NEW(EB.CUS.LOCAL.REF)<1, Y.ATI.CITY.POS> = R.ATI.TH.ID.CITY<ID.CITY.NAME, 1, 1>

    RETURN

*-----------------------------------------------------------------------------
CHECK.UPDATE.DISTRICT:
*-----------------------------------------------------------------------------
	Y.ATI.DISTRICT.ID = R.NEW(EB.CUS.LOCAL.REF)<1, Y.ATI.DISTRICT.ID.POS>
	
	IF NOT(Y.ATI.DISTRICT.ID) THEN
		RETURN
	END
	
	CALL F.READ(FN.ATI.TH.ID.DISTRICT, Y.ATI.DISTRICT.ID, R.ATI.TH.ID.DISTRICT, F.ATI.TH.ID.DISTRICT, ATI.TH.ID.DISTRICT.ERR)
	
	R.NEW(EB.CUS.LOCAL.REF)<1, Y.ATI.DISTRICT.POS> = R.ATI.TH.ID.DISTRICT<ID.DISTRICT.NAME, 1, 1>

    RETURN


*-----------------------------------------------------------------------------
CHECK.UPDATE.MUNICIPAL:
*-----------------------------------------------------------------------------
	Y.ATI.MUNICIPAL.ID = R.NEW(EB.CUS.LOCAL.REF)<1, Y.ATI.MUNICPAL.ID.POS>
	
	IF NOT(Y.ATI.MUNICIPAL.ID) THEN
		RETURN
	END
	
	CALL F.READ(FN.ATI.TH.ID.MUNICIPAL, Y.ATI.MUNICIPAL.ID, R.ATI.TH.ID.MUNICIPAL, F.ATI.TH.ID.MUNICIPAL, ATI.TH.ID.MUNICIPAL.ERR)
	
	R.NEW(EB.CUS.TOWN.COUNTRY) = R.ATI.TH.ID.MUNICIPAL<ID.MUNICIPAL.NAME, 1, 1>

    RETURN

*-----------------------------------------------------------------------------
END
