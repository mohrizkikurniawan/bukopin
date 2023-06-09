    SUBROUTINE ATI.BM.AB.AGENT.PROCESS.ADD.USER(Y.ID)
*-----------------------------------------------------------------------------
* Developer Name     : Fatkhur Rohman
* Development Date   : 20180711
* Description        : Subroutine to process add user agent
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date            Modified by                Description
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
	$INSERT I_F.EB.EXTERNAL.USER
	$INSERT I_F.ATI.TH.AB.AGENT
	$INSERT I_F.ATI.TH.INTF.INBOUND.WS.MAPPING
    $INSERT I_ATI.BM.AB.AGENT.PROCESS.ADD.USER.COMMON

*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------
    GOSUB INIT
    GOSUB PROCESS

    RETURN

*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
	Y.DATE     = OCONV(DATE(),"D-")

    RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    Y.AGENT.ID = Y.ID
	CALL F.READU(FN.ATI.TH.AB.AGENT, Y.AGENT.ID, R.ATI.TH.AB.AGENT, F.ATI.TH.AB.AGENT, ERR.ATI.TH.AB.AGENT, "")
	
	Y.AGENT.NAME            = R.ATI.TH.AB.AGENT<AB.AGN.NAME>
	Y.AGENT.CUSTOMER        = R.ATI.TH.AB.AGENT<AB.AGN.CUSTOMER.ID>
	Y.AGENT.EMAIL           = R.ATI.TH.AB.AGENT<AB.AGN.EMAIL>
	Y.AGENT.MOBILE.NO       = R.ATI.TH.AB.AGENT<AB.AGN.MOBILE.NO>
	Y.AGENT.EB.EXT.USER     = R.ATI.TH.AB.AGENT<AB.AGN.EB.EXT.USER>
	Y.AGENT.USER.REG.STATUS = R.ATI.TH.AB.AGENT<AB.AGN.USER.REG.STATUS>
	
	GOSUB GET.DEFAULT.EXT.USER.RECD
	
	Y.USER.CNT = DCOUNT(Y.AGENT.EB.EXT.USER, @VM)
	
	FOR Y.A=2 TO Y.USER.CNT
		IF Y.AGENT.USER.REG.STATUS<1, Y.A> EQ 'DONE' THEN
			CONTINUE
		END
		
		Y.AGENT.USER.ID = Y.AGENT.EB.EXT.USER<1, Y.A>
		
		GOSUB GENERATE.PASSWORD.PIN
		GOSUB CREATE.EB.EXTERNAL.USER
		GOSUB CREATE.AGENT.USER.CENTAGATE
		
		R.ATI.TH.AB.AGENT<AB.AGN.PASSWORD, Y.A>         = Y.PASSWORD
		R.ATI.TH.AB.AGENT<AB.AGN.PIN, Y.A>              = Y.PIN
		R.ATI.TH.AB.AGENT<AB.AGN.USER.STATUS, Y.A>      = Y.USER.STATUS
		R.ATI.TH.AB.AGENT<AB.AGN.USER.REG.STATUS, Y.A>  = Y.USER.REG.STS
		R.ATI.TH.AB.AGENT<AB.AGN.USER.REG.ERR.MSG, Y.A> = Y.USER.ERR.MSG
		
	NEXT Y.A
	
	CALL F.WRITE(FN.ATI.TH.AB.AGENT, Y.AGENT.ID, R.ATI.TH.AB.AGENT)
	CALL F.RELEASE(FN.ATI.TH.AB.AGENT, Y.AGENT.ID, F.ATI.TH.AB.AGENT)

    RETURN
	
