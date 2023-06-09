*-----------------------------------------------------------------------------
* <Rating>-181</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.VIN.BSA.VERIFY.OTP
*-----------------------------------------------------------------------------
* Developer Name     : Dwi K
* Development Date   : 20180405
* Description        : Routine to verify otp
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date            Modified by                Description
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
	$INSERT I_F.ATI.TU.OTP.INFO
    $INSERT I_F.ATI.TH.INTF.INBOUND.WS.MAPPING

*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------
    GOSUB INIT
    GOSUB PROCESS

    RETURN

*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
    FN.ATI.TH.INTF.INBOUND.WS.MAPPING = 'F.ATI.TH.INTF.INBOUND.WS.MAPPING'
    F.ATI.TH.INTF.INBOUND.WS.MAPPING  = ''
    CALL OPF(FN.ATI.TH.INTF.INBOUND.WS.MAPPING,F.ATI.TH.INTF.INBOUND.WS.MAPPING)

    RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------

	Y.MOBILE.NO = R.NEW(OTP.RECORD.ID)
	Y.INPUT.OTP = R.NEW(OTP.INPUT.OTP)
	Y.DATETIME  = TODAY[1,4]:"-":TODAY[5,2]:"-":TODAY[7,2]:"T":OCONV( TIME(), 'MTS' )
	
    Y.MAPPING = "VERIFY.OTP"
    CALL F.READ(FN.ATI.TH.INTF.INBOUND.WS.MAPPING, Y.MAPPING, R.ATI.TH.INTF.INBOUND.WS.MAPPING, F.ATI.TH.INTF.INBOUND.WS.MAPPING, ATI.TH.INTF.INBOUND.WS.MAPPING.ERR)
	Y.FLD.REQ.LIST = R.ATI.TH.INTF.INBOUND.WS.MAPPING<INTF.IN.MAP.FLD.REQ>
	Y.FLD.RES.LIST = R.ATI.TH.INTF.INBOUND.WS.MAPPING<INTF.IN.MAP.FLD.RES>
	
	CONVERT VM TO FM IN Y.FLD.REQ.LIST
	CONVERT VM TO FM IN Y.FLD.RES.LIST
	
	CHANGE "+62" TO "" IN Y.MOBILE.NO
	
	Y.VAL.REQ.LIST     = Y.MOBILE.NO	;*1
	Y.VAL.REQ.LIST<-1> = Y.INPUT.OTP	;*2
	Y.VAL.REQ.LIST<-1> = Y.DATETIME		;*3
	
	Y.TYPE = "ONLINE"
	CALL ATI.INTF.INBOUND.WS.PROCESS(Y.MAPPING, Y.FLD.REQ.LIST, Y.VAL.REQ.LIST, Y.TYPE, Y.RESPONSE, Y.FLD.RES.LIST, Y.VAL.RES.LIST, Y.MSG.ERR)

	IF Y.MSG.ERR THEN
	   ETEXT = Y.MSG.ERR
	   AF    = ""
	   AV    = ""
	   CALL STORE.END.ERROR
	END
	
    RETURN
*-----------------------------------------------------------------------------
END
