*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.TL.IMB.ACCRUAL.FIELDS
*-----------------------------------------------------------------------------
* Developer Name      : Novi Leo
* Development Date    : 20170518
* Description         : Routine table ATI.TL.IMB.ACCRUAL
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date               : ATI Julian Gerry
* Modified by        : 21 July 2017
* Description        : Update proses for termin ist grp prod
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes

*-----------------------------------------------------------------------------

    ID.CHECKFILE = "" ; ID.CONCATFILE = ""
    ID.F = "@ID" ; ID.N ="20" ; ID.T = "A"

*-----------------------------------------------------------------------------

    CALL Table.addField("CUSTOMER", T24_Customer, "" , "")
    CALL Table.addFieldDefinition("CURRENCY", "3", "A", "")
    CALL Field.setCheckFile("CURRENCY")
    CALL Table.addFieldDefinition("DB.ACCT", "16", "A", "")
    CALL Table.addFieldDefinition("CR.ACCT", "16", "A", "")
    CALL Table.addFieldDefinition("DB.TXN.CODE", "3", "", "")
    CALL Table.addFieldDefinition("CR.TXN.CODE", "3", "", "")
    CALL Table.addFieldDefinition("START.DATE", "11", "D", "")
    CALL Table.addFieldDefinition("MATURE.DATE", "11", "D", "")
    CALL Table.addFieldDefinition("INIT.AMT", "19", "AMT", "")
    CALL Table.addFieldDefinition("DEPR.OS", "19", "AMT", "")
    CALL Table.addFieldDefinition("SCHD.AMT", "19", "AMT", "")
    CALL Table.addFieldDefinition("ACCR.TO.DATE", "19", "AMT", "")
    CALL Table.addFieldDefinition("NEXT.POST.DT", "11", "D", "")
    CALL Table.addFieldDefinition("FREQ.POST", "5", "A", "")
    CALL Table.addField("ACCRUAL.PARAM", T24_String, "", "")
    CALL Field.setCheckFile("EB.ACCRUAL.PARAM")
    CALL Table.addFieldDefinition("SCHD.POST", "1", "":FM:"Y", "")
    CALL Table.addFieldDefinition("CO.CODE", "10", "A", "")
    CALL Field.setCheckFile("COMPANY")
    CALL Table.addFieldDefinition("XX<TERMIN.DATE", "11", "D", "")
    CALL Table.addFieldDefinition("XX>TERMIN.AMT", "19", "AMT", "")

*-----------------------------------------------------------------------------

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

    RETURN
*-----------------------------------------------------------------------------
END

