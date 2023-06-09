*-----------------------------------------------------------------------------
* <Rating>-13</Rating>
* 14:31:20 02 AUG 2015 * 13:55:19 26 JUN 2015
* WIN-KVUAVRB60BE/R14 * WIN-KVUAVRB60BE/R14
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.TT.ENT.TODAY
*-----------------------------------------------------------------------------
* Developer Name        : Dwi K
* Development Date      : 20160202
* Description           : Routine to description table ATI.TT.ENT.TODAY
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_Table

*-----------------------------------------------------------------------------
    Table.name              = 'ATI.TT.ENT.TODAY'  ;* Full application name including product prefix
    Table.title             = 'ENT Today'         ;* Screen title
    Table.stereotype        = 'T'       ;* H, U, L, W or T
    Table.product           = 'ST'      ;* Must be on EB.PRODUCT
    Table.subProduct        = ''        ;* Must be on EB.SUB.PRODUCT
    Table.classification    = 'INT'     ;* As per FILE.CONTROL
    Table.systemClearFile   = 'N'       ;* As per FILE.CONTROL
    Table.relatedFiles      = ''        ;* As per FILE.CONTROL
    Table.isPostClosingFile = ''        ;* As per FILE.CONTROL
    Table.equatePrefix      = 'ETD'     ;* Use to create I_F.EB.LOG.PARAMETER
*-----------------------------------------------------------------------------
    Table.idPrefix          = ''        ;* Used by EB.FORMAT.ID if set
    Table.blockedFunctions  = ''        ;* Space delimeted list of blocked functions
    Table.trigger           = ''        ;* Trigger field used for OPERATION style fields
*-----------------------------------------------------------------------------
    RETURN
END













