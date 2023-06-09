*-----------------------------------------------------------------------------
    SUBROUTINE ATI.TH.RIZKI1
*-----------------------------------------------------------------------------
* Developer Name     : Moh. Rizki Kurniawan
* Development Date   : 20190912
* Description        : Training
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date            Modified by                Description
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
	$INSERT I_Table

*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------
    GOSUB INIT
    GOSUB PROCESS

    RETURN

*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
	Table.name = 'ATI.TH.RIZKI1'
	Table.title = 'Training 1'
	Table.stereotype = 'H'
	Table.product = 'ST'
	Table.subProduct = ''
	Table.classification = 'INT'
	Table.systemClearFile = 'N'
	Table.relatedFiles = ''
	Table.isPostClosingFile = ''
	Table.equatePrefix = 'RIZ.1'
	
	Table.idPrefix = ''
	Table.blockedFunctions = ''
	Table.trigger = ''
	
	
	RETURN
	
*-----------------------------------------------------------------------------	
END
