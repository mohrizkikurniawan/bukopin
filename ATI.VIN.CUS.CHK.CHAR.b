    SUBROUTINE ATI.VIN.CUS.CHK.CHAR
*-----------------------------------------------------------------------------
* Developer Name     : Dwi K
* Development Date   : 20181126
* Description        : Routine to validate character
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date            Modified by                Description
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
	$INSERT I_F.CUSTOMER
	$INSERT I_F.ATI.TH.EC.USERNAME

*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------
	GOSUB INIT
	
	BEGIN CASE
	CASE APPLICATION EQ "CUSTOMER"
	     GOSUB PROCESS.CUSTOMER
	CASE APPLICATION EQ "ATI.TH.EC.USERNAME"
	     GOSUB PROCESS.ATI.TH.EC.USERNAME
	END CASE

    RETURN

*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
    Y.APP      = 'CUSTOMER'
    Y.FLD.NAME = 'ATI.MOTH.MAIDEN' :VM: 'ATI.ZIP.DOM' :VM: 'ATI.LEGAL.ID.NO' :VM: 'ATI.NO.KK'
    Y.POS      = ''
    CALL MULTI.GET.LOC.REF(Y.APP,Y.FLD.NAME,Y.POS)
    Y.ATI.MOTH.MAIDEN.POS = Y.POS<1,1>   
	Y.ATI.ZIP.DOM.POS     = Y.POS<1,2>
	Y.ATI.LEGAL.ID.NO.POS = Y.POS<1,3>
	Y.ATI.NO.KK.POS       = Y.POS<1,4>
	
	Y.REGEX.EXP.NUM = "[^0-9]"
	
    RETURN

*-----------------------------------------------------------------------------
PROCESS.CUSTOMER:
*-----------------------------------------------------------------------------

    Y.NAME.1  = R.NEW(EB.CUS.NAME.1)
	Y.NAME    = TRIM(Y.NAME.1, "", "D")
	CONVERT "., -" TO "" IN Y.NAME
	
	IF NOT(ISALPHA(Y.NAME)) THEN
		ETEXT = 'EB-CU.ONLY.APHACHAR.IS.ALLOWED'
		AF    = EB.CUS.NAME.1
		CALL STORE.END.ERROR
	END

*--------
	Y.SHORT.NAME = R.NEW(EB.CUS.SHORT.NAME)
	Y.NAME       = TRIM(Y.SHORT.NAME, "", "D")
	CONVERT "., -" TO "" IN Y.NAME
	
	IF NOT(ISALPHA(Y.NAME)) THEN
		ETEXT = 'EB-CU.ONLY.APHACHAR.IS.ALLOWED'
		AF    = EB.CUS.SHORT.NAME
		CALL STORE.END.ERROR
	END

*--------	
	Y.ATI.MOTH.MAIDEN = R.NEW(EB.CUS.LOCAL.REF)<1, Y.ATI.MOTH.MAIDEN.POS>
	Y.NAME            = TRIM(Y.ATI.MOTH.MAIDEN, "", "D")
	CONVERT "., -" TO "" IN Y.NAME
	
	IF NOT(ISALPHA(Y.NAME)) THEN
		ETEXT = 'EB-CU.ONLY.APHACHAR.IS.ALLOWED'
		AF    = EB.CUS.LOCAL.REF
		AV    = Y.ATI.MOTH.MAIDEN.POS
		CALL STORE.END.ERROR
	END

*--------	
	Y.ATI.ZIP.DOM = R.NEW(EB.CUS.LOCAL.REF)<1, Y.ATI.ZIP.DOM.POS>
*	IF NOT(NUM(Y.ATI.ZIP.DOM)) THEN
	IF REGEXP(Y.ATI.ZIP.DOM, Y.REGEX.EXP.NUM) THEN
		ETEXT = 'EB-CU.ONLY.NUMERIC.IS.ALLOWED'
		AF    = EB.CUS.LOCAL.REF
		AV    = Y.ATI.ZIP.DOM.POS	
		CALL STORE.END.ERROR
	END

