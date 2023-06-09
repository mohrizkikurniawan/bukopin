*-----------------------------------------------------------------------------
* <Rating>-1</Rating>
* 13:55:19 26 JUN 2015 
* WIN-KVUAVRB60BE/R14 
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.TH.SKN.PROVINCE.CODE.FIELDS
*-----------------------------------------------------------------------------
* Developer Name        : ATI-YUDISTIA ADNAN
* Development Date      : 01 DECEMBER 2015
* Description           : Table Parameter SKN Province code
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date        :
* Modified by :
* Description :
* No Log      :
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*-----------------------------------------------------------------------------
    ID.CHECKFILE = "" ; ID.CONCATFILE = ""
    ID.F = "" ; ID.N ="35" ; ID.T = "A"

    CALL Table.addFieldDefinition("DESCRIPTION", "50", "A","")

*-----------------------------------------------------------------------------
    CALL Table.addField("RESERVED.5", T24_String, Field_NoInput, "")
    CALL Table.addField("RESERVED.4", T24_String, Field_NoInput, "")
    CALL Table.addField("RESERVED.3", T24_String, Field_NoInput, "")
    CALL Table.addField("RESERVED.2", T24_String, Field_NoInput, "")
    CALL Table.addField("RESERVED.1", T24_String, Field_NoInput, "")
    CALL Table.addField("XX.LOCAL.REF", T24_String, "", "")
    CALL Table.addField("XX.STMT.NO", T24_String, Field_NoInput, "")
    CALL Table.addField("XX.OVERRIDE", T24_String, Field_NoInput, "")
*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition         ;* Poputale audit information
*-----------------------------------------------------------------------------
    RETURN
*-----------------------------------------------------------------------------
END



