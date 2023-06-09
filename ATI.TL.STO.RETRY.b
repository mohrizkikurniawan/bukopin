*-----------------------------------------------------------------------------
* <Rating>-13</Rating>
* 11:14:19 27 JUL 2015 
* WIN-KVUAVRB60BE/R14 
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.TL.STO.RETRY
*-----------------------------------------------------------------------------
* Created by   : ATI Julian Gerry
* Created Date : 20171031
* Description  : Template table of STO retry
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

    Table.name              = 'ATI.TL.STO.RETRY'  ;* Full application name including product prefix
    Table.title             = 'STO RETRY'     ;* Screen title
    Table.stereotype        = 'L'       ;* H, U, L, W or T
    Table.product           = 'EB'      ;* Must be on EB.PRODUCT
    Table.subProduct        = ''        ;* Must be on EB.SUB.PRODUCT
    Table.classification    = 'INT'     ;* As per FILE.CONTROL
    Table.systemClearFile   = 'N'       ;* As per FILE.CONTROL
    Table.relatedFiles      = ''        ;* As per FILE.CONTROL
    Table.isPostClosingFile = ''        ;* As per FILE.CONTROL
    Table.equatePrefix      = 'TL.STO.RET'    ;* Use to create I_F.EB.LOG.PARAMETER
*-----------------------------------------------------------------------------
    Table.idPrefix          = ''        ;* Used by EB.FORMAT.ID if set
    Table.blockedFunctions  = ''        ;* Space delimeted list of blocked functions
    Table.trigger           = ''        ;* Trigger field used for OPERATION style fields
*-----------------------------------------------------------------------------
    RETURN
END

