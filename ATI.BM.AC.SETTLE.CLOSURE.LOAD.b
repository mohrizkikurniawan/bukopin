*-----------------------------------------------------------------------------
* <Rating>-181</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.BM.AC.SETTLE.CLOSURE.LOAD
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

*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------
    GOSUB INIT

    RETURN

*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
    FN.ATI.TT.AC.SIM.CLOSURE = 'F.ATI.TT.AC.SIM.CLOSURE'
    F.ATI.TT.SIM.CLOSURE  = ''
    CALL OPF(FN.ATI.TT.AC.SIM.CLOSURE,F.ATI.TT.AC.SIM.CLOSURE)

    FN.AA.SIMULATION.CAPTURE = 'F.AA.SIMULATION.CAPTURE'
    F.AA.SIMULATION.CAPTURE  = ''
    CALL OPF(FN.AA.SIMULATION.CAPTURE,F.AA.SIMULATION.CAPTURE)
	
    FN.AA.SIMULATION.RUNNER = 'F.AA.SIMULATION.RUNNER'
    F.AA.SIMULATION.RUNNER  = ''
    CALL OPF(FN.AA.SIMULATION.RUNNER,F.AA.SIMULATION.RUNNER)
	
    RETURN
*-----------------------------------------------------------------------------
END




