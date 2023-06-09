*-----------------------------------------------------------------------------
* <Rating>-181</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.BM.ACCT.ZERO.BAL(Y.AC.ID)
*-----------------------------------------------------------------------------
* Developer Name     : Dwi K
* Development Date   : 20171222
* Description        : Routine for
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date            Modified by                Description
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ATI.BM.ACCT.ZERO.BAL.COMMON
	$INSERT I_F.AA.ARRANGEMENT.ACTIVITY
	$INSERT I_F.ACCOUNT

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
    CALL F.READ(FN.ACCOUNT, Y.AC.ID, R.ACCOUNT, F.ACCOUNT, ACCT.ERR)
	Y.WORKING.BALANCE = R.ACCOUNT<AC.WORKING.BALANCE>
	Y.INACTIV.MARKER  = R.ACCOUNT<AC.INACTIV.MARKER>
	Y.ATI.LAST.ZERO   = R.ACCOUNT<AC.LOCAL.REF, Y.ATI.LAST.ZERO.POS>
	 
	BEGIN CASE
	CASE Y.ATI.LAST.ZERO AND Y.WORKING.BALANCE EQ 0 AND Y.INACTIV.MARKER EQ "Y"
		Y.FREQUENCY = "M01" :Y.ATI.LAST.ZERO[2]
		CALL MULTI.CFQ(Y.ATI.LAST.ZERO, Y.FREQUENCY, 1, Y.NEXT.MONTH)
		IF Y.NEXT.MONTH EQ TODAY THEN
			R.ACCOUNT<AC.LOCAL.REF, Y.ATI.ZERO.BAL.POS> += 1
			IF R.ACCOUNT<AC.LOCAL.REF, Y.ATI.ZERO.BAL.POS> EQ Y.CLOSE.ZERO.BAL THEN
			   GOSUB CLOSE.MAIN.AC
			END
		END
		
	CASE Y.WORKING.BALANCE EQ 0 AND Y.INACTIV.MARKER EQ "Y"
		R.ACCOUNT<AC.LOCAL.REF, Y.ATI.LAST.ZERO.POS> = TODAY
		
	CASE OTHERWISE
        R.ACCOUNT<AC.LOCAL.REF, Y.ATI.ZERO.BAL.POS>  = ""
		R.ACCOUNT<AC.LOCAL.REF, Y.ATI.LAST.ZERO.POS> = ""
		
	END CASE
    
	CALL F.WRITE(FN.ACCOUNT, Y.AC.ID, R.ACCOUNT)
	
    RETURN
*-----------------------------------------------------------------------------
CLOSE.MAIN.AC:
*-----------------------------------------------------------------------------
    R.AA.ARR.ACT.OFS<AA.ARR.ACT.ARRANGEMENT>  = Y.AC.ID
    R.AA.ARR.ACT.OFS<AA.ARR.ACT.ACTIVITY>     = "ACCOUNTS-CLOSE-ARRANGEMENT"
	R.AA.ARR.ACT.OFS<AA.ARR.ACT.REASON>       = "Zero Balance"
	
    Y.OFS.SOURCE     = "AA.COB"
    Y.APP.NAME       = "AA.ARRANGEMENT.ACTIVITY"
    Y.OFS.FUNCT      = "I"
    Y.PROCESS        = "PROCESS"
    Y.OFS.VERSION    = "AA.ARRANGEMENT.ACTIVITY,ATI.INTF.AC.SUB.CLOSE"
    Y.GTS.MODE       = 1
    Y.NO.OF.AUTH     = 0
    Y.TRANSACTION.ID = ""

    CALL OFS.BUILD.RECORD(Y.APP.NAME, Y.OFS.FUNCT, Y.PROCESS, Y.OFS.VERSION, Y.GTS.MODE, Y.NO.OF.AUTH, Y.TRANSACTION.ID, R.AA.ARR.ACT.OFS, Y.OFS.MESSAGE)

    CALL OFS.INITIALISE.SOURCE(Y.OFS.SOURCE, '', "LOG.ERROR")
	
    CALL OFS.BULK.MANAGER(Y.OFS.MESSAGE, Y.PROCESS.FLAG, '')

    RETURN
*-----------------------------------------------------------------------------
END




