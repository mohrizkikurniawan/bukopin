	
	SUBROUTINE ATI.TH.RIZ1.FIELDS
	
	
	$INSERT I_COMMON
	$INSERT I_EQUATE
	$INSERT I_DataTypes
	
	ID.CHECKFILE = "" ; ID.CONCATFILE = ""
	ID.F = "" ; ID.N = "10" ; ID.T = "A"
	
	CALL Table.addField("CUSTOMER.ID", T24_Customer, Field_Mandatory, "")
	CALL Table.addField("CUSTOMER.NAME", T24_Customer, Field_NoInput, "")
	CALL Table.addFieldDefinition("OPENING.DATE", T24_date, "", "")
	CALL Table.addField("ACCOUNT.NO", T24_Account, "", "")
	CALL Table.addFieldDefinition("CURRENCY", "3", "A", "")
	CALL Field.setCheckFile("CURRENCY")
	CALL Table.addField("SECTOR", T24_Sector, "", "")
	
	CALL Table.addField("RESERVED.5", T24_String, Field_NoInput, "")
	CALL Table.addField("RESERVED.4", T24_String, Field_NoInput, "")
	CALL Table.addField("RESERVED.3", T24_String, Field_NoInput, "")
	CALL Table.addField("RESERVED.2", T24_String, Field_NoInput, "")
	CALL Table.addField("RESERVED.1", T24_String, Field_NoInput, "")
	CALL Table.addField("XX.LOCAL.REF", T24_String, Field_NoInput, "")
	CALL Table.addField("XX.OVERRIDE", T24_String, Field_NoInput, "")
	
	CALL Table.setAuditPosition
	
	RETURN
END