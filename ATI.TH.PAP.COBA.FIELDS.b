
   SUBROUTINE ATI.TH.PAP.COBA.FIELDS
*-----------------------------------------------------------------------------
* Developer Name     : Moh. Rizki Kurniawan
* Development Date   : 20190920
* Description        : Table Premi Asuransi Param
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
	CALL Table.addFieldDefinition("ELIGIBILITY", "2", "N", "")
	CALL Table.addVirtualTableField("CALCULATION.PERIOD", "CL.PERIOD", "", "")
	CALL Table.addFieldDefinition("INDICATOR.CALCULATION", "10", "" :FM: "Fixed_Calculated", "")
	CALL Table.addFieldDefinition("AMOUNT","19",'AMT',"")
	CALL Table.addFieldDefinition("RATE.PREMI", "5", "R", "")
	CALL Table.addVirtualTableField("BALANCE.SOURCE", "BL.SOURCE", "", "")
	CALL Table.addFieldDefinition("SETTLEMENT.FREQUENCY", "15", "FQU", "")
	CALL Table.addFieldDefinition("NEXT.RUN.DATE","8",'D',"")
	CALL Table.addFieldDefinition("LAST.RUN.DATE","8",'D',"")

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
    CALL Table.addField("XX.STMT.NO", T24_String, Field_NoInput , "" )
    CALL Table.addField("XX.OVERRIDE", T24_String, Field_NoInput, "")
    CALL Table.setAuditPosition         ;* Poputale audit information
	
	RETURN
*-----------------------------------------------------------------------------
END




