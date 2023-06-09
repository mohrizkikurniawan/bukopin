*-----------------------------------------------------------------------------
* <Rating>-1</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.TH.PLN.TRANS.RECEIPT.FIELDS
*-----------------------------------------------------------------------------
* Developer Name     : ATI Juan Felix
* Development Date   : 20171031
* Description        : Template Table ATI.TH.PLN.TRANS.RECEIPT
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
    ID.F = "@ID" ; ID.N ="15" ; ID.T = "A"

*-----------------------------------------------------------------------------
    CALL Table.addFieldDefinition("TYPE", "20.1", "":FM:"PAYMENT_PURCHASE", "")
    CALL Table.addFieldDefinition("CUSTOMER", "35", "A":FM:FM:"NOINPUT", "")
    CALL Field.setCheckFile("CUSTOMER")
    CALL Table.addFieldDefinition("ACCOUNT", "19.1", "A", "")
    CALL Field.setCheckFile("ACCOUNT")
    CALL Table.addFieldDefinition("EMAIL", "65", "ANY":FM:FM:"NOINPUT", "")
    CALL Table.addFieldDefinition("METER.NUM", "15", "A", "")
    CALL Table.addFieldDefinition("ID.PEL", "15", "A", "")
    CALL Table.addFieldDefinition("NAME", "35", "A", "")
    CALL Table.addFieldDefinition("SEGMENT", "5", "A", "")
    CALL Table.addFieldDefinition("POWER.CATEG", "10", "A", "")
    CALL Table.addFieldDefinition("XX.BILL.PERIOD", "65", "A", "")
    CALL Table.addFieldDefinition("BILL.OUTS", "65", "A", "")
    CALL Table.addFieldDefinition("STAND.METER", "25", "A", "")
    CALL Table.addFieldDefinition("KWH", "10", "A", "")
    CALL Table.addFieldDefinition("TOKEN", "25", "A", "")
    CALL Table.addFieldDefinition("NO.REF", "35", "A", "")
    CALL Table.addFieldDefinition("AMOUNT", "25", "AMT", "")
    CALL Table.addFieldDefinition("STAMP.DUTY", "25", "AMT", "")
    CALL Table.addFieldDefinition("VAT", "25", "AMT", "")
    CALL Table.addFieldDefinition("PUBLIC.TAX", "25", "AMT", "")
    CALL Table.addFieldDefinition("ADMIN.FEE", "25", "AMT", "")
    CALL Table.addFieldDefinition("TOTAL.AMOUNT", "25", "AMT", "")
    CALL Table.addFieldDefinition("CUST.PAYABLE", "25", "AMT", "")
    CALL Table.addField("INFO", T24_TextWide, "", "")
    CALL Table.addFieldDefinition("PDF.MAPPING", "35", "A", "")
    CALL Field.setCheckFile("ATI.TH.HTML2PDF.MAPPING")
    CALL Table.addFieldDefinition("PDF.RECEIPT", "35", "A", "")
    CALL Table.addFieldDefinition("VALUE.DATE", "11.1", "D", "")
    CALL Table.addFieldDefinition("FT.ID", "25", "A", "")
    CALL Table.addFieldDefinition("DATE.TIME.CREATE", "25", "A":FM:FM:"NOINPUT", "")

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
