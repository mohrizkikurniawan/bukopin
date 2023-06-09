*-----------------------------------------------------------------------------
    SUBROUTINE ATI.TH.NEED.MONEY.FIELDS
*-----------------------------------------------------------------------------
* Developer Name     : Dhio Faizar Wahyudi
* Development Date   : 20171002
* Description        : Table of Need Money Transaction
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date               :
* Modified by        :
* Description        :
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes

*-----------------------------------------------------------------------------
    ID.CHECKFILE = "" ; ID.CONCATFILE = ""
    ID.F = "@ID" ; ID.N ="12" ; ID.T = "A"

*-----------------------------------------------------------------------------
	CALL Table.addFieldDefinition("VALUE.DATE", "11", "D", "")
	CALL Table.addFieldDefinition("STATUS", "10", FM:"APPROVE_REJECT", "")
	CALL Table.addFieldDefinition("DB.CUSTOMER", "10", "", "")
	CALL Field.setCheckFile("CUSTOMER")
    CALL Table.addFieldDefinition("DB.ACCOUNT", "19", "POSANT", "")
	CALL Field.setCheckFile("ACCOUNT")
	CALL Table.addFieldDefinition("CR.CUSTOMER", "10", "", "")
	CALL Field.setCheckFile("CUSTOMER")
	CALL Table.addFieldDefinition("CR.ACCOUNT", "19", "POSANT", "")
	CALL Field.setCheckFile("ACCOUNT")
	CALL Table.addFieldDefinition("AMOUNT", "25", "AMT", "")
	CALL Table.addFieldDefinition("NOTES", "65", "A", "")
	CALL Table.addFieldDefinition("TRANS.CATEG", "15", "A", "")
	CALL Table.addFieldDefinition("SPLIT.BILL.ID", "12", "A", "")	
	CALL Table.addFieldDefinition("FT.ID", "12", "A", "")	
	CALL Table.addFieldDefinition("SPLIT.BILL.POSITION", "3", "A", "")
	CALL Table.addFieldDefinition("EMAIL", "65", "ANY", "")
	CALL Table.addFieldDefinition("MESSAGE.ID", "35", "A", "")

*-----------------------------------------------------------------------------
    CALL Table.addField("RESERVED.17", T24_String, Field_NoInput, "")
    CALL Table.addField("RESERVED.16", T24_String, Field_NoInput, "")
    CALL Table.addField("RESERVED.15", T24_String, Field_NoInput, "")
    CALL Table.addField("RESERVED.14", T24_String, Field_NoInput, "")
    CALL Table.addField("RESERVED.13", T24_String, Field_NoInput, "")
    CALL Table.addField("RESERVED.12", T24_String, Field_NoInput, "")
    CALL Table.addField("RESERVED.11", T24_String, Field_NoInput, "")
    CALL Table.addField("RESERVED.10", T24_String, Field_NoInput, "")
    CALL Table.addField("RESERVED.9", T24_String, Field_NoInput, "")
    CALL Table.addField("RESERVED.8", T24_String, Field_NoInput, "")
    CALL Table.addField("RESERVED.7", T24_String, Field_NoInput, "")
    CALL Table.addField("RESERVED.6", T24_String, Field_NoInput, "")
    CALL Table.addField("RESERVED.5", T24_String, Field_NoInput, "")
    CALL Table.addField("RESERVED.4", T24_String, Field_NoInput, "")
    CALL Table.addField("RESERVED.3", T24_String, Field_NoInput, "")
    CALL Table.addField("RESERVED.2", T24_String, Field_NoInput, "")
    CALL Table.addField("RESERVED.1", T24_String, Field_NoInput, "")

*-----------------------------------------------------------------------------
    CALL Table.addField("XX.LOCAL.REF", T24_String, "" , "")
    CALL Table.addField("XX.OVERRIDE", T24_String, Field_NoInput, "")
    CALL Table.setAuditPosition         ;* Poputale audit information

    RETURN
*-----------------------------------------------------------------------------
END





