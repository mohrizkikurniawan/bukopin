*-----------------------------------------------------------------------------
* <Rating>-13</Rating>
* 08:51:57 27 JUL 2017 
* JFT/t24r11 
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.TT.INTF.OUT.TRANS.CON
*-----------------------------------------------------------------------------
* Developer Name     : ATI Juan Felix
* Development Date   : 20170727
* Description        : Template Table ATI.TT.INTF.OUT.TRANSACTION
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date            Modified by                Description
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_Table

*-----------------------------------------------------------------------------
    Table.name              = "ATI.TT.INTF.OUT.TRANS.CON" ;* Full application name including product prefix
    Table.title             = "Table Interface Out Transaction Concat"       ;* Screen title
    Table.stereotype        = "T"       ;* H, U, L, W or T
    Table.product           = "ST"      ;* Must be on EB.PRODUCT
    Table.subProduct        = ""        ;* Must be on EB.SUB.PRODUCT
    Table.classification    = "INT"     ;* As per FILE.CONTROL
    Table.systemClearFile   = "N"       ;* As per FILE.CONTROL
    Table.relatedFiles      = ""        ;* As per FILE.CONTROL
    Table.isPostClosingFile = ""        ;* As per FILE.CONTROL
    Table.equatePrefix      = "INTF.OUT.TRANS"    ;* Use to create I_F.EB.LOG.PARAMETER
*-----------------------------------------------------------------------------
    Table.idPrefix          = ""        ;* Used by EB.FORMAT.ID if set
    Table.blockedFunctions  = ""        ;* Space delimeted list of blocked functions
    Table.trigger           = ""        ;* Trigger field used for OPERATION style fields
*-----------------------------------------------------------------------------
    RETURN
END

