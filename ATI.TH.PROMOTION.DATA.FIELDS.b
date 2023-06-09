*-----------------------------------------------------------------------------
* <Rating>-13</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.TH.PROMOTION.DATA.FIELDS
*-----------------------------------------------------------------------------
* Developer Name     : ATI Dhio Faizar Wahyudi
* Development Date   : 20180102
* Description        : Table Promotion Data
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date            Modified by                Description
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes

*-----------------------------------------------------------------------------
    ID.CHECKFILE = "" ; ID.CONCATFILE = ""
    ID.F = "@ID" ; ID.N ="180" ; ID.T = "A"

*-----------------------------------------------------------------------------
    CALL Table.addFieldDefinition("ID.1", "35", "A", "")
    CALL Table.addFieldDefinition("ID.2", "35", "A", "")
    CALL Table.addFieldDefinition("ID.3", "35", "A", "")
    CALL Table.addFieldDefinition("ID.4", "35", "A", "")
    CALL Table.addFieldDefinition("ID.5", "35", "A", "")
	CALL Table.addFieldDefinition("XX<VALUE.DATE", "11", "D", "")
	CALL Table.addFieldDefinition("XX-APPLICATION.SOURCE", "40", "A", "")
	CALL Field.setCheckFile("FILE.CONTROL")
	CALL Table.addFieldDefinition("XX-ID.SOURCE", "35", "A", "")
	CALL Table.addFieldDefinition("XX-APPLICATION.RESULT", "40", "A", "")
	CALL Field.setCheckFile("FILE.CONTROL")
	CALL Table.addFieldDefinition("XX-ID.RESULT", "35", "A", "")
	CALL Table.addFieldDefinition("XX-STATUS.RESULT", "10", "":FM:"SUCCESS_ERROR", "")
	CALL Table.addFieldDefinition("XX-MSG.IN.RESULT", "500", "ANY", "")
	CALL Table.addFieldDefinition("XX-XX.MSG.OUT.RESULT", "500", "ANY", "")
	CALL Table.addFieldDefinition("XX>DATE.TIME.TRANS", "35", "A", "")
	CALL Table.addFieldDefinition("TOTAL.AMT.TXN", "25", "AMT", "")
	
*-----------------------------------------------------------------------------

*    CALL Table.addField("RESERVED.20", T24_String, Field_NoInput, "")
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
