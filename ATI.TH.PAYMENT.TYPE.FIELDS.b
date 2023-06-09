*-----------------------------------------------------------------------------
* <Rating>-1</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.TH.PAYMENT.TYPE.FIELDS
*-----------------------------------------------------------------------------
* Create by   : Dwi K
* Create Date : 20180808
* Description : Template table ATI.TH.PAYMENT.TYPE
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date         :
* Modified by  :
* Description  :
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes

*-----------------------------------------------------------------------------

    ID.CHECKFILE = "" ; ID.CONCATFILE = ""
    ID.F = "@ID" ; ID.N = "10" ; ID.T = "A"

*-----------------------------------------------------------------------------

    CALL Table.addFieldDefinition("CODE", "10", "A", "")
	CALL Table.addFieldDefinition("DESCRIPTION", "65", "A", "")

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
    CALL Table.addField("XX.STMT.NO", T24_String, Field_NoInput , "" )
    CALL Table.addField("XX.OVERRIDE", T24_String, Field_NoInput, "")
    CALL Table.setAuditPosition         ;* Poputale audit information)

    RETURN
*-----------------------------------------------------------------------------
END