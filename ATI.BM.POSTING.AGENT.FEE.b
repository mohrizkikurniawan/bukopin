*-----------------------------------------------------------------------------
* <Rating>-1</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.BM.POSTING.AGENT.FEE(Y.ID)
*-----------------------------------------------------------------------------
* Developer Name     : Dwi K
* Development Date   : 20180725
* Description        : Routine to post agent fee
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date            Modified by                Description
*-----------------------------------------------------------------------------
* 20181127        Fatkhur Rohman             Add spare time 4 minutes
*                                            before creating agent fee journal
*                                            after authorise transaction time
* 20190506		  Dwi K						 Add ref id for agent statement
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
	$INSERT I_F.ATI.TH.AB.BTUNAI.CASHWD.RSV
    $INSERT I_ATI.BM.POSTING.AGENT.FEE.COMMON
	
*-----------------------------------------------------------------------------	
MAIN:
*-----------------------------------------------------------------------------

	GOSUB INIT
	GOSUB PROCESS
	
	RETURN
*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
	
	Y.DATE      = OCONV(DATE(),"D-")
    Y.TIME      = TIMEDATE()
    Y.DATE.TIME = Y.DATE[9,2]:Y.DATE[1,2]:Y.DATE[4,2]:Y.TIME[1,2]:Y.TIME[4,2]:Y.TIME[7,2]
	
	RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------

    CALL F.READU(FN.ATI.TH.AB.BTUNAI.CASHWD.RSV, Y.ID, R.ATI.TH.AB.BTUNAI.CASHWD.RSV, F.ATI.TH.AB.BTUNAI.CASHWD.RSV, ERR.ATI.TH.AB.BTUNAI.CASHWD.RSV, '')
	Y.AGN.ACCT.NO    = R.ATI.TH.AB.BTUNAI.CASHWD.RSV<AB.WTD.RSV.AGN.ACCT.NO>
	Y.AGN.FEE.AMT    = R.ATI.TH.AB.BTUNAI.CASHWD.RSV<AB.WTD.RSV.AGN.FEE.AMT>
	Y.AUTH.BRANCH.ID = R.ATI.TH.AB.BTUNAI.CASHWD.RSV<AB.WTD.RSV.AUTH.BRANCH.ID>
*/20180831
	Y.AUTH.AGENT.ID  = R.ATI.TH.AB.BTUNAI.CASHWD.RSV<AB.WTD.RSV.AUTH.AGENT.ID>
*\20180831
    Y.STATUS         = R.ATI.TH.AB.BTUNAI.CASHWD.RSV<AB.WTD.RSV.STATUS>

	IF Y.STATUS EQ "AUTHORISED" THEN
	
*/20181127
		Y.AUTH.DATE.TIME = R.ATI.TH.AB.BTUNAI.CASHWD.RSV<AB.WTD.RSV.AUTH.DATE.TIME>
		Y.AUTH.DATE      = Y.AUTH.DATE.TIME[1,6]
		Y.AUTH.TIME      = Y.AUTH.DATE.TIME[7,6]
		
		PRECISION 0
		Y.START.H    = Y.AUTH.TIME[1,2] * 3600
		Y.START.M    = Y.AUTH.TIME[3,2] * 60
		Y.START.TIME = Y.START.H + Y.START.M

*Add spare time 4 minutes
		Y.END.TIME = Y.START.TIME + 240
		Y.END.H    = Y.END.TIME/3600
		Y.END.MOD  = MOD(Y.END.TIME, 3600)
		Y.END.M    = Y.END.MOD/60

		IF Y.END.H GE 24 THEN
			Y.END.H = "00"
			Y.AUTH.DATE = "20":Y.AUTH.DATE
		
			CALL CDT("", Y.AUTH.DATE, "+1C")
		END
		
		Y.CJ.DATE.TIME = Y.AUTH.DATE:FMT(Y.END.H, "R%2"):FMT(Y.END.M, "R%2"):Y.AUTH.TIME[2]
		
		IF Y.DATE.TIME GE Y.CJ.DATE.TIME THEN
			GOSUB OFS.PROCESS
		END
*\20181127

	END
	
	CALL F.RELEASE(FN.ATI.TH.AB.BTUNAI.CASHWD.RSV, Y.ID, F.ATI.TH.AB.BTUNAI.CASHWD.RSV)
	
	RETURN
*-----------------------------------------------------------------------------
OFS.PROCESS:
*-----------------------------------------------------------------------------

    Y.OFS.MSG.APPL  = 'FUNDS.TRANSFER,ATI.POST.AGN.FEE':'/I/PROCESS,//'
    Y.OFS.SOURCE    = "GENERIC.OFS.PROCESS"
    Y.OFFLINE.FLAG  = ""
	Y.OFS.LOG.ERROR = "LOG ERROR"
	
	CALL OFS.INITIALISE.SOURCE(Y.OFS.SOURCE,Y.OFFLINE.FLAG,Y.OFS.LOG.ERROR)
	
    CALL.INFO    = ""
    CALL.INFO<1> = Y.OFS.SOURCE
    CALL.INFO<4> = "HLD"
    Y.FT.ID      = ""
    Y.CO.CODE    = Y.AUTH.BRANCH.ID

    Y.OFS.MSG.DATA  = "DEBIT.ACCT.NO::="     : "PL" : Y.PL.CATEG.FEE
    Y.OFS.MSG.DATA := ",DEBIT.AMOUNT::="      : Y.AGN.FEE.AMT
    Y.OFS.MSG.DATA := ",CREDIT.ACCT.NO::="    : Y.AGN.ACCT.NO
*/20180831
	Y.OFS.MSG.DATA := ",ATI.AGENT.ID::=" : Y.AUTH.AGENT.ID
*\20180831

*/20190506
    Y.OFS.MSG.DATA := ",ATI.REF.ID::=" :Y.ID
*/20190506

    Y.OFS.MESSAGE = Y.OFS.MSG.APPL : Y.CO.CODE :',': Y.FT.ID :',': Y.OFS.MSG.DATA

    CALL OFS.CALL.BULK.MANAGER(CALL.INFO,Y.OFS.MESSAGE,Y.PROCESS.FLAG,"")
    SENSITIVITY  = ""
	
	CHANGE "<requests><request>" TO "" IN Y.PROCESS.FLAG
	
    Y.OFS.OUT  = Y.PROCESS.FLAG
    Y.FT.ID    = Y.OFS.OUT['/',1,1]
	Y.FLAG.OFS = FIELD(Y.OFS.OUT,',',1,1)['/',3,1]
	
    R.ATI.TH.AB.BTUNAI.CASHWD.RSV<AB.WTD.RSV.FT.ID.FEE> = Y.FT.ID
	
	IF Y.FLAG.OFS EQ '-1' THEN
	   R.ATI.TH.AB.BTUNAI.CASHWD.RSV<AB.WTD.RSV.JOURNAL.FEE.STS> = "ERROR"
	END ELSE
	   R.ATI.TH.AB.BTUNAI.CASHWD.RSV<AB.WTD.RSV.JOURNAL.FEE.STS> = "PROCESSED"
	END
	
	CALL F.WRITE(FN.ATI.TH.AB.BTUNAI.CASHWD.RSV, Y.ID, R.ATI.TH.AB.BTUNAI.CASHWD.RSV)
		
	RETURN
*-----------------------------------------------------------------------------
END


