*-----------------------------------------------------------------------------
* <Rating>-13</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.TH.SMS.MAPPING.FIELDS
*-----------------------------------------------------------------------------
* Developer Name     : Dwi K
* Development Date   : 20180406
* Description        : Table SMS Mapping
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date            Modified by                Description
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes

*-----------------------------------------------------------------------------
    ID.CHECKFILE = "" ; ID.CONCATFILE = ""
    ID.F = "@ID" ; ID.N ="25" ; ID.T = "A"

*-----------------------------------------------------------------------------
    CALL Table.addFieldDefinition("DESCRIPTION", "100.1", "A", "")
    CALL Table.addFieldDefinition("APPLICATION", "40.1", "ANY", "")
    CALL Field.setCheckFile("FILE.CONTROL")
    CALL Table.addField("BODY", T24_TextWide, "", "")
    CALL Table.addFieldDefinition("XX<VARIABLE", "15", "A", "")
    CALL Table.addFieldDefinition("XX-FIELD.NAME", "35", "A", "")
    CALL Table.addField("XX-RESERVED.20", T24_String, Field_NoInput, "")
    CALL Table.addField("XX-RESERVED.19", T24_String, Field_NoInput, "")
    CALL Table.addField("XX-RESERVED.18", T24_String, Field_NoInput, "")
    CALL Table.addField("XX-RESERVED.17", T24_String, Field_NoInput, "")
    CALL Table.addField("XX-RESERVED.16", T24_String, Field_NoInput, "")
    CALL Table.addFieldDefinition("XX-XX<FUNCTION", "20", FM:"COMMON_CONCATE_DROUND_FIELD_FIXED_FMT_ICONV_FIELD.VALUE_LINK_OCONV_PRG_SUBSTRINGS_TRIM" , "")
    CALL Table.addFieldDefinition("XX-XX-ATTRIBUTE", "35", "ANY", "")
    CALL Table.addField("XX-XX-RESERVED.15", T24_String, Field_NoInput, "")
    CALL Table.addField("XX-XX-RESERVED.14", T24_String, Field_NoInput, "")
    CALL Table.addField("XX-XX-RESERVED.13", T24_String, Field_NoInput, "")
    CALL Table.addField("XX-XX-RESERVED.12", T24_String, Field_NoInput, "")
    CALL Table.addField("XX>XX>RESERVED.11", T24_String, Field_NoInput, "")
	CALL Table.addFieldDefinition("FROM", "35.1", "A", "")

*-----------------------------------------------------------------------------
*    CALL Table.addField("RESERVED.10", T24_String, Field_NoInput, "")
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





