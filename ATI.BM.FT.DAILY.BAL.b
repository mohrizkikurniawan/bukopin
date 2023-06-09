    SUBROUTINE ATI.BM.FT.DAILY.BAL(Y.ID)
*-----------------------------------------------------------------------------
* Developer Name     : 20160204
* Development Date   : Novi Leo
* Description        : Routine for daily balance
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date               : 20160902
* Modified by        : AYUNISA MINDARI
*-----------------------------------------------------------------------------
* Date               : 20170620
* Modified by        : Natasha
* Description        : Removing process for CTR and updating ATI.SYSTAXABLE
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ATI.BM.FT.DAILY.BAL.COMMON
    $INSERT I_F.ACCOUNT
    $INSERT I_F.ATI.TL.DAILY.BAL
    $INSERT I_F.DATES
	$INSERT I_F.AA.CUSTOMER.ARRANGEMENT
	$INSERT I_F.AA.ARRANGEMENT

*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------

    GOSUB INIT
    GOSUB PROCESS

    RETURN
*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
	
	Y.ARR.LIST  = ""
    Y.TEMP.LWORK = Y.LWORK.DAY
    
    RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------

    CALL F.READ(FN.CUST.ARR, Y.ID, R.CUST.ARR, F.CUST.ARR, CUST.ARR.ERR)
	LOCATE "ACCOUNTS" IN R.CUST.ARR<AA.CUSARR.PRODUCT.LINE, 1> SETTING Y.POSV THEN
		Y.ARR.LIST = R.CUST.ARR<AA.CUSARR.ARRANGEMENT, Y.POSV>
	END ELSE
		RETURN
	END
		
	Y.ARR.CNT = DCOUNT(Y.ARR.LIST, SM)
	
	FOR I = 1 TO Y.ARR.CNT
		Y.ARR.ID = Y.ARR.LIST<1, 1, I>
		CALL F.READ(FN.AA.ARR, Y.ARR.ID, R.AA.ARR, F.AA.ARR, AA.ARR.ERR)
		Y.AC.ID = R.AA.ARR<AA.ARR.LINKED.APPL.ID>
		
		CALL F.READ(FN.AC, Y.AC.ID, R.AC, F.AC, AC.ERR)
		IF R.AC<AC.INACTIV.MARKER> EQ "Y" THEN
			CONTINUE
		END
	    Y.SEL.ID    = Y.TEMP.LWORK[1,6]:"*":Y.AC.ID
		GOSUB WRT.FT.BAL
	NEXT I

    RETURN

*-----------------------------------------------------------------------------
WRT.FT.BAL:
*-----------------------------------------------------------------------------
	
    Y.OPEN.BAL = R.AC<AC.WORKING.BALANCE>
    Y.AC.CATEG = R.AC<AC.CATEGORY>
    Y.CUST     = R.AC<AC.CUSTOMER>
    Y.AC.CUR   = R.AC<AC.CURRENCY>

    CALL F.READ(FN.DAILY.BAL,Y.SEL.ID,R.DAILY.BAL,F.DAILY.BAL,DAILY.BAL.ERR)
    
	Y.DAYS = "C"
    CALL CDD("", Y.TEMP.LWORK, Y.TODAY, Y.DAYS)
	Y.DAYS = ABS(Y.DAYS)
	
	FOR J = 1 TO Y.DAYS
		R.DAILY.BAL<DBAL.DATE,-1>    = Y.TEMP.LWORK[2]
    	R.DAILY.BAL<DBAL.BALANCE,-1> = Y.OPEN.BAL
		Y.DAY = "+1C"
		CALL CDT("", Y.TEMP.LWORK, Y.DAY)
	NEXT J

    WRITE R.DAILY.BAL TO F.DAILY.BAL, Y.SEL.ID
	RETURN
	
*-----------------------------------------------------------------------------
END










