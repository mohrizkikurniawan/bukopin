*-----------------------------------------------------------------------------
* <Rating>-13</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.TT.EMAIL.SMS.OUT
*-----------------------------------------------------------------------------
* Developer Name     : ATI Juan Felix
* Development Date   : 20170703
* Description        : Table Email SMS Send Out
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date            Modified by                Description
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_Table
*-----------------------------------------------------------------------------
    Table.name              = "ATI.TT.EMAIL.SMS.OUT"       ;* Full application name including product prefix
    Table.title             = "Email SMS Send Out"         ;* Screen title
    Table.stereotype        = "T"       ;* H, U, L, W or T
    Table.product           = "EB"      ;* Must be on EB.PRODUCT
    Table.subProduct        = ""        ;* Must be on EB.SUB.PRODUCT
    Table.classification    = "INT"     ;* As per FILE.CONTROL
    Table.systemClearFile   = "N"       ;* As per FILE.CONTROL
    Table.relatedFiles      = ""        ;* As per FILE.CONTROL
    Table.isPostClosingFile = ""        ;* As per FILE.CONTROL
    Table.equatePrefix      = "ES.OUT"    ;* Use to create I_F.EB.LOG.PARAMETER
*-----------------------------------------------------------------------------
    Table.idPrefix          = ""        ;* Used by EB.FORMAT.ID if set
    Table.blockedFunctions  = ""        ;* Space delimeted list of blocked functions
    Table.trigger           = ""        ;* Trigger field used for OPERATION style fields

    RETURN
*-----------------------------------------------------------------------------
END

