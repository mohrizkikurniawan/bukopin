*-----------------------------------------------------------------------------
* <Rating>-181</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.VIN.AB.AGENT.AUTH.OVRR
*-----------------------------------------------------------------------------
* Developer Name     : Dwi K
* Development Date   : 20180530
* Description        : Routine to override authoriser
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date            Modified by                Description
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ATI.TH.AB.AGENT

*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------
    GOSUB INIT
    GOSUB PROCESS

    RETURN

*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------

    RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    Y.INPUTTER = FIELD(R.NEW(AB.AGN.INPUTTER), '_', 2, 1)
	Y.OPERATOR = OPERATOR

	IF Y.INPUTTER EQ Y.OPERATOR THEN
       TEXT        = "ATI.AGENT.AUTH.OVERRIDE"
       NO.OF.OVERR = 1
       CALL STORE.OVERRIDE(NO.OF.OVERR)	
	END
	
    RETURN
*-----------------------------------------------------------------------------
END

