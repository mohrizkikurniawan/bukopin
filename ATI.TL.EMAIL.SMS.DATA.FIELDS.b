*-----------------------------------------------------------------------------
* <Rating>-13</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.TL.EMAIL.SMS.DATA.FIELDS
*-----------------------------------------------------------------------------
* Developer Name     : ATI Juan Felix
* Development Date   : 20170703
* Description        : Table Email SMS Data
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
    ID.F = "@ID" ; ID.N ="35" ; ID.T = "A"

*-----------------------------------------------------------------------------
    CALL Table.addFieldDefinition("EMAIL.SMS", "10", FM:"EMAIL_SMS", "")
    CALL Table.addFieldDefinition("MAPPING", "35", "A", "")
    CALL Table.addFieldDefinition("VALUE.DATE", "11", "D", "")
    CALL Table.addFieldDefinition("STATUS", "7", FM:"SUCCESS_ERROR", "A", "")
    CALL Table.addFieldDefinition("CUSTOMER", "10", "", "")
	CALL Field.setCheckFile("CUSTOMER")
    CALL Table.addFieldDefinition("EMAIL", "35", "ANY", "")
    CALL Table.addFieldDefinition("MOBILE.NO", "20", "ANY", "")
    CALL Table.addFieldDefinition("XML.MESSAGE", "100", "ANY", "")   
    CALL Table.addFieldDefinition("RESPONSE", "100", "ANY", "")
    CALL Table.addFieldDefinition("DATE.TIME", "25", "", "")
    CALL Table.addFieldDefinition("DATE.TIME.SEND", "25", "", "")

    RETURN
*-----------------------------------------------------------------------------
END





