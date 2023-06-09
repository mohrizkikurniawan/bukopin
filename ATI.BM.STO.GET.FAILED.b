    SUBROUTINE ATI.BM.STO.GET.FAILED(Y.FT.ID)
*-----------------------------------------------------------------------------
* Developer Name     : 20171031
* Development Date   : ATI Julian Gerry
* Description        : Routine to update ATI.TH.STO.RETRY for failed payment
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date            Modified by                Description
*-----------------------------------------------------------------------------
* 20171205        Dwi K                      retry per period
* 20181026        Dwi K        				 closure sub account while failed last debit
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ATI.BM.STO.GET.FAILED.COMMON
    $INSERT I_F.ATI.TH.STO.RETRY
    $INSERT I_F.STANDING.ORDER
    $INSERT I_F.FT.APPL.DEFAULT
	$INSERT I_F.FUNDS.TRANSFER
	$INSERT I_F.ACCOUNT
	$INSERT I_F.ATI.TH.INTF.ORK.DATA

*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------

    GOSUB INIT
    GOSUB PROCESS

    RETURN
*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------

    R.FT.NAU = ''
    R.STO 	 = ''
    
    RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
	
    CALL F.READ (FN.FT.NAU, Y.FT.ID, R.FT.NAU, F.FT.NAU, FT.NAU.ERR)
    Y.ACCT.ID  = FIELDS(R.FT.NAU<FT.INWARD.PAY.TYPE>,'-',3,1)
    Y.STO.ID   = Y.ACCT.ID : '.' : FIELDS(R.FT.NAU<FT.INWARD.PAY.TYPE>,'-',4,1)
	Y.CR.AMT   = R.FT.NAU<FT.CREDIT.AMOUNT>
	Y.STO.DATE = R.FT.NAU<FT.LOCAL.REF,Y.ATI.STO.DATE.POS>
    
    CALL F.READ(FN.STO, Y.STO.ID, R.STO, F.STO, STO.ERR)
	Y.CO.CODE        = R.STO<STO.CO.CODE>
	Y.CURR.FREQ.DATE = R.STO<STO.CURR.FREQ.DATE>
	
    IF NOT(R.STO) THEN
*<20181026_DWK
		CALL F.READ.HISTORY(FN.STO.HIS, Y.STO.ID, R.STO.HIS, F.STO.HIS, STO.HIS.ERR)
		Y.CO.CODE      = R.STO.HIS<STO.CO.CODE>
        Y.CPTY.ACCT.NO = R.STO.HIS<STO.CPTY.ACCT.NO>
		
		CALL F.READ(FN.ACCOUNT, Y.CPTY.ACCT.NO, R.ACCOUNT, F.ACCOUNT, ACCT.ERR)
		Y.AUTO.CLOSE.FLAG = R.ACCOUNT<AC.LOCAL.REF, Y.ATI.AUTO.CLOSE.POS>
		
		IF Y.AUTO.CLOSE.FLAG EQ "Y" THEN
			Y.PRE.ID       = 'ORK'
			Y.UNIQUE.TIME  = ''
			CALL ALLOCATE.UNIQUE.TIME(Y.UNIQUE.TIME)
			Y.ATI.TH.INTF.ORK.DATA.ID = Y.PRE.ID:TODAY:Y.UNIQUE.TIME
			
			GOSUB BUILD.ORK.SUB.AC.CLS.NO.CHRG
			
			Y.ATI.TT.INTF.ORK.BKP.ID = Y.ATI.TH.INTF.ORK.DATA.ID:"_1"
			GOSUB WRITE.ORK.BKP
			
			CALL F.READ(FN.ATI.TH.STO.RETRY, Y.STO.ID, R.ATI.TH.STO.RETRY, F.ATI.TH.STO.RETRY, ATI.TH.STO.RETRY.ERR)
			IF R.ATI.TH.STO.RETRY THEN
				DELETE F.ATI.TH.STO.RETRY, Y.STO.ID
			END
		END
*>20181026_DWK
        RETURN
    END
	
    CALL F.READ(FN.STO.RETRY, Y.STO.ID, R.STO.RETRY, F.STO.RETRY, STO.RETRY.ERR)
    Y.DATE = R.STO.RETRY<STO.RET.DATE>

    FIND Y.STO.DATE IN Y.DATE SETTING YPOSF, YPOSV THEN
