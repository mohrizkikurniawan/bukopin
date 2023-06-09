*-----------------------------------------------------------------------------
* <Rating>-181</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.BM.RESEND.POST.BUKISYS(Y.OUT.TRANS.ID)
*-----------------------------------------------------------------------------
* Developer Name     : Dwi K
* Development Date   : 20190124
* Description        : Routine for resend posting journal Bukisys
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date            Modified by                Description
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
	$INSERT I_ATI.BM.RESEND.POST.BUKISYS.COMMON
	$INSERT I_F.ATI.TH.INTF.OUT.TRANSACTION
	$INSERT I_F.FUNDS.TRANSFER
	$INSERT I_F.ATI.TH.INTF.GLOBAL.PARAM

*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------
    GOSUB INIT
    GOSUB PROCESS

    RETURN

*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------

    RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------

    CALL F.READ(FN.ATI.TH.INTF.OUT.TRANSACTION, Y.OUT.TRANS.ID, R.ATI.TH.INTF.OUT.TRANSACTION, F.ATI.TH.INTF.OUT.TRANSACTION, ATI.TH.INTF.OUT.TRANSACTION.ERR)
	Y.APPLICATION    = R.ATI.TH.INTF.OUT.TRANSACTION<INTF.OUT.TRANS.APPLICATION>
	Y.APPLICATION.ID = R.ATI.TH.INTF.OUT.TRANSACTION<INTF.OUT.TRANS.APPLICATION.ID>
	Y.ERR.MSG        = R.ATI.TH.INTF.OUT.TRANSACTION<INTF.OUT.TRANS.ERR.MSG>
	Y.DATE.TIME.TRX  = R.ATI.TH.INTF.OUT.TRANSACTION<INTF.OUT.TRANS.DATE.TIME>
	
	Y.START.H    = Y.DATE.TIME.TRX[7,2] * 3600
	Y.START.M    = Y.DATE.TIME.TRX[9,2] * 60
	Y.START.TIME = Y.START.H + Y.START.M
	
    Y.DATE      = OCONV(DATE(),"D-")
    Y.TIME      = TIMEDATE()

	Y.H    = Y.TIME[1,2] * 3600
	Y.M    = Y.TIME[4,2] * 60
	Y.NOW  = Y.H + Y.M
	
	IF Y.DATE[4,2] NE Y.DATE.TIME.TRX[5,2] THEN
	   Y.END.DATE = Y.START.TIME + Y.RESEND.POST.TIME - 86400
    END ELSE
	   Y.END.TIME = Y.START.TIME + Y.RESEND.POST.TIME
	END
	
	IF (Y.APPLICATION EQ 'FUNDS.TRANSFER') AND (Y.DATE[4,2] EQ Y.DATE.TIME.TRX[5,2]) AND (Y.NOW GT Y.END.TIME) THEN
	   CALL F.READ(FN.FUNDS.TRANSFER, Y.APPLICATION.ID, R.FUNDS.TRANSFER, F.FUNDS.TRANSFER, FT.ERR)
	   Y.TRANSACTION.TYPE = R.FUNDS.TRANSFER<FT.TRANSACTION.TYPE>
	   
*	   FIND Y.TRANSACTION.TYPE IN Y.TRANSACTION.LIST SETTING YPOS.TRANS THEN
        IF Y.ERR.MSG NE '085' THEN
			GOSUB RESEND.JOURNAL
		END
*	   END
	   
	END
	
    RETURN
	
