    SUBROUTINE ATI.BM.STO.AC.CLOSE(Y.STO.ID)
*-----------------------------------------------------------------------------
* Developer Name     : 20171118
* Development Date   : Dwi K
* Description        : Routine to close account STO
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date               : 20180418
* Modified by        : Dhio Faizar Wahyudi
* Description        : Change OFS to write ATI.TT.INTF.ORK.BKP
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ATI.BM.STO.AC.CLOSE.COMMON
    $INSERT I_F.STANDING.ORDER
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

    RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    CALL F.READ(FN.STANDING.ORDER, Y.STO.ID, R.STANDING.ORDER, F.STANDING.ORDER, STO.ERR)
	Y.CPTY.ACCT.NO = R.STANDING.ORDER<STO.CPTY.ACCT.NO>
	Y.CO.CODE      = R.STANDING.ORDER<STO.CO.CODE>
	
	CALL F.READ(FN.ACCOUNT, Y.CPTY.ACCT.NO, R.ACCOUNT, F.ACCOUNT, AC.ERR)
	Y.ATI.AUTO.CLOSE = R.ACCOUNT<AC.LOCAL.REF,Y.ATI.AUTO.CLOSE.POS>
	
    IF Y.ATI.AUTO.CLOSE EQ "Y" THEN
*<20180418_Dhio
		Y.PRE.ID      = 'ORK'
		Y.UNIQUE.TIME = ''
		CALL ALLOCATE.UNIQUE.TIME(Y.UNIQUE.TIME)
		Y.ATI.TH.INTF.ORK.DATA.ID = Y.PRE.ID:TODAY:Y.UNIQUE.TIME

		GOSUB BUILD.ORK.SUB.AC.CLS.NO.CHRG
		
		Y.ATI.TT.INTF.ORK.BKP.ID = Y.ATI.TH.INTF.ORK.DATA.ID:"_1"
		GOSUB WRITE.ORK.BKP
*>20180418_Dhio
	END
	
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











