*-----------------------------------------------------------------------------
* <Rating>-1</Rating>
* 17:02:46 10 APR 2017 
* CBS-APP1-JKT/t24poc 
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.TH.WTD.FT.FIELDS
*-----------------------------------------------------------------------------
* Developer Name     : Dwi K
* Development Date   : 20170605
* Description        : Table FT Withdrawal ATM
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
    ID.F = "@ID" ; ID.N ="65" ; ID.T = "ANY"

*-----------------------------------------------------------------------------

    CALL Table.addFieldDefinition("CUSTOMER", "10", "", "")
	CALL Field.setCheckFile("CUSTOMER")
	CALL Table.addFieldDefinition("STATUS", "9", FM:"INPUT_AUTHORISE_ERROR", "")
    CALL Table.addFieldDefinition("MOBILE.NO", "20", "ANY", "")
    CALL Table.addFieldDefinition("DEBIT.ACCOUNT", "19", "", "")
	CALL Field.setCheckFile("ACCOUNT")
    CALL Table.addFieldDefinition("AMOUNT", "25", "", "")
	CALL Table.addFieldDefinition("FT.ID", "25", "A", "")
	CALL Table.addFieldDefinition("VALUE.DATE", "11", "D", "")
	CALL Table.addFieldDefinition("EXP.DATE.TIME", "12", "", "")
	CALL Table.addFieldDefinition("DENOMINATION", "7", "", "")
*-----------------------------------------------------------------------------
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





