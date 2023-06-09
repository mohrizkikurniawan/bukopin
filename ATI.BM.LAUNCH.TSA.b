*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.BM.LAUNCH.TSA(Y.SERVICE.ID)
*-----------------------------------------------------------------------------
* Developer Name     : Dwi K
* Development Date   : 20190221
* Description        : Routine to start job while COB
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date            Modified by                Description
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ATI.BM.LAUNCH.TSA.COMMON
	
*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------
    GOSUB PROCESS

    RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------

    CALL F.READ(FN.TSA.SERVICE, Y.SERVICE.ID, R.TSA.SERVICE, F.TSA.SERVICE, ERR.READ.TSA)
    IF ERR.READ.TSA THEN
        CALL OCOMO(Y.SERVICE.ID : " is not a TSA.SERVICE")
    END ELSE
        CALL OCOMO("Launching TSA.SERVICE " : Y.SERVICE.ID)
        Y.SERVICE.ACTION = 'START'
        CALL SERVICE.CONTROL(Y.SERVICE.ID,Y.SERVICE.ACTION,'')
    END

    RETURN

*-----------------------------------------------------------------------------
END


