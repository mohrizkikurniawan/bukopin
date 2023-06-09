*-----------------------------------------------------------------------------
* <Rating>-1</Rating>
* 11:14:51 27 JUL 2015 
* WIN-KVUAVRB60BE/R14 
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.TL.DAILY.BAL.FIELDS
*-----------------------------------------------------------------------------
* Create by   : Novi Leo
* Create Date : 20160127
* Description : Template table of Daily Balance
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
    ID.F = "@ID" ; ID.N = "35" ; ID.T = "A"

*-----------------------------------------------------------------------------

    CALL Table.addField("XX<DATE", "2", "", "")
    CALL Table.addField("XX>BALANCE", "10", "AMT", "")

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


