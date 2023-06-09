*-----------------------------------------------------------------------------
* <Rating>-181</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.VID.INPUT.NEW.REC.ONLY
*-----------------------------------------------------------------------------
* Developer Name     : Fatkhur Rohman
* Development Date   : 20180810
* Description        : ID Routine to check input new record only in application
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date            Modified by                Description
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
	$INSERT I_F.FILE.CONTROL

*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------
    GOSUB INIT
    GOSUB PROCESS

    RETURN

*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
	FN.FILE.CONTROL = 'F.FILE.CONTROL'
	CALL OPF(FN.FILE.CONTROL, F.FILE.CONTROL)
	
	CALL F.READ(FN.FILE.CONTROL, APPLICATION, R.FILE.CONTROL, F.FILE.CONTROL, ERR.FILE.CONTROL)
	
	FN.APP<1> = "F." : APPLICATION
	CALL OPF(FN.APP<1>, F.APP<1>)
	
	Y.SUFFIXES = R.FILE.CONTROL<EB.FILE.CONTROL.SUFFIXES>
	Y.CNT = DCOUNT(Y.SUFFIXES, @VM)
	
	FOR Y.LOOP=2 TO Y.CNT+1
		FN.APP<Y.LOOP> = "F." : APPLICATION : Y.SUFFIXES<1, Y.LOOP-1>
		CALL OPF(FN.APP<Y.LOOP>, F.APP<Y.LOOP>)
	NEXT Y.LOOP

    RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
	Y.ID = COMI
	
	Y.CNT.APP = DCOUNT(FN.APP, @FM)
	Y.FLAG    = 0
	
	FOR Y.A=1 TO Y.CNT.APP
		Y.SFX = FIELD(FN.APP<Y.A>, '$', 2)
		IF Y.SFX EQ 'HIS' THEN
			CALL F.READ.HISTORY(FN.APP<Y.A>, Y.ID, R.APP, F.APP<Y.A>, ERR.APP)
			IF R.APP THEN
				Y.FLAG = 1
				BREAK
			END
		END ELSE
			CALL F.READ(FN.APP<Y.A>, Y.ID, R.APP, F.APP<Y.A>, ERR.APP)
			IF R.APP THEN
				Y.FLAG = 1
				BREAK
			END
		END
	NEXT Y.A
	
	IF Y.FLAG THEN
		E = "EB-INPUT.NEW.RECORD.ONLY"
	END
	
    RETURN
*-----------------------------------------------------------------------------
END
