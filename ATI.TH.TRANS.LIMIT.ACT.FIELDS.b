*-----------------------------------------------------------------------------
    SUBROUTINE ATI.TH.TRANS.LIMIT.ACT.FIELDS
*-----------------------------------------------------------------------------
* Developer Name     : Dhio Faizar Wahyudi
* Development Date   : 20171011
* Description        : Table of Transfer Online Transaction
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
    ID.F = "@ID" ; ID.N ="70" ; ID.T = "A"

*-----------------------------------------------------------------------------
	CALL Table.addFieldDefinition("TOTAL.AMOUNT", "25", "AMT", "")
	CALL Table.addFieldDefinition("VALUE.DATE", "11", "D", "")
	CALL Table.addFieldDefinition("ACCOUNT", "19", "POSANT", "")
	CALL Field.setCheckFile("ACCOUNT")
	CALL Table.addFieldDefinition("GROUP.ID", "35", "A", "")
	CALL Table.addFieldDefinition("XX<TRANS.ID", "5", "A", "")
	CALL Table.addFieldDefinition("XX-TRANS.TYPE", "12", "A", "")
	CALL Table.addFieldDefinition("XX-TRANS.AMT", "25", "AMT", "")
	CALL Table.addField("XX-RESERVED.10", T24_String, Field_NoInput, "")
	CALL Table.addField("XX-RESERVED.9", T24_String, Field_NoInput, "")
	CALL Table.addField("XX>RESERVED.8", T24_String, Field_NoInput, "")

*-----------------------------------------------------------------------------
    
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





