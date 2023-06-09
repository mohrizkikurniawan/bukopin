*-----------------------------------------------------------------------------
    SUBROUTINE ATI.TH.USER.LEGACY.FIELDS
*-----------------------------------------------------------------------------
* Developer Name     : Dhio Faizar Wahyudi
* Development Date   : 20170727
* Description        : Table USER LEGACY
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
    ID.F = "@ID" ; ID.N ="16" ; ID.T = "A"

*-----------------------------------------------------------------------------
    CALL Table.addFieldDefinition("NAME", "65", "A", "")
    CALL Table.addFieldDefinition("COMPANY", "20", "A", "")

*-----------------------------------------------------------------------------
	CALL Table.addField("RESERVED.20", T24_String, Field_NoInput, "")
    CALL Table.addField("RESERVED.19", T24_String, Field_NoInput, "")
    CALL Table.addField("RESERVED.18", T24_String, Field_NoInput, "")
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





