*-----------------------------------------------------------------------------
* <Rating>-13</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.TT.AGENT.MONTHLY.TXN.ACT.FIELDS
*-----------------------------------------------------------------------------
* Developer Name     : Dwi K
* Development Date   : 20180416
* Description        : Table Agent Activity Monthly
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
    ID.F = "@ID" ; ID.N ="35" ; ID.T = "ANY"

*-----------------------------------------------------------------------------
    CALL Table.addFieldDefinition("XX<DATE", "11", "D", "")
	CALL Table.addFieldDefinition("XX-XX<TRANS.DB", "4", "", "")
	CALL Field.setCheckFile("FT.TXN.TYPE.CONDITION")
    CALL Table.addFieldDefinition("XX-XX-REF.ID.DB", "16", "A", "")
	CALL Table.addFieldDefinition("XX-XX-ACCOUNT.DB", "16", "", "")
	CALL Table.addFieldDefinition("XX-XX>AMOUNT.DB", "29", "AMT", "")
	CALL Table.addFieldDefinition("XX-XX<TRANS.CR", "4", "", "")
	CALL Field.setCheckFile("FT.TXN.TYPE.CONDITION")
    CALL Table.addFieldDefinition("XX-XX-REF.ID.CR", "16", "A", "")
	CALL Table.addFieldDefinition("XX-XX-ACCOUNT.CR", "16", "", "")
	CALL Table.addFieldDefinition("XX>XX>AMOUNT.CR", "29", "AMT", "")
	CALL Table.addFieldDefinition("CTR.TRANS.DB", "4", "", "")
	CALL Table.addFieldDefinition("CTR.TRANS.CB", "4", "", "")

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





