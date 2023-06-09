*-----------------------------------------------------------------------------
* <Rating>-30</Rating>
* 14:11:00 15 FEB 2018 
* JFT/t24r11 
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.VID.CUS.ONBOARD.INP.KYC
*-----------------------------------------------------------------------------
* Developer Name     : ATI Juan Felix
* Development Date   : 20180215
* Description        : ID Routine for validation KYC Customer onboarding
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date            Modified by                Description
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
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
    FN.ATI.TH.INTF.ORK.DATA = "F.ATI.TH.INTF.ORK.DATA"
    CALL OPF(FN.ATI.TH.INTF.ORK.DATA, F.ATI.TH.INTF.ORK.DATA)

    RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    CALL F.READ(FN.ATI.TH.INTF.ORK.DATA, COMI, R.ATI.TH.INTF.ORK.DATA, F.ATI.TH.INTF.ORK.DATA, ERR.ATI.TH.INTF.ORK.DATA)
    Y.STATUS = R.ATI.TH.INTF.ORK.DATA<ORK.DATA.STATUS>

    IF Y.STATUS NE "PENDING" THEN
        E = "EB-ATI.CUS.ONBOARD.KYC.NO.PENDING"
    END

    RETURN
*-----------------------------------------------------------------------------
END


