*-----------------------------------------------------------------------------
* <Rating>-30</Rating>
* 08:36:06 18 JUL 2017 
* JFT/t24r11 
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.VIN.EC.USER.CUS.ONBOARD
*-----------------------------------------------------------------------------
* Developer Name     : ATI Juan Felix
* Development Date   : 20170718
* Description        : Input routine for EC username customer onboarding
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date            Modified by                Description
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ATI.TH.EC.USERNAME
    $INSERT I_F.CUSTOMER

*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------
    GOSUB INIT
    GOSUB PROCESS

    RETURN

*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
    FN.ATI.TH.EC.USERNAME = "F.ATI.TH.EC.USERNAME"
    CALL OPF(FN.ATI.TH.EC.USERNAME, F.ATI.TH.EC.USERNAME)

    FN.CUSTOMER = "F.CUSTOMER"
    CALL OPF(FN.CUSTOMER, F.CUSTOMER)

    Y.APP = "CUSTOMER"
    Y.FLD = "ATI.LEGACY.AC"
    CALL MULTI.GET.LOC.REF(Y.APP, Y.FLD, Y.POS)
    Y.ATI.LEGACY.AC.POS = Y.POS<1, 1>


    RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    Y.CUSTOMER = R.NEW(EC.USER.CUSTOMER)

    CALL F.READ(FN.CUSTOMER, Y.CUSTOMER, R.CUSTOMER, F.CUSTOMER, ERR.CUSTOMER)
    Y.ATI.LEGACY.AC = R.CUSTOMER<EB.CUS.LOCAL.REF, Y.ATI.LEGACY.AC.POS>

    IF NOT(Y.ATI.LEGACY.AC) THEN
        R.NEW(EC.USER.CUST.ONBOARD.STATUS) = "PENDING LEGACY"
    END
    ELSE
        R.NEW(EC.USER.CUST.ONBOARD.STATUS) = "DONE"
    END

    RETURN
*-----------------------------------------------------------------------------
END
