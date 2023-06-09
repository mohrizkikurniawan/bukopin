*-----------------------------------------------------------------------------
* <Rating>-181</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.BM.AC.SETTLE.CLOSURE(Y.ARR.ID)
*-----------------------------------------------------------------------------
* Developer Name     : Dwi K
* Development Date   : 20180124
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
    $INSERT I_ATI.BM.AC.SETTLE.CLOSURE.COMMON
	$INSERT I_F.AA.SIMULATION.RUNNER

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

    CALL F.READ(FN.ATI.TT.AC.SIM.CLOSURE, Y.ARR.ID, R.ATI.TT.AC.SIM.CLOSURE, F.ATI.TT.AC.SIM.CLOSURE, ATI.TT.AC.SIM.CLOSURE.ERR)
	Y.SIM.CAPTURE.ID  = R.ATI.TT.AC.SIM.CLOSURE<1>
	Y.CO.CODE         = R.ATI.TT.AC.SIM.CLOSURE<2>
	
    CALL F.READ(FN.AA.SIMULATION.CAPTURE, Y.SIM.CAPTURE.ID, R.AA.SIMULATION.CAPTURE, F.AA.SIMULATION.CAPTURE, AA.SIM.CAP.ERR)
	Y.SIM.RUNNER.ID = R.AA.SIMULATION.CAPTURE<46>
	
	CALL F.READ(FN.AA.SIMULATION.RUNNER, Y.SIM.RUNNER.ID, R.AA.SIMULATION.RUNNER, F.AA.SIMULATION.RUNNER, AA.SIM.RUN.ERR)
	Y.STATUS = R.AA.SIMULATION.RUNNER<AA.SIM.STATUS>
	
	IF Y.STATUS EQ "EXECUTED - SUCCESSFULLY" THEN
	   GOSUB OFS.PROCESS
	END
	
    RETURN
*-----------------------------------------------------------------------------
OFS.PROCESS:
*-----------------------------------------------------------------------------
	Y.OFS.SOURCE  = "GENERIC.OFS.PROCESS"

	Y.OFS.MESSAGE = "FUNDS.TRANSFER,ATI.INTF.AC.SUB.CLOSE//PROCESS,//":Y.CO.CODE:",,DEBIT.ACCT.NO::=" : Y.ARR.ID
	
	CALL OFS.CALL.BULK.MANAGER(Y.OFS.SOURCE, Y.OFS.MESSAGE, Y.OFS.RESPONSE, Y.RESULT)
	
	Y.APP.ID        = Y.OFS.RESPONSE["/",1,1]
    Y.FLAG.OFS      = FIELD(Y.OFS.RESPONSE, ",", 1, 1)["/", 3, 1]
	
	IF Y.FLAG.OFS EQ "1" THEN
	   DELETE F.ATI.TT.AC.SIM.CLOSURE, Y.ARR.ID
	END
	
	RETURN
*-----------------------------------------------------------------------------
END




