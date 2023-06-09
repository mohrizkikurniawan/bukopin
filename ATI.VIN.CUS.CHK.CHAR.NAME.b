    SUBROUTINE ATI.VIN.CUS.CHK.CHAR.NAME
*-----------------------------------------------------------------------------
* Developer Name     : Dwi K
* Development Date   : 20181126
* Description        : Routine to validate character for name
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date            Modified by                Description
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
	$INSERT I_F.CUSTOMER

*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------
	GOSUB INIT
	GOSUB PROCESS

    RETURN

*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
    Y.APP      = 'CUSTOMER'
    Y.FLD.NAME = 'ATI.MOTH.MAIDEN'
    Y.POS      = ''
    CALL MULTI.GET.LOC.REF(Y.APP,Y.FLD.NAME,Y.POS)
    Y.ATI.MOTH.MAIDEN.POS = Y.POS<1,1>   
	
    RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------

    Y.NAME.1  = R.NEW(EB.CUS.NAME.1)
	Y.NAME    = TRIM(Y.NAME.1, "", "D")
	CONVERT "., -" TO "" IN Y.NAME
	
	IF NOT(ISALPHA(Y.NAME)) THEN
		ETEXT = 'EB-AB.ONLY.APHACHAR.IS.ALLOWED'
		AF    = EB.CUS.NAME.1
		CALL STORE.END.ERROR
	END

*--------
	Y.SHORT.NAME = R.NEW(EB.CUS.SHORT.NAME)
	Y.NAME       = TRIM(Y.SHORT.NAME, "", "D")
	CONVERT "., -" TO "" IN Y.NAME
	
	IF NOT(ISALPHA(Y.NAME)) THEN
		ETEXT = 'EB-AB.ONLY.APHACHAR.IS.ALLOWED'
		AF    = EB.CUS.SHORT.NAME
		CALL STORE.END.ERROR
	END

*--------	
	Y.ATI.MOTH.MAIDEN = R.NEW(EB.CUS.LOCAL.REF)<1, Y.ATI.MOTH.MAIDEN.POS>
	Y.NAME            = TRIM(Y.ATI.MOTH.MAIDEN, "", "D")
	CONVERT "., -" TO "" IN Y.NAME
	
	IF NOT(ISALPHA(Y.NAME)) THEN
		ETEXT = 'EB-AB.ONLY.APHACHAR.IS.ALLOWED'
		AF    = EB.CUS.LOCAL.REF
		AV    = Y.ATI.MOTH.MAIDEN.POS
		CALL STORE.END.ERROR
	END

*--------	
	
    RETURN
*-----------------------------------------------------------------------------
NAME.VALIDATION:
*----------------------------------------------------------------------------- 
*	CONVERT ".,-" TO "" IN Y.NAME
*	
*	IF NOT(ISALPHA(Y.NAME)) THEN
*		ETEXT = 'EB-AB.ONLY.APHACHAR.IS.ALLOWED'
*		CALL STORE.END.ERROR
*	END

**regex to check if a string containing a non-aplha char nor . nor space
*	Y.REGEX.EXP1 = "[^A-Za-z.-, ]"
*	
**regex to check if a string containing an aplha char
*	Y.REGEX.EXP2  = "[A-Za-z]"
*	
*	Y.CNT.NAME = DCOUNT(Y.NAME, VM)
*
*	FOR Y.A=1 TO Y.CNT.NAME
*		Y.CHECK.CHAR = Y.NAME<1, Y.A>
*		
*		BEGIN CASE
*		CASE REGEXP(Y.CHECK.CHAR, Y.REGEX.EXP1)
*		    ETEXT = 'EB-AB.ONLY.APHACHAR.IS.ALLOWED'
*			CALL STORE.END.ERROR
*			
*			CONTINUE
*		CASE NOT(REGEXP(Y.CHECK.CHAR, Y.REGEX.EXP2))
*			ETEXT = 'EB-AB.SHOULD.HAVE.APHACHAR'
*			CALL STORE.END.ERROR
*			
*			CONTINUE
*		CASE 1
*		END CASE		
*	NEXT Y.A
	
	RETURN

*-----------------------------------------------------------------------------
END
