*-----------------------------------------------------------------------------
* <Rating>-181</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.VID.WTD.FT.CHK
*-----------------------------------------------------------------------------
* Developer Name     : Dwi K
* Development Date   : 20170605
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

*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------
	IF V$FUNCTION NE "A" THEN
		RETURN
	END
	
    GOSUB INIT
    GOSUB PROCESS

    RETURN

*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
    FN.ATI.TH.WTD.FT = 'F.ATI.TH.WTD.FT'
    F.ATI.TH.WTD.FT  = ''
    CALL OPF(FN.ATI.TH.WTD.FT,F.ATI.TH.WTD.FT)
	
    RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
 
	Y.WTD.FT.ID = COMI
	CALL F.READ(FN.ATI.TH.WTD.FT, Y.WTD.FT.ID, R.ATI.TH.WTD.FT, F.ATI.TH.WTD.FT, ERR.ATI.TH.WTD.FT)
    IF NOT(R.ATI.TH.WTD.FT) THEN
	   ETEXT = "REFERENCE ID IS NOT VALID"
	   CALL STORE.END.ERROR	
	END
		
    RETURN
*-----------------------------------------------------------------------------
END




