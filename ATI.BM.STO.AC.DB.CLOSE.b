    SUBROUTINE ATI.BM.STO.AC.DB.CLOSE(Y.ID)
*-----------------------------------------------------------------------------
* Developer Name     : 20180530
* Development Date   : Dhio
* Description        : Routine to close account STO Date Based
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ATI.BM.STO.AC.DB.CLOSE.COMMON
    $INSERT I_F.ATI.TT.STO.DB.CLOSE
    $INSERT I_F.ATI.TH.INTF.ORK.DATA
    $INSERT I_F.STANDING.ORDER


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
    
	Y.STO.ID       = FIELD(Y.ID, "*", 1)
	Y.CPTY.ACCT.NO = FIELD(Y.ID, "*", 2)
	
	CALL F.READ.HISTORY(FN.STANDING.ORDER.HIS, Y.STO.ID, R.STANDING.ORDER.HIS, F.STANDING.ORDER.HIS, STANDING.ORDER.HIS.ERR)
	
	IF R.STANDING.ORDER.HIS<STO.RECORD.STATUS> EQ "MAT" THEN
		Y.PRE.ID      = 'ORK'
		Y.UNIQUE.TIME = ''
		CALL ALLOCATE.UNIQUE.TIME(Y.UNIQUE.TIME)
		Y.ATI.TH.INTF.ORK.DATA.ID = Y.PRE.ID:TODAY:Y.UNIQUE.TIME
		
		GOSUB BUILD.ORK.SUB.AC.CLS.NO.CHRG
		
		Y.ATI.TT.INTF.ORK.BKP.ID = Y.ATI.TH.INTF.ORK.DATA.ID:"_1"
		GOSUB WRITE.ORK.BKP
	END
	
	CALL F.DELETE(FN.ATI.TT.STO.DB.CLOSE, Y.ID)
	
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
	R.ATI.TH.INTF.ORK.DATA<ORK.DATA.CO.CODE>    = R.STANDING.ORDER.HIS<STO.CO.CODE>
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











