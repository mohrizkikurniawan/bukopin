
   SUBROUTINE ATI.TH.RIZ.FIELDS
*-----------------------------------------------------------------------------
* Developer Name     : Moh. Rizki Kurniawan
* Development Date   : 20190918
* Description        : Table Training
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date            Modified by                Description
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
   
	$INSERT I_COMMON
    $INSERT I_EQUATE
	$INSERT I_DataTypes
*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------
 
	GOSUB INIT
    GOSUB PROCESS

    RETURN
*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
    

	RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
	ID.CHECKFILE = "" ; ID.CONCATFILE=""
	ID.F= '@ID' ; ID.N='30'; ID.T="A"
	
	CALL Table.addFieldDefinition("CUSTOMER.ID", "30", "A", "")
	CALL Field.setCheckFile("CUSTOMER")
	CALL Table.addFieldDefinition("PROJECT.ID", "10", "A", "")
	CALL Table.addFieldDefinition("LIMIT.REF", "25", "A", "")
	CALL Field.setCheckFile("LIMIT")
	CALL Table.addFieldDefinition("XX<VALUE.DATE","11",'D',"")
	CALL Table.addFieldDefinition("XX-TRANSACTION.CODE","3",'A',"")
	CALL Field.setCheckFile("TRANSACTION")
	CALL Table.addFieldDefinition("XX-DESCRIPTION","35",'A',"")
	CALL Table.addFieldDefinition("XX-CURRENCY","3",'A',"")
	CALL Field.setCheckFile("CURRENCY")
	CALL Table.addFieldDefinition("XX-AMOUNT","19",'AMT',"")
	CALL Table.addFieldDefinition("XX>STMT.ID","90",'A',"")
	CALL Field.setCheckFile("STMT.ENTRY")
	CALL Table.addAmountField("DEBIT.AMT", "CURRENCY", Field_AllowNegative, "")
	CALL Table.addAmountField("CREDIT.AMT", "CURRENCY", "", "")
	CALL Table.addVirtualTableField("MOOD", "CR.MOOD", "", "")


*-----------------------------------------------------------------------------
    
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
    CALL Table.addField("XX.LOCAL.REF", T24_String, "", "")
	CALL Table.addField("XX.STMT.NO", T24_String, Field_NoInput, "")
    CALL Table.addField("XX.OVERRIDE", T24_String, Field_NoInput, "")
    CALL Table.setAuditPosition         ;* Poputale audit information

	RETURN
*-----------------------------------------------------------------------------
END




