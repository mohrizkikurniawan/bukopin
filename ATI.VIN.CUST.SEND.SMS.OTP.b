*-----------------------------------------------------------------------------
* <Rating>-181</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.VIN.CUST.SEND.SMS.OTP
*-----------------------------------------------------------------------------
* Developer Name     : Dwi K
* Development Date   : 20190626
* Description        : Routine to send sms otp
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
DEBUG
	Y.EMAIL     = R.NEW(OTP.EMAIL)
	Y.DATETIME  = TODAY[1,4]:"-":TODAY[5,2]:"-":TODAY[7,2]:"T":OCONV( TIME(), 'MTS' )
	
    Y.MAPPING = "SMS.OTP.WOKEE"
    CALL F.READ(FN.ATI.TH.INTF.INBOUND.WS.MAPPING, Y.MAPPING, R.ATI.TH.INTF.INBOUND.WS.MAPPING, F.ATI.TH.INTF.INBOUND.WS.MAPPING, ATI.TH.INTF.INBOUND.WS.MAPPING.ERR)
	Y.FLD.REQ.LIST = R.ATI.TH.INTF.INBOUND.WS.MAPPING<INTF.IN.MAP.FLD.REQ>
	Y.FLD.RES.LIST = R.ATI.TH.INTF.INBOUND.WS.MAPPING<INTF.IN.MAP.FLD.RES>
	
	CONVERT VM TO FM IN Y.FLD.REQ.LIST
	CONVERT VM TO FM IN Y.FLD.RES.LIST
	
	Y.VAL.REQ.LIST     = Y.EMAIL	    ;*1
	Y.VAL.REQ.LIST<-1> = Y.DATETIME		;*2
	
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