*		R.STO.RETRY<STO.RET.RETRY.CNT,YPOSV> += 1
*		R.STO.RETRY<STO.RET.FT.ID,YPOSV,-1>   = Y.FT.ID
*		
*		IF R.STO.RETRY<STO.RET.RETRY.CNT,YPOSV> EQ Y.ATI.STO.MAX.CTR THEN
*			GOSUB OFS.UPD.STO
*			GOSUB UPD.INACTIV.MARKER
*		END
    END ELSE
		R.STO.RETRY<STO.RET.DATE,-1>       = TODAY
		R.STO.RETRY<STO.RET.AMOUNT,-1>     = Y.CR.AMT
		R.STO.RETRY<STO.RET.RETRY.CNT,-1>  = 0
		R.STO.RETRY<STO.RET.STATUS,-1>     = "ERROR"
		R.STO.RETRY<STO.RET.FT.ID,-1>      = Y.FT.ID
	END
	
	R.STO.RETRY<STO.RET.NEXT.PERIODE> = Y.CURR.FREQ.DATE

    CALL F.WRITE(FN.STO.RETRY, Y.STO.ID, R.STO.RETRY)

    RETURN
*-----------------------------------------------------------------------------
OFS.UPD.STO:
*-----------------------------------------------------------------------------
    Y.OFS.MESSAGE = ''
    OFS.HDR       = ''
    OFS.DTL       = ''

    OFS.MSG  = "STANDING.ORDER,ATI.REVE/R/PROCESS,//" : Y.CO.CODE : "," : Y.STO.ID

    Y.OFS.MESSAGE = OFS.MSG
    GOSUB GEN.OFS
	
	RETURN
*-----------------------------------------------------------------------------
GEN.OFS:
*-----------------------------------------------------------------------------
    Y.OFS.SOURCE = "GENERIC.OFS.PROCESS"
	CALL OFS.INITIALISE.SOURCE(Y.OFS.SOURCE,"","LOG.ERROR")
    CALL OFS.BULK.MANAGER(Y.OFS.MESSAGE, Y.PROCESS.FLAG, "")

    RETURN
*-----------------------------------------------------------------------------
UPD.INACTIV.MARKER:
*-----------------------------------------------------------------------------
    CALL F.READ(FN.ACCOUNT, Y.ACCT.ID, R.ACCOUNT, F.ACCOUNT, ACCT.ERR)
	R.ACCOUNT<AC.INACTIV.MARKER> = "Y"
    CALL F.WRITE(FN.ACCOUNT, Y.AC.ID, R.ACCOUNT)

	RETURN
*-----------------------------------------------------------------------------
BUILD.ORK.SUB.AC.CLS.NO.CHRG:
*-----------------------------------------------------------------------------
	R.ATI.TH.INTF.ORK.DATA = ""
	
	R.ATI.TH.INTF.ORK.DATA<ORK.DATA.MAPPING>    = "SUB.AC.CLS.NO.CHRG"
	R.ATI.TH.INTF.ORK.DATA<ORK.DATA.FIELD, 1>   = "ACCOUNT"
	R.ATI.TH.INTF.ORK.DATA<ORK.DATA.VALUE, 1>   = Y.CPTY.ACCT.NO
	R.ATI.TH.INTF.ORK.DATA<ORK.DATA.FIELD, 2>   = "CLOSURE.REASON"
	R.ATI.TH.INTF.ORK.DATA<ORK.DATA.VALUE, 2>   = "STO CLOSE"
	R.ATI.TH.INTF.ORK.DATA<ORK.DATA.VALUE.DATE> = TODAY
	R.ATI.TH.INTF.ORK.DATA<ORK.DATA.USER>       = OPERATOR
	
	Y.TIME = OCONV(DATE(),"D-")
	Y.TIME.DT = TIME[9,2]:TIME[1,2]:TIME[4,2]:TIME.STAMP[1,2]:TIME.STAMP[4,2]
	
	R.ATI.TH.INTF.ORK.DATA<ORK.DATA.CURR.NO>    = 1
	R.ATI.TH.INTF.ORK.DATA<ORK.DATA.INPUTTER>   = OPERATOR
	R.ATI.TH.INTF.ORK.DATA<ORK.DATA.DATE.TIME>  = Y.TIME.DT
	R.ATI.TH.INTF.ORK.DATA<ORK.DATA.AUTHORISER> = OPERATOR
	R.ATI.TH.INTF.ORK.DATA<ORK.DATA.CO.CODE>    = Y.CO.CODE
	R.ATI.TH.INTF.ORK.DATA<ORK.DATA.DEPT.CODE>  = 1
	
	CALL F.WRITE(FN.ATI.TH.INTF.ORK.DATA, Y.ATI.TH.INTF.ORK.DATA.ID, R.ATI.TH.INTF.ORK.DATA)
	
	RETURN
	
*-----------------------------------------------------------------------------
WRITE.ORK.BKP:
*-----------------------------------------------------------------------------
	R.ATI.TT.INTF.ORK.BKP = ''
	CALL F.WRITE(FN.ATI.TT.INTF.ORK.BKP, Y.ATI.TT.INTF.ORK.BKP.ID, R.ATI.TT.INTF.ORK.BKP)
	
	RETURN
	
*-----------------------------------------------------------------------------
END











