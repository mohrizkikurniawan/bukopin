	SUBROUTINE ATI.VIN.BSA.UPD.CUST.PIN
*-----------------------------------------------------------------------------
* Developer Name     : Novi Leo
* Development Date   : 20180713
* Description        : Routine to regenerate PIN
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date            Modified by                Description
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ATI.TH.AB.CUSTOMER
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

	FN.ATI.TH.INTF.INBOUND.WS.MAPPING = "F.ATI.TH.INTF.INBOUND.WS.MAPPING"
	F.ATI.TH.INTF.INBOUND.WS.MAPPING  = ""
	CALL OPF(FN.ATI.TH.INTF.INBOUND.WS.MAPPING, F.ATI.TH.INTF.INBOUND.WS.MAPPING)

    RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------

    Y.TYPE = "PIN"
    CALL ATI.GEN.EC.PASS.PIN(Y.TYPE, Y.VALUE)
	R.NEW(AB.CUS.PIN) = Y.VALUE
	
	GOSUB UPDATE.PIN
	
    RETURN
*-----------------------------------------------------------------------------
UPDATE.PIN:
*----------------------------------------------------------------------------

	Y.TYPE.ACT  = "update"
	
	Y.ACCOUNT   = R.NEW(AB.CUS.ACCOUNT.NO)
	Y.PIN       = R.NEW(AB.CUS.PIN)
	Y.DATETIME  = TODAY[1,4]:"-":TODAY[5,2]:"-":TODAY[7,2]:"T":OCONV( TIME(), 'MTS' )
	
	CALL ATI.ENC.DEC.PASS.PIN(Y.PIN, "DECRYPT", Y.PIN.DECRYPT)

	Y.INBOUND.MAPPING = "EMOBILE"
    CALL F.READ(FN.ATI.TH.INTF.INBOUND.WS.MAPPING, Y.INBOUND.MAPPING, R.ATI.TH.INTF.INBOUND.WS.MAPPING, F.ATI.TH.INTF.INBOUND.WS.MAPPING, ATI.TH.INTF.INBOUND.WS.MAPPING.ERR)
	Y.FLD.REQ.LIST = R.ATI.TH.INTF.INBOUND.WS.MAPPING<INTF.IN.MAP.FLD.REQ>
	Y.FLD.RES.LIST = R.ATI.TH.INTF.INBOUND.WS.MAPPING<INTF.IN.MAP.FLD.RES>
	
	CONVERT VM TO FM IN Y.FLD.REQ.LIST
	CONVERT VM TO FM IN Y.FLD.RES.LIST

	Y.VAL.REQ.LIST     = Y.TYPE.ACT         ;*1
	Y.VAL.REQ.LIST<-1> = Y.ACCOUNT			;*2
	Y.VAL.REQ.LIST<-1> = Y.PIN.DECRYPT		;*3
	Y.VAL.REQ.LIST<-1> = Y.DATETIME			;*4
	
	Y.TYPE = "ONLINE"
	CALL ATI.INTF.INBOUND.WS.PROCESS(Y.INBOUND.MAPPING, Y.FLD.REQ.LIST, Y.VAL.REQ.LIST, Y.TYPE, Y.RESPONSE, Y.FLD.RES.LIST, Y.VAL.RES.LIST, Y.ERROR)
	
	Y.RESPONSE = Y.RESPONSE
	
*>20181218-DWK
    IF Y.ERROR THEN
	  ETEXT   = 'Koneksi Timeout'
	  AF      = ''
	  AV      = ''
	  V$ERROR = 1
	  CALL STORE.END.ERROR
	END
*>20181218-DWK
	
	RETURN
*----------------------------------------------------------------------------	
END