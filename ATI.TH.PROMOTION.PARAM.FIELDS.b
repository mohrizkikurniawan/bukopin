*-----------------------------------------------------------------------------
* <Rating>-13</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.TH.PROMOTION.PARAM.FIELDS
*-----------------------------------------------------------------------------
* Developer Name     : ATI Dhio Faizar Wahyudi
* Development Date   : 20171227
* Description        : Table Parameter Promotion
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
    ID.F = "@ID" ; ID.N ="65" ; ID.T = "A"

*-----------------------------------------------------------------------------
    CALL Table.addFieldDefinition("DESCRIPTION", "100", "A", "")
	CALL Table.addFieldDefinition("START.DATE", "11", "D", "")
	CALL Table.addFieldDefinition("END.DATE", "11", "D", "")
	CALL Table.addFieldDefinition("EVERY.DATE", "2", "", "")
	CALL Table.addFieldDefinition("EVERY.DAY", "9", "":FM:"SUNDAY_MONDAY_TUESDAY_WEDNESDAY_THURSDAY_FRIDAY_SATURDAY", "")
	CALL Table.addFieldDefinition("START.TIME", "4", "A", "")
	CALL Table.addFieldDefinition("END.TIME", "4", "A", "")
	CALL Table.addFieldDefinition("APPLICATION.SRC", "40", "A", "")
	CALL Field.setCheckFile("FILE.CONTROL")
	CALL Table.addFieldDefinition("XX<FIELD.COND", "35", "A", "")
	CALL Table.addFieldDefinition("XX-OPERATION.COND", "2", "":FM:"EQ_NE_GT_LT_GE_LE_RG_NR_LK_UL", "")
	CALL Table.addFieldDefinition("XX-VALUE.COND", "35", "A", "")
	CALL Table.addFieldDefinition("XX>REL.NEXT.COND", "3", "":FM:"AND_OR", "")
	CALL Table.addField("RESERVED.40", T24_String, Field_NoInput, "")
    CALL Table.addField("RESERVED.39", T24_String, Field_NoInput, "")
    CALL Table.addField("RESERVED.38", T24_String, Field_NoInput, "")
	CALL Table.addField("RESERVED.37", T24_String, Field_NoInput, "")
    CALL Table.addField("RESERVED.36", T24_String, Field_NoInput, "")
	CALL Table.addFieldDefinition("XX.FIELD.CTR.SRC", "35", "A", "")
	CALL Table.addFieldDefinition("MIN.CTR.TRANS", "5", "", "")
	CALL Table.addFieldDefinition("MAX.CTR.PER.SRC", "5", "", "")
	CALL Table.addFieldDefinition("MAX.CTR", "5", "", "")
	CALL Table.addFieldDefinition("MIN.AMT.TRANS", "25", "", "")
	CALL Table.addField("RESERVED.35", T24_String, Field_NoInput, "")
    CALL Table.addField("RESERVED.34", T24_String, Field_NoInput, "")
    CALL Table.addField("RESERVED.33", T24_String, Field_NoInput, "")
	CALL Table.addField("RESERVED.32", T24_String, Field_NoInput, "")
    CALL Table.addField("RESERVED.31", T24_String, Field_NoInput, "")
	CALL Table.addFieldDefinition("XX<VARIABLE", "35", "A", "")
	CALL Table.addFieldDefinition("XX-FIELD.SRC", "35", "A", "")
	CALL Table.addFieldDefinition("XX-XX<FUNCTION", "15", "":FM:"CALC_COMMON_CONCATE_DROUND_FIELD_FIELD.VALUE_FIXED_FMT_ICONV_IF_LINK_OCONV_OPTION_PRG_SUBSTRING_TRIM", "")
	CALL Table.addFieldDefinition("XX>XX>ATTRIBUTE", "65", "A", "")
	CALL Table.addField("RESERVED.30", T24_String, Field_NoInput, "")
    CALL Table.addField("RESERVED.29", T24_String, Field_NoInput, "")
    CALL Table.addField("RESERVED.28", T24_String, Field_NoInput, "")
	CALL Table.addField("RESERVED.27", T24_String, Field_NoInput, "")
    CALL Table.addField("RESERVED.26", T24_String, Field_NoInput, "")
	CALL Table.addFieldDefinition("APPLICATION.RESULT", "40", "A", "")
	CALL Field.setCheckFile("FILE.CONTROL")
	CALL Table.addFieldDefinition("VERSION.RESULT", "65", "A", "")
	CALL Field.setCheckFile("VERSION")
	CALL Table.addFieldDefinition("FUNCTION.RESULT", "1", "":FM:"I_A_R_D", "")
	CALL Table.addFieldDefinition("PROCESS.RESULT", "8", "":FM:"PROCESS_VALIDATE", "")
	CALL Table.addFieldDefinition("GTS.MODE.RESULT", "1", "":FM:"1_2_3_4", "")
	CALL Table.addFieldDefinition("NO.OF.AUTH.RESULT", "1", "":FM:"0_1_2", "")
	CALL Table.addFieldDefinition("TRANSACTION.ID.RESULT", "65", "A", "")
	CALL Table.addFieldDefinition("COMPANY.RESULT", "11", "A", "")
	CALL Field.setCheckFile("COMPANY")
	CALL Table.addFieldDefinition("XX<FIELD.RESULT", "35", "A", "")
	CALL Table.addFieldDefinition("XX>FIELD.VALUE.RESULT", "35", "A", "")
	CALL Table.addField("RESERVED.25", T24_String, Field_NoInput, "")
    CALL Table.addField("RESERVED.24", T24_String, Field_NoInput, "")
    CALL Table.addField("RESERVED.23", T24_String, Field_NoInput, "")
	CALL Table.addField("RESERVED.22", T24_String, Field_NoInput, "")
    CALL Table.addField("RESERVED.21", T24_String, Field_NoInput, "")
	CALL Table.addFieldDefinition("TOTAL.TRANS", "5", "", "")
	CALL Table.addFieldDefinition("PROMO.TYPE", "10", "":FM:"CASHBACK_DISCOUNT", "")
	
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
