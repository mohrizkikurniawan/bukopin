*-----------------------------------------------------------------------------
* <Rating>-181</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.BM.MAINT.ACCR.DORMANT.SELECT
*-----------------------------------------------------------------------------
* Developer Name     : Dwi K
* Development Date   : 20171011
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
	$INSERT I_ATI.BM.MAINT.ACCR.DORMANT.COMMON

*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------
    GOSUB SELECTION

    RETURN

*-----------------------------------------------------------------------------
SELECTION:
*-----------------------------------------------------------------------------
*    SEL.CMD  = "SELECT ":FN.ACCOUNT.INACTIVE:" WITH @ID EQ ":TODAY
*	SEL.LIST = ""
*	CALL EB.READLIST(SEL.CMD,SEL.LIST,"",NO.REC,ERR)
	
	Y.ACCOUNT.INACTIVE.ID = TODAY
	CALL F.READ(FN.ACCOUNT.INACTIVE, Y.ACCOUNT.INACTIVE.ID, R.ACCOUNT.INACTIVE, F.ACCOUNT.INACTIVE, AC.INAC.ERR)
	
	CALL BATCH.BUILD.LIST("", R.ACCOUNT.INACTIVE)
	
    RETURN
*-----------------------------------------------------------------------------
END




