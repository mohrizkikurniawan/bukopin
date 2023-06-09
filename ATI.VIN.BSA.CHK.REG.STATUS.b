*-----------------------------------------------------------------------------
* <Rating>-181</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.VIN.BSA.CHK.REG.STATUS
*-----------------------------------------------------------------------------
* Developer Name     : Dwi K
* Development Date   : 20180405
* Description        : Routine for checking registration status
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

    FN.ATI.TH.INTF.INBOUND.WS.MAPPING = 'F.ATI.TH.INTF.INBOUND.WS.MAPPING'
    F.ATI.TH.INTF.INBOUND.WS.MAPPING  = ''
    CALL OPF(FN.ATI.TH.INTF.INBOUND.WS.MAPPING,F.ATI.TH.INTF.INBOUND.WS.MAPPING)
	
	Y.EXP.CHARS  = "`~!@#$%^&*()-_=+[{]}\|;:'"
	Y.EXP.CHARS := '",<.>/?1234567890'

    RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------

    Y.NAME = R.NEW(AB.CUS.NAME)<1,1>
	CONVERT Y.EXP.CHARS TO '' IN Y.NAME
	Y.NAME = TRIM(Y.NAME, "", "D")
	
	Y.EB.EXT.USER  = R.NEW(AB.CUS.EB.EXT.USER)
	Y.MOBILE.NO    = ID.NEW
	Y.EMAIL		   = ""
	Y.PASSWORD     = ""
	Y.PIN          = ""
	Y.DATETIME     = TODAY[1,4]:"-":TODAY[5,2]:"-":TODAY[7,2]:"T":OCONV( TIME(), 'MTS' )
	
    Y.MAPPING = "REG.STATUS"
    CALL F.READ(FN.ATI.TH.INTF.INBOUND.WS.MAPPING, Y.MAPPING, R.ATI.TH.INTF.INBOUND.WS.MAPPING, F.ATI.TH.INTF.INBOUND.WS.MAPPING, ATI.TH.INTF.INBOUND.WS.MAPPING.ERR)
	Y.FLD.REQ.LIST = R.ATI.TH.INTF.INBOUND.WS.MAPPING<INTF.IN.MAP.FLD.REQ>
	Y.FLD.RES.LIST = R.ATI.TH.INTF.INBOUND.WS.MAPPING<INTF.IN.MAP.FLD.RES>
	
	CONVERT VM TO FM IN Y.FLD.REQ.LIST
	CONVERT VM TO FM IN Y.FLD.RES.LIST
	
	Y.VAL.REQ.LIST     = Y.NAME         ;*1
	Y.VAL.REQ.LIST<-1> = Y.NAME         ;*2
	Y.VAL.REQ.LIST<-1> = Y.EB.EXT.USER	;*3
	Y.VAL.REQ.LIST<-1> = Y.EB.EXT.USER	;*4
	Y.VAL.REQ.LIST<-1> = Y.EB.EXT.USER	;*5
	Y.VAL.REQ.LIST<-1> = Y.EB.EXT.USER	;*6
	Y.VAL.REQ.LIST<-1> = Y.EMAIL		;*7
	Y.VAL.REQ.LIST<-1> = Y.MOBILE.NO	;*8
	Y.VAL.REQ.LIST<-1> = Y.PASSWORD		;*9
	Y.VAL.REQ.LIST<-1> = Y.PIN			;*10
	Y.VAL.REQ.LIST<-1> = Y.DATETIME		;*11
	
	Y.TYPE = "ONLINE"
	CALL ATI.INTF.INBOUND.WS.PROCESS(Y.MAPPING, Y.FLD.REQ.LIST, Y.VAL.REQ.LIST, Y.TYPE, Y.RESPONSE, Y.FLD.RES.LIST, Y.VAL.RES.LIST, Y.MSG.ERR)
	
	IF NOT(Y.MSG.ERR) THEN
		FIND "MESSAGE" IN Y.FLD.RES.LIST SETTING POSF.RES THEN
			Y.MSG = Y.VAL.RES.LIST<POSF.RES>
		END
	END
	
	Y.MSG.ERR = ""
	IF Y.MSG NE "Success" AND Y.MSG NE "Berhasil" THEN
		Y.MSG.ERR = Y.MSG
		R.NEW(AB.CUS.CUST.REG.ERR.MSG) = Y.MSG
	END
	
	IF Y.MSG.ERR THEN
	   ETEXT = Y.MSG.ERR
	   AF    = AB.CUS.CUST.REG.ERR.MSG
	   CALL STORE.END.ERROR
	END
	
    RETURN
*-----------------------------------------------------------------------------
END