*--------	
	Y.ATI.LEGAL.ID.NO = R.NEW(EB.CUS.LOCAL.REF)<1, Y.ATI.LEGAL.ID.NO.POS>
*	IF NOT(NUM(Y.ATI.LEGAL.ID.NO)) THEN
	IF REGEXP(Y.ATI.LEGAL.ID.NO, Y.REGEX.EXP.NUM) THEN
		ETEXT = 'EB-CU.ONLY.NUMERIC.IS.ALLOWED'
		AF    = EB.CUS.LOCAL.REF
		AV    = Y.ATI.LEGAL.ID.NO.POS
		CALL STORE.END.ERROR		
	END
	
*--------	

	Y.ATI.NO.KK = R.NEW(EB.CUS.LOCAL.REF)<1, Y.ATI.NO.KK.POS>
*	IF NOT(NUM(Y.ATI.NO.KK)) THEN
	IF REGEXP(Y.ATI.NO.KK, Y.REGEX.EXP.NUM) THEN
		ETEXT = 'EB-CU.ONLY.NUMERIC.IS.ALLOWED'
		AF    = EB.CUS.LOCAL.REF
		AV    = Y.ATI.NO.KK.POS	
		CALL STORE.END.ERROR
	END	
	
*--------	
	Y.POST.CODE     = R.NEW(EB.CUS.POST.CODE)
	Y.CNT.POST.CODE = DCOUNT(Y.POST.CODE, VM)
	FOR YLOOP = 1 TO Y.CNT.POST.CODE
	    Y.CURR.POST.CODE = Y.POST.CODE<1,YLOOP>
*	    IF NOT(NUM(Y.CURR.POST.CODE)) THEN
		IF REGEXP(Y.CURR.POST.CODE, Y.REGEX.EXP.NUM) THEN
	    	ETEXT = 'EB-CU.ONLY.NUMERIC.IS.ALLOWED'
	    	AF    = EB.CUS.POST.CODE
	    	AV    = Y.LOOP	
	    	CALL STORE.END.ERROR
	    END	
	NEXT YLOOP
	
*--------
	Y.SMS.1   = R.NEW(EB.CUS.SMS.1)
	Y.CNT.SMS = DCOUNT(Y.SMS.1, VM)
	FOR YLOOP2 = 1 TO Y.CNT.SMS
	   Y.CURR.SMS.1 = Y.SMS.1<1,YLOOP2>
	   IF Y.CURR.SMS.1[1,3] NE "+62" THEN
		  ETEXT = 'EB-CU.FMT.MOBILE.NO'
		  AF    = EB.CUS.SMS.1
		  AV    = YLOOP
		  CALL STORE.END.ERROR		  
	   END
	   
	   CONVERT "+" TO "" IN Y.CURR.SMS.1
*	   IF NOT(NUM(Y.CURR.SMS.1)) THEN
       IF REGEXP(Y.CURR.SMS.1, Y.REGEX.EXP.NUM) THEN
	   	  ETEXT = 'EB-CU.FMT.MOBILE.NO'
		  AF    = EB.CUS.SMS.1
		  AV    = YLOOP	
          CALL STORE.END.ERROR		  
	   END
	NEXT YLOOP2

*--------

	RETURN

*-----------------------------------------------------------------------------
PROCESS.ATI.TH.EC.USERNAME:
*-----------------------------------------------------------------------------
	Y.MOBILE.NO   = R.NEW(EC.USER.MOBILE.NO)
	IF Y.MOBILE.NO[1,3] NE "+62" THEN
	  ETEXT = 'EB-CU.FMT.MOBILE.NO'
	  AF    = EC.USER.MOBILE.NO
	  CALL STORE.END.ERROR		  
	END
	
	CONVERT "+" TO "" IN Y.MOBILE.NO
*	IF NOT(NUM(Y.MOBILE.NO)) THEN
    IF REGEXP(Y.MOBILE.NO, Y.REGEX.EXP.NUM) THEN
	   ETEXT = 'EB-CU.FMT.MOBILE.NO'
	   AF    = EC.USER.MOBILE.NO	
       CALL STORE.END.ERROR		  
	END

*--------


	RETURN
*-----------------------------------------------------------------------------
END
