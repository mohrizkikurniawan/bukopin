*-----------------------------------------------------------------------------
* <Rating>-13</Rating>
* 11:14:19 27 JUL 2015 
* WIN-KVUAVRB60BE/R14 
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.TL.AC.DETAILS
*-----------------------------------------------------------------------------
* Created by   : ATI Julian Gerry
* Created Date : 20160127
* Description  : Template table of static data account, enquiry purpose
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

    Table.name              = 'ATI.TL.AC.DETAILS'  ;* Full application name including product prefix
    Table.title             = 'Acct Details'     ;* Screen title
    Table.stereotype        = 'L'       ;* H, U, L, W or T
    Table.product           = 'EB'      ;* Must be on EB.PRODUCT
    Table.subProduct        = ''        ;* Must be on EB.SUB.PRODUCT
    Table.classification    = 'FIN'     ;* As per FILE.CONTROL
    Table.systemClearFile   = 'N'       ;* As per FILE.CONTROL
    Table.relatedFiles      = ''        ;* As per FILE.CONTROL
    Table.isPostClosingFile = ''        ;* As per FILE.CONTROL
    Table.equatePrefix      = 'AC.DET'    ;* Use to create I_F.EB.LOG.PARAMETER
*-----------------------------------------------------------------------------
    Table.idPrefix          = ''        ;* Used by EB.FORMAT.ID if set
    Table.blockedFunctions  = ''        ;* Space delimeted list of blocked functions
    Table.trigger           = ''        ;* Trigger field used for OPERATION style fields
*-----------------------------------------------------------------------------
    RETURN
END

