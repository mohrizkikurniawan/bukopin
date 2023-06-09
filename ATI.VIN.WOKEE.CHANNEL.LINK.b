*-----------------------------------------------------------------------------
    SUBROUTINE ATI.VIN.WOKEE.CHANNEL.LINK
*-----------------------------------------------------------------------------
* Developer Name     : Dhio Faizar Wahyudi
* Development Date   : 20180326
* Description        : Routine to check Wokee and Channel Link
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
	
	CALL F.READ(FN.ATI.TH.EC.USERNAME, ID.NEW, R.ATI.TH.EC.USERNAME, F.ATI.TH.EC.USERNAME, ATI.TH.EC.USERNAME.ERR)
		
	RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
	
	Y.ATI.TH.EC.USERNAME.CHANNEL.NEW = R.NEW(24)<1,1>
	Y.ATI.TH.EC.USERNAME.CHANNEL.OLD = R.ATI.TH.EC.USERNAME<24>
*	IF R.NEW(EC.USER.CHANNEL) EQ R.OLD(EC.USER.CHANNEL) THEN
	FIND Y.ATI.TH.EC.USERNAME.CHANNEL.NEW IN Y.ATI.TH.EC.USERNAME.CHANNEL.OLD SETTING Y.AF.POS, Y.AV.POS THEN
		AF    = ""
		ETEXT = "EB-WOKEE.LINK.OKE.OCE"
        CALL STORE.END.ERROR
	END ELSE
		IF Y.ATI.TH.EC.USERNAME.CHANNEL.OLD NE '' THEN
			R.NEW(EC.USER.CHANNEL) = Y.ATI.TH.EC.USERNAME.CHANNEL.OLD : @VM : Y.ATI.TH.EC.USERNAME.CHANNEL.NEW
		END ELSE
			R.NEW(EC.USER.CHANNEL) = Y.ATI.TH.EC.USERNAME.CHANNEL.NEW
		END
	END
	
	RETURN
*-----------------------------------------------------------------------------
END
