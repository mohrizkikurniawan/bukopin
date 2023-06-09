*-----------------------------------------------------------------------------
* <Rating>-13</Rating>
* 13:55:19 26 JUN 2015 
* WIN-KVUAVRB60BE/R14 
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.TH.SOURCE.OF.FUND
*-----------------------------------------------------------------------------
* Developer Name     : Novi Leo
* Development Date   : 20151130
* Description        : Template Table of Source of Fund
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date               :
* Modified by        :
* Description        :
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_Table

*-----------------------------------------------------------------------------

    Table.name              = 'ATI.TH.SOURCE.OF.FUND'       ;* Full application name including product prefix
    Table.title             = 'Source of Fund'    ;* Screen title
    Table.stereotype        = 'H'       ;* H, U, L, W or T
    Table.product           = 'ST'      ;* Must be on EB.PRODUCT
    Table.subProduct        = ''        ;* Must be on EB.SUB.PRODUCT
    Table.classification    = 'INT'     ;* As per FILE.CONTROL
    Table.systemClearFile   = 'N'       ;* As per FILE.CONTROL
    Table.relatedFiles      = ''        ;* As per FILE.CONTROL
    Table.isPostClosingFile = ''        ;* As per FILE.CONTROL
    Table.equatePrefix      = 'SOF'     ;* Use to create I_F.EB.LOG.PARAMETER
*-----------------------------------------------------------------------------
    Table.idPrefix          = ''        ;* Used by EB.FORMAT.ID if set
    Table.blockedFunctions  = ''        ;* Space delimeted list of blocked functions
    Table.trigger           = ''        ;* Trigger field used for OPERATION style fields
*-----------------------------------------------------------------------------
    RETURN
END