*-----------------------------------------------------------------------------
GET.DEFAULT.EXT.USER.RECD:
*-----------------------------------------------------------------------------
	Y.AGENT.1ST.USER.ID = "U":Y.AGENT.ID:"01"
	CALL F.READ(FN.EB.EXTERNAL.USER, Y.AGENT.1ST.USER.ID, R.DEFT.USER, F.EB.EXTERNAL.USER, ERR.EB.EXTERNAL.USER)
	
	Y.EXT.USR.NAME                = R.DEFT.USER<EB.XU.NAME>
	Y.EXT.USR.CUSTOMER            = R.DEFT.USER<EB.XU.CUSTOMER>
	Y.EXT.USR.COMPANY             = R.DEFT.USER<EB.XU.COMPANY>
	Y.EXT.USR.CHANNEL             = R.DEFT.USER<EB.XU.CHANNEL>
	Y.EXT.USR.STATUS              = 'ACTIVE'
	Y.EXT.USR.ARRANGEMENT         = R.DEFT.USER<EB.XU.ARRANGEMENT>
	Y.EXT.USR.ALLOWED.CUSTOMER    = R.DEFT.USER<EB.XU.ALLOWED.CUSTOMER>
	Y.EXT.USR.CHANNEL.PERMISSION  = R.DEFT.USER<EB.XU.CHANNEL.PERMISSION>
	Y.EXT.USR.START.DATE          = Y.DATE[7,4]:Y.DATE[1,2]:Y.DATE[4,2]
	Y.EXT.USR.END.DATE            = R.DEFT.USER<EB.XU.END.DATE>
	Y.EXT.USR.START.TIME          = R.DEFT.USER<EB.XU.START.TIME>
	Y.EXT.USR.END.TIME            = R.DEFT.USER<EB.XU.END.TIME>
	Y.EXT.USR.USER.TYPE           = R.DEFT.USER<EB.XU.USER.TYPE>
	Y.EXT.USR.AUTHENTICATION.TYPE = R.DEFT.USER<EB.XU.AUTHENTICATION.TYPE>
	Y.EXT.USR.ATTRIBUTES          = 'PREAUTHENTICATED'
	Y.EXT.USR.LANGUAGE            = R.DEFT.USER<EB.XU.LANGUAGE>
	Y.EXT.USR.DATE.FORMAT         = R.DEFT.USER<EB.XU.DATE.FORMAT>
	
	RETURN
	
*-----------------------------------------------------------------------------
GENERATE.PASSWORD.PIN:
*-----------------------------------------------------------------------------
*-Generate Password-----------------------------------------------------------
    CALL ATI.GEN.EC.PASS.PIN("PASSWORD", Y.PASSWORD)

*-Generate PIN----------------------------------------------------------------
    CALL ATI.GEN.EC.PASS.PIN("PIN", Y.PIN)
	
	CALL ATI.ENC.DEC.PASS.PIN(Y.PASSWORD, "DECRYPT", Y.PASS.DECRYPT)
	CALL ATI.ENC.DEC.PASS.PIN(Y.PIN, "DECRYPT", Y.PIN.DECRYPT)

	RETURN
	
*-----------------------------------------------------------------------------
CREATE.EB.EXTERNAL.USER:
*-----------------------------------------------------------------------------
	CALL F.READ(FN.EB.EXTERNAL.USER, Y.AGENT.USER.ID, R.EB.EXTERNAL.USER, F.EB.EXTERNAL.USER, ERR.EB.EXTERNAL.USER)
	
	IF NOT(R.EB.EXTERNAL.USER) THEN
		R.EB.EXTERNAL.USER<EB.XU.NAME>                  = Y.EXT.USR.NAME
		R.EB.EXTERNAL.USER<EB.XU.CUSTOMER>              = Y.EXT.USR.CUSTOMER
		R.EB.EXTERNAL.USER<EB.XU.COMPANY>               = Y.EXT.USR.COMPANY
		R.EB.EXTERNAL.USER<EB.XU.CHANNEL, 1>            = Y.EXT.USR.CHANNEL
		R.EB.EXTERNAL.USER<EB.XU.STATUS, 1>             = Y.EXT.USR.STATUS
		R.EB.EXTERNAL.USER<EB.XU.ARRANGEMENT, 1>        = Y.EXT.USR.ARRANGEMENT
		R.EB.EXTERNAL.USER<EB.XU.ALLOWED.CUSTOMER, 1>   = Y.EXT.USR.ALLOWED.CUSTOMER
		R.EB.EXTERNAL.USER<EB.XU.CHANNEL.PERMISSION, 1> = Y.EXT.USR.CHANNEL.PERMISSION
		R.EB.EXTERNAL.USER<EB.XU.START.DATE, 1>         = Y.EXT.USR.START.DATE
		R.EB.EXTERNAL.USER<EB.XU.END.DATE, 1>           = Y.EXT.USR.END.DATE
		R.EB.EXTERNAL.USER<EB.XU.START.TIME, 1, 1>      = Y.EXT.USR.START.TIME
		R.EB.EXTERNAL.USER<EB.XU.END.TIME, 1, 1>        = Y.EXT.USR.END.TIME
		R.EB.EXTERNAL.USER<EB.XU.USER.TYPE, 1>          = Y.EXT.USR.USER.TYPE
		R.EB.EXTERNAL.USER<EB.XU.AUTHENTICATION.TYPE>   = Y.EXT.USR.AUTHENTICATION.TYPE
		R.EB.EXTERNAL.USER<EB.XU.ATTRIBUTES, 1>         = Y.EXT.USR.ATTRIBUTES
		R.EB.EXTERNAL.USER<EB.XU.LANGUAGE>              = Y.EXT.USR.LANGUAGE
		R.EB.EXTERNAL.USER<EB.XU.DATE.FORMAT>           = Y.EXT.USR.DATE.FORMAT
		
		CALL ID.LIVE.WRITE(FN.EB.EXTERNAL.USER, Y.AGENT.USER.ID, R.EB.EXTERNAL.USER)
	END
	
	RETURN
	
