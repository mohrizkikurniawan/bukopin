*-----------------------------------------------------------------------------
    SUBROUTINE ATI.BM.CLR.FT.WTD.LOAD
*-----------------------------------------------------------------------------
* Developer Name     : Dwi K
* Development Date   : 20170606
* Description        : Routine 
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date               :
* Modified by        :
* Description        :
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ATI.BM.CLR.FT.WTD.COMMON

*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------
    GOSUB INIT

    RETURN

*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
    FN.ATI.TH.WTD.FT = 'F.ATI.TH.WTD.FT'
	F.ATI.TH.WTD.FT  = ''
	CALL OPF(FN.ATI.TH.WTD.FT, F.ATI.TH.WTD.FT)
	
    FN.ATI.TH.MSG.SERVICE = "F.ATI.TH.MSG.SERVICE"
    F.ATI.TH.MSG.SERVICE  = ""
    CALL OPF(FN.ATI.TH.MSG.SERVICE,F.ATI.TH.MSG.SERVICE)

    RETURN
*-----------------------------------------------------------------------------
END


