*-----------------------------------------------------------------------------
    SUBROUTINE ATI.VID.WOKEE.OKE.OCE.LINK
*-----------------------------------------------------------------------------
* Developer Name     : Dhio Faizar Wahyudi
* Development Date   : 20180326
* Description        : Routine to check Wokee and OKE OCE Link
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date            Modified by                Description
*-----------------------------------------------------------------------------

	$INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ATI.TH.EC.USERNAME

*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------

	GOSUB INIT
	GOSUB PROCESS

    RETURN

*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
	
	FN.ATI.TH.EC.USERNAME = "F.ATI.TH.EC.USERNAME"
	F.ATI.TH.EC.USERNAME = ""
	CALL OPF(FN.ATI.TH.EC.USERNAME, F.ATI.TH.EC.USERNAME)
	
	RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
	
	Y.ATI.TH.EC.USERNAME.ID = COMI
	CALL F.READ(FN.ATI.TH.EC.USERNAME, Y.ATI.TH.EC.USERNAME.ID, R.ATI.TH.EC.USERNAME, F.ATI.TH.EC.USERNAME, ATI.TH.EC.USERNAME.ERR)
	Y.ATI.TH.EC.USERNAME.OKE.OCE.LINK = R.ATI.TH.EC.USERNAME<EC.USER.OK.OCE.LINK>
	
	IF Y.ATI.TH.EC.USERNAME.OKE.OCE.LINK EQ "YES" THEN
		E = "EB-WOKEE.LINK.OKE.OCE"
*		CALL ERR
	END
	
	RETURN
*-----------------------------------------------------------------------------
END
