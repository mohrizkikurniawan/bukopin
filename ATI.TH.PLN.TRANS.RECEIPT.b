*-----------------------------------------------------------------------------
* <Rating>-13</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.TH.PLN.TRANS.RECEIPT
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
    $INSERT I_Table

*-----------------------------------------------------------------------------
    Table.name              = "ATI.TH.PLN.TRANS.RECEIPT" ;* Full application name including product prefix
    Table.title             = "Table PLN Transaction Receipt"       ;* Screen title
    Table.stereotype        = "H"       ;* H, U, L, W or T
    Table.product           = "ST"      ;* Must be on EB.PRODUCT
    Table.subProduct        = ""        ;* Must be on EB.SUB.PRODUCT
    Table.classification    = "INT"     ;* As per FILE.CONTROL
    Table.systemClearFile   = "N"       ;* As per FILE.CONTROL
    Table.relatedFiles      = ""        ;* As per FILE.CONTROL
    Table.isPostClosingFile = ""        ;* As per FILE.CONTROL
    Table.equatePrefix      = "PLN.RCP"    ;* Use to create I_F.EB.LOG.PARAMETER
*-----------------------------------------------------------------------------
    Table.idPrefix          = ""        ;* Used by EB.FORMAT.ID if set
    Table.blockedFunctions  = ""        ;* Space delimeted list of blocked functions
    Table.trigger           = ""        ;* Trigger field used for OPERATION style fields
*-----------------------------------------------------------------------------
    RETURN
END