*-----------------------------------------------------------------------------
RESEND.JOURNAL:
*-----------------------------------------------------------------------------

    Y.DATE.TIME           = R.ATI.TH.INTF.OUT.TRANSACTION<INTF.OUT.TRANS.DATE.TIME>
    Y.LEG.PRO.CODE        = R.ATI.TH.INTF.OUT.TRANSACTION<INTF.OUT.TRANS.LEG.PRO.CODE>
	Y.AMOUNT              = R.ATI.TH.INTF.OUT.TRANSACTION<INTF.OUT.TRANS.AMOUNT>
    Y.PAYMENT.DETAILS     = R.ATI.TH.INTF.OUT.TRANSACTION<INTF.OUT.TRANS.PAYMENT.DETAILS>
    Y.USER                = R.ATI.TH.INTF.OUT.TRANSACTION<INTF.OUT.TRANS.USER>
    Y.APPLICATION.ID      = R.ATI.TH.INTF.OUT.TRANSACTION<INTF.OUT.TRANS.APPLICATION.ID>
    Y.DB.ACCOUNT          = R.ATI.TH.INTF.OUT.TRANSACTION<INTF.OUT.TRANS.DB.ACCOUNT>
    Y.CR.ACCOUNT          = R.ATI.TH.INTF.OUT.TRANSACTION<INTF.OUT.TRANS.CR.ACCOUNT>
	Y.AGENT.ID            = R.ATI.TH.INTF.OUT.TRANSACTION<INTF.OUT.TRANS.AGENT.ID>
	Y.OPERATION           = R.ATI.TH.INTF.OUT.TRANSACTION<INTF.OUT.TRANS.OPERATION>
	Y.USER.LEGACY.COMPANY = R.ATI.TH.INTF.OUT.TRANSACTION<INTF.OUT.TRANS.COMPANY>
	
    Y.PRO.CODE                  = R.ATI.TH.INTF.OUT.TRANSACTION<INTF.OUT.TRANS.PRO.CODE>
	Y.LIST.PROCODE.TRANSFER     = "MOVE.MONEY.WOKEE"
	Y.LIST.PROCODE.TRANSFER<-1> = "STANDING.ORDER"
	Y.LIST.PROCODE.TRANSFER<-1> = "MOVE.MONEY.SUB"
	
    Y.REQ.DATE.TIME = "20":Y.DATE.TIME[1,2]:"-":Y.DATE.TIME[3,2]:"-":Y.DATE.TIME[5,2]:"T":Y.DATE.TIME[7,2]:":":Y.DATE.TIME[9,2]:":00"

	CONVERT "." TO "" IN Y.AMOUNT
	
    Y.FLD.REQ.LIST<1>  = "REQ.DATE.TIME"
    Y.FLD.REQ.LIST<2>  = "TYPE"
    Y.FLD.REQ.LIST<3>  = "MTI"
    Y.FLD.REQ.LIST<4>  = "ELEMENT.03"
    Y.FLD.REQ.LIST<5>  = "ELEMENT.04"
    Y.FLD.REQ.LIST<6>  = "ELEMENT.10"
    Y.FLD.REQ.LIST<7>  = "ELEMENT.12"
    Y.FLD.REQ.LIST<8>  = "ELEMENT.13"
    Y.FLD.REQ.LIST<9>  = "ELEMENT.18"
    Y.FLD.REQ.LIST<10> = "ELEMENT.28"
    Y.FLD.REQ.LIST<11> = "ELEMENT.33"
    Y.FLD.REQ.LIST<12> = "ELEMENT.41"
    Y.FLD.REQ.LIST<13> = "ELEMENT.48"
    Y.FLD.REQ.LIST<14> = "ELEMENT.49"
    Y.FLD.REQ.LIST<15> = "ELEMENT.51"
    Y.FLD.REQ.LIST<16> = "ELEMENT.62"
    Y.FLD.REQ.LIST<17> = "ELEMENT.100"
    Y.FLD.REQ.LIST<18> = "ELEMENT.102"
    Y.FLD.REQ.LIST<19> = "ELEMENT.103"

    Y.FLD.REQ.LIST<20> = "ELEMENT.63"

    Y.FLD.REQ.LIST<21> = "CLIENT.TXN.ID"
	Y.FLD.REQ.LIST<22> = "USERID"

    Y.VAL.REQ.LIST<1>  = Y.REQ.DATE.TIME

	IF Y.OPERATION EQ "REVERSE" THEN
		Y.VAL.REQ.LIST<2>  = "REV"
		Y.VAL.REQ.LIST<3>  = "0400"
	END ELSE
		Y.VAL.REQ.LIST<2>  = "TRX"
		Y.VAL.REQ.LIST<3>  = "0200"
	END

    Y.VAL.REQ.LIST<4>  = Y.LEG.PRO.CODE
    Y.VAL.REQ.LIST<5>  = FMT(Y.AMOUNT, "R%20")
    Y.VAL.REQ.LIST<6>  = "0000000000000000000"
	
	IF Y.OPERATION EQ "REVERSE" THEN
		Y.VAL.REQ.LIST<7>  = Y.DATE.TIME[4]:"00"
	END ELSE
		Y.VAL.REQ.LIST<7>  = Y.DATE.TIME[6]
	END
    
    Y.VAL.REQ.LIST<8>  = Y.DATE.TIME[3,4]

	IF Y.AGENT.ID THEN
	   Y.VAL.REQ.LIST<9> = "6024"
	END ELSE
       FIND Y.PRO.CODE IN Y.LIST.PROCODE.TRANSFER SETTING POSF.PROCODE, POSV.PROCODE THEN
	       Y.VAL.REQ.LIST<9> = "6017"
	   END ELSE
           Y.VAL.REQ.LIST<9> = "6010"
	   END
	END
	
    Y.VAL.REQ.LIST<10> = "00000000000000000000"
    Y.VAL.REQ.LIST<11> = "441"
    Y.VAL.REQ.LIST<12> = Y.USER

    IF Y.AGENT.ID THEN
       Y.ELEMENT.48.1 = FMT(Y.PAYMENT.DETAILS[1,12] : " FT : " : Y.APPLICATION.ID : " " : Y.AGENT.ID, "L#40")       	
	END ELSE
	   Y.ELEMENT.48.1 = FMT(Y.PAYMENT.DETAILS[1,22] : " FT : " : Y.APPLICATION.ID, "L#40")
	END

    BEGIN CASE
    CASE Y.CR.ACCOUNT EQ "0000000000"
		Y.ELEMENT.48.2 = FMT("OVB DB : " :  Y.DB.ACCOUNT : " CR : 101010" : Y.USER.LEGACY.COMPANY , "L#40")
	CASE Y.DB.ACCOUNT EQ "0000000000"
		Y.ELEMENT.48.2 = FMT("OVB DB : 101010" : Y.USER.LEGACY.COMPANY : " CR : " : Y.CR.ACCOUNT  , "L#40")
	CASE OTHERWISE
		Y.ELEMENT.48.2 = FMT("OVB DB : " :  Y.DB.ACCOUNT : " CR : " : Y.CR.ACCOUNT, "L#40")
	END CASE
	
    Y.ELEMENT.48.3 = FMT(Y.USER, "L#60")

    Y.VAL.REQ.LIST<13> = Y.ELEMENT.48.1 : Y.ELEMENT.48.2 : Y.ELEMENT.48.3

    Y.VAL.REQ.LIST<14> = "360"
    Y.VAL.REQ.LIST<15> = "360"

	IF Y.OPERATION EQ "REVERSE" THEN
		Y.ELEMENT.62.1 = "00000000060000000000000000000000000000000000000000000000000000000000000000"
	END ELSE
		Y.ELEMENT.62.1 = "00000000050000000000000000000000000000000000000000000000000000000000000000"
	END

    Y.ELEMENT.62.2 = FMT(Y.USER, "L#15")
    Y.ELEMENT.62.3 = "00101"

    Y.VAL.REQ.LIST<16> = Y.ELEMENT.62.1 : Y.ELEMENT.62.2 : Y.ELEMENT.62.3

    Y.VAL.REQ.LIST<17> = "441"
    Y.VAL.REQ.LIST<18> = Y.DB.ACCOUNT
    Y.VAL.REQ.LIST<19> = Y.CR.ACCOUNT

    IF Y.OPERATION EQ "REVERSE" THEN
		IF (R.ATI.TH.INTF.OUT.TRANSACTION<INTF.OUT.TRANS.LEGACY.ID>) THEN
			Y.VAL.REQ.LIST<20>  = R.ATI.TH.INTF.OUT.TRANSACTION<INTF.OUT.TRANS.LEGACY.ID>[1,12] : "000000" : R.ATI.TH.INTF.OUT.TRANSACTION<INTF.OUT.TRANS.LEGACY.ID>[7]
		END
	END
	
    Y.VAL.REQ.LIST<21> = Y.APPLICATION.ID
	Y.VAL.REQ.LIST<22> = Y.USER

    CALL ATI.INTF.INBOUND.WS.PROCESS("BUKISYS.MIAPOSTING", Y.FLD.REQ.LIST, Y.VAL.REQ.LIST, "ONLINE", Y.RESPONSE, Y.FLD.RES.LIST, Y.VAL.RES.LIST, Y.MSG.ERR)

    FIND "ELEMENT.39" IN Y.FLD.RES.LIST SETTING POSF, POSV, POSS THEN
        Y.ELEMENT.39.VALUE = Y.VAL.RES.LIST<POSF>

        IF Y.ELEMENT.39.VALUE EQ "000" THEN
            R.ATI.TH.INTF.OUT.TRANSACTION<INTF.OUT.TRANS.STATUS>  = "SUCCESS"
			R.ATI.TH.INTF.OUT.TRANSACTION<INTF.OUT.TRANS.ERR.MSG> = ""
        END
        ELSE
            R.ATI.TH.INTF.OUT.TRANSACTION<INTF.OUT.TRANS.STATUS>  = "ERROR"
            R.ATI.TH.INTF.OUT.TRANSACTION<INTF.OUT.TRANS.ERR.MSG> = Y.ELEMENT.39.VALUE
        END
    END
    ELSE
        R.ATI.TH.INTF.OUT.TRANSACTION<INTF.OUT.TRANS.STATUS> = "ERROR"
		R.ATI.TH.INTF.OUT.TRANSACTION<INTF.OUT.TRANS.ERR.MSG>= Y.MSG.ERR
    END

    FIND "ELEMENT.48" IN Y.FLD.RES.LIST SETTING POSF, POSV, POSS THEN
        Y.ELEMENT.48.VALUE = Y.VAL.RES.LIST<POSF>
	
        R.ATI.TH.INTF.OUT.TRANSACTION<INTF.OUT.TRANS.LEGACY.ID> = Y.ELEMENT.48.VALUE[19]
    END

*	CALL F.WRITE(FN.ATI.TH.INTF.OUT.TRANSACTION, Y.OUT.TRANS.ID, R.ATI.TH.INTF.OUT.TRANSACTION)
    CALL ID.LIVE.WRITE(FN.ATI.TH.INTF.OUT.TRANSACTION, Y.OUT.TRANS.ID, R.ATI.TH.INTF.OUT.TRANSACTION)

    RETURN
	
*-----------------------------------------------------------------------------
END



