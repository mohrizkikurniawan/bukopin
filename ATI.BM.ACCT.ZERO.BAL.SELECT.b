*-----------------------------------------------------------------------------
* <Rating>-181</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.BM.ACCT.ZERO.BAL.SELECT
*-----------------------------------------------------------------------------
* Developer Name     : Dwi K
* Development Date   : 20171222
* Description        : Routine for
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date            Modified by                Description
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ATI.BM.ACCT.ZERO.BAL.COMMON
	
*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------
    GOSUB SELECTION

    RETURN

*-----------------------------------------------------------------------------
SELECTION:
*-----------------------------------------------------------------------------
    SEL.CMD  = "SELECT " : FN.ACCOUNT : " WITH CUSTOMER NE ''"
	SEL.LIST = ""
	CALL EB.READLIST(SEL.CMD, SEL.LIST, "", NO.REC, ERR)
	
	CALL BATCH.BUILD.LIST("", SEL.LIST)

    RETURN

*-----------------------------------------------------------------------------
END



