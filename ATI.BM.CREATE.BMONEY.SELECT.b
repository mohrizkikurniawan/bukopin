*-----------------------------------------------------------------------------
* <Rating>-181</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.BM.CREATE.BMONEY.SELECT
*-----------------------------------------------------------------------------
* Developer Name     : Dwi K
* Development Date   : 2018
* Description        : Routine for create bmoney account
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date            Modified by                Description
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ATI.BM.CREATE.BMONEY.COMMON

*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------
    GOSUB SELECTION
	
    RETURN

*-----------------------------------------------------------------------------
SELECTION:
*-----------------------------------------------------------------------------
    SEL.CMD = "SELECT ":FN.ATI.TH.EC.USERNAME:" WITH WALLET.AC EQ ''"
	SEL.LIST = ""
	CALL EB.READLIST(SEL.CMD,SEL.LIST,"",NO.REC, ERR)
	
	CALL BATCH.BUILD.LIST("",SEL.LIST)

    RETURN
*-----------------------------------------------------------------------------
END




