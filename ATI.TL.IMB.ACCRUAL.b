*-----------------------------------------------------------------------------
* <Rating>-13</Rating>
*-----------------------------------------------------------------------------
	SUBROUTINE ATI.TL.IMB.ACCRUAL
*-----------------------------------------------------------------------------
* Developer Name      : Novi Leo
* Development Date    : 20170518
* Description         : Routine table ATI.TL.IMB.ACCRUAL
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
    Table.name              = "ATI.TL.IMB.ACCRUAL"    ;* Full application name including product prefix
    Table.title             = ""                      ;* Screen title
    Table.stereotype        = "L"                     ;* H, U, L, W or T
    Table.product           = "EB"                    ;* Must be on EB.PRODUCT
    Table.subProduct        = ""                      ;* Must be on EB.SUB.PRODUCT
    Table.classification    = "INT"                   ;* As per FILE.CONTROL
    Table.systemClearFile   = "N"                     ;* As per FILE.CONTROL
    Table.relatedFiles      = ""                      ;* As per FILE.CONTROL
    Table.isPostClosingFile = ""                      ;* As per FILE.CONTROL
    Table.equatePrefix      = "ACR"                   ;* Use to create I_F.EB.LOG.PARAMETER
*-----------------------------------------------------------------------------
    Table.idPrefix          = ""        ;* Used by EB.FORMAT.ID if set
    Table.blockedFunctions  = ""        ;* Space delimeted list of blocked functions
    Table.trigger           = ""        ;* Trigger field used for OPERATION style fields

    RETURN
*-----------------------------------------------------------------------------
END