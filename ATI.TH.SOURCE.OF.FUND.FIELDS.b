*-----------------------------------------------------------------------------
* <Rating>-1</Rating>
* 13:55:19 26 JUN 2015 
* WIN-KVUAVRB60BE/R14 
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.TH.SOURCE.OF.FUND.FIELDS
*-----------------------------------------------------------------------------
* Create by   : Novi Leo
* Create Date : 20151130
* Description : Template table of Source of Fund
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
    ID.F = '@ID' ; ID.N ='2' ; ID.T = "A"

*-----------------------------------------------------------------------------

    CALL Table.addFieldDefinition("DESCRIPTION", "35", "A", "")
    CALL Table.addFieldDefinition("CUST.TYPE", "3", FM:"C_R_ALL", "")

*-----------------------------------------------------------------------------

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

