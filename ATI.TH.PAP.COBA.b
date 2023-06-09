    SUBROUTINE ATI.TH.PAP.COBA
*-----------------------------------------------------------------------------
* Developer Name     : Moh. Rizki Kurniawan
* Development Date   : 20190920
* Description        : Table Premi Asuransi Param
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date            Modified by                Description
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_Table
*-----------------------------------------------------------------------------
    Table.name              = "ATI.TH.PAP.COBA"   ;* Full application name including product prefix
    Table.title             = "Table Premi Asuransi Param"    ;* Screen title
    Table.stereotype        = "H"                         	  ;* H, U, L, W or T
    Table.product           = "EB"                        	  ;* Must be on EB.PRODUCT
    Table.subProduct        = ""                              ;* Must be on EB.SUB.PRODUCT
    Table.classification    = "INT"                     	  ;* As per FILE.CONTROL
    Table.systemClearFile   = "N"                         	  ;* As per FILE.CONTROL
    Table.relatedFiles      = ""                          	  ;* As per FILE.CONTROL
    Table.isPostClosingFile = ""                              ;* As per FILE.CONTROL
    Table.equatePrefix      = "PAP.COBA"                       ;* Use to create I_F.EB.LOG.PARAMETER
*-----------------------------------------------------------------------------
    Table.idPrefix          = ""                              ;* Used by EB.FORMAT.ID if set
    Table.blockedFunctions  = ""                              ;* Space delimeted list of blocked functions
    Table.trigger           = ""                              ;* Trigger field used for OPERATION style fields

    RETURN
*-----------------------------------------------------------------------------
END
