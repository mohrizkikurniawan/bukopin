*-----------------------------------------------------------------------------
* <Rating>-1</Rating>
* 11:14:51 27 JUL 2015 
* WIN-KVUAVRB60BE/R14 
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.TH.STO.RETRY.FIELDS
*-----------------------------------------------------------------------------
* Created by   : ATI Dhio Faizar Wahyudi
* Created Date : 20171205
* Description  : Template table of STO retry
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
    ID.F = "@ID" ; ID.N = "25" ; ID.T = "A"

*-----------------------------------------------------------------------------

    CALL Table.addFieldDefinition("XX<DATE", "11", "D", "")
	CALL Table.addFieldDefinition("XX-AMOUNT", "25", "AMT", "")
	CALL Table.addFieldDefinition("XX-RETRY.CNT", "1", "", "")
	CALL Table.addFieldDefinition("XX-XX.FT.ID", "12", "A", "")
	CALL Table.addFieldDefinition("XX>STATUS", "10", FM:"ERROR_SUCCESS", "")
	CALL Table.addFieldDefinition("NEXT.PERIODE", "11", "D", "")
	    
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