*-----------------------------------------------------------------------------
CREATE.AGENT.USER.CENTAGATE:
*-----------------------------------------------------------------------------
	Y.DATETIME = Y.DATE[4] : "-" : Y.DATE[1,2] : "-" : Y.DATE[4,2] : "T" : OCONV( TIME(), 'MTS' ) : "." : FMT(Y.A, "R%2")

	Y.NAME = Y.AGENT.NAME<1,1>
	CONVERT Y.EXP.CHARS TO '' IN Y.NAME
	Y.NAME = TRIM(Y.NAME, "", "D")
	
    Y.MAPPING = "BT.AGENT.USER.REGISTER"
    CALL F.READ(FN.ATI.TH.INTF.INBOUND.WS.MAPPING, Y.MAPPING, R.ATI.TH.INTF.INBOUND.WS.MAPPING, F.ATI.TH.INTF.INBOUND.WS.MAPPING, ATI.TH.INTF.INBOUND.WS.MAPPING.ERR)
	Y.FLD.REQ.LIST = R.ATI.TH.INTF.INBOUND.WS.MAPPING<INTF.IN.MAP.FLD.REQ>
	Y.FLD.RES.LIST = R.ATI.TH.INTF.INBOUND.WS.MAPPING<INTF.IN.MAP.FLD.RES>
	
	CONVERT VM TO FM IN Y.FLD.REQ.LIST
	CONVERT VM TO FM IN Y.FLD.RES.LIST
	
	Y.VAL.REQ.LIST     = Y.NAME                     ;*1
	Y.VAL.REQ.LIST<-1> = Y.NAME                     ;*2
	Y.VAL.REQ.LIST<-1> = Y.AGENT.USER.ID	        ;*3
	Y.VAL.REQ.LIST<-1> = Y.AGENT.USER.ID	        ;*4
	Y.VAL.REQ.LIST<-1> = Y.AGENT.USER.ID	        ;*5
	Y.VAL.REQ.LIST<-1> = Y.AGENT.USER.ID	        ;*6
	Y.VAL.REQ.LIST<-1> = Y.AGENT.EMAIL		        ;*7
	Y.VAL.REQ.LIST<-1> = Y.AGENT.MOBILE.NO	        ;*8
	Y.VAL.REQ.LIST<-1> = Y.PASS.DECRYPT	            ;*9
	Y.VAL.REQ.LIST<-1> = Y.PIN.DECRYPT              ;*10
	Y.VAL.REQ.LIST<-1> = Y.DATETIME		            ;*11
	
	Y.TYPE = "ONLINE"
	CALL ATI.INTF.INBOUND.WS.PROCESS(Y.MAPPING, Y.FLD.REQ.LIST, Y.VAL.REQ.LIST, Y.TYPE, Y.RESPONSE, Y.FLD.RES.LIST, Y.VAL.RES.LIST, Y.MSG.ERR)
	
	IF NOT(Y.MSG.ERR) THEN
		FIND "MESSAGE" IN Y.FLD.RES.LIST SETTING POSF.RES THEN
			Y.MSG = Y.VAL.RES.LIST<POSF.RES>
		END
	END
	
	IF Y.MSG NE "Success" AND Y.MSG NE "Berhasil" THEN
		Y.USER.STATUS  = ""
		Y.USER.REG.STS = "ERROR"
		Y.USER.ERR.MSG = Y.MSG
	END ELSE
		Y.USER.STATUS  = "ACTIVE"
		Y.USER.REG.STS = "DONE"
		Y.USER.ERR.MSG = ""
		
		GOSUB SEND.MAIL.NOTIFICATION
	END
	
	RETURN

*-----------------------------------------------------------------------------
SEND.MAIL.NOTIFICATION:
*-----------------------------------------------------------------------------
	Y.CUSTOMER = Y.AGENT.CUSTOMER
	
	Y.TO  = Y.AGENT.EMAIL
    Y.APP = "ATI.TH.AB.AGENT"
	R.APP = R.ATI.TH.AB.AGENT
	
*replace multivalue eb.ext.user to single value
    R.APP<AB.AGN.EB.EXT.USER> = Y.AGENT.USER.ID
    R.APP<AB.AGN.PASSWORD>    = Y.PASSWORD
    R.APP<AB.AGN.PIN>         = Y.PIN
	
	CALL ATI.EMAIL.SMS.WRITE("EMAIL", "AGENT.ADD.USER", Y.CUSTOMER, Y.TO, Y.APP, "", R.APP, Y.ERROR)
	
	RETURN
	
*-----------------------------------------------------------------------------
END
