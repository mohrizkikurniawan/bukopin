*-----------------------------------------------------------------------------
* <Rating>-1</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.TH.PURGE.PARAM.FIELDS
*-----------------------------------------------------------------------------
* Developer Name        : ATI-YUDISTIA ADNAN
* Development Date      : 02 DECEMBER 2015
* Description           : Table Parameer Purging
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
    ID.CHECKFILE = "FILE.CONTROL" ; ID.CONCATFILE = ""
    ID.F = "@ID" ; ID.N ="40" ; ID.T = "A"

    CALL Table.addFieldDefinition("XX.DESCRIPTION", "65", "A","")
    CALL Table.addFieldDefinition("XX<DESC.SEL", "65", "A","")
    CALL Table.addFieldDefinition("XX-FIELD.SEL", "35", "A","")
    CALL Table.addFieldDefinition("XX-OPERATION.SEL", "6", "":FM:"EQ_LT_GT_LE_GE_LIKE_UNLIKE_NE","")
    CALL Table.addFieldDefinition("XX-VALUE.SEL", "35", "A","")
    CALL Table.addFieldDefinition("XX>COMB.SEL", "3", "":FM:"AND_OR","")
    CALL Table.addFieldDefinition("ROUTINE.SEL", "35", "A","")
    CALL Table.addFieldDefinition("ARCHIVE.REC", "8.1", "":FM:"DELETE_ARCHIVE_HISTORY","")

*-----------------------------------------------------------------------------
    CALL Table.addField("RESERVED.5", T24_String, Field_NoInput, "")
    CALL Table.addField("RESERVED.4", T24_String, Field_NoInput, "")
    CALL Table.addField("RESERVED.3", T24_String, Field_NoInput, "")
    CALL Table.addField("RESERVED.2", T24_String, Field_NoInput, "")
    CALL Table.addField("RESERVED.1", T24_String, Field_NoInput, "")
    CALL Table.addField("XX.LOCAL.REF", T24_String, "" , "")
    CALL Table.addField("XX.OVERRIDE", T24_String, Field_NoInput, "")
*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition         ;* Poputale audit information
*-----------------------------------------------------------------------------
    RETURN
*-----------------------------------------------------------------------------
END


















