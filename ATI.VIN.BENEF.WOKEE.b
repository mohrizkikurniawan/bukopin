*-----------------------------------------------------------------------------
* <Rating>-32</Rating>
* 08:46:30 12 SEP 2017 * 16:10:45 30 AUG 2017
* JFT/t24r11 * JFT/t24r11
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.VIN.BENEF.WOKEE
*-----------------------------------------------------------------------------
* Developer Name     : ATI Juan Felix
* Development Date   : 20170830
* Description        : Input routine for check beneficiary
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date            Modified by                Description
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.BENEFICIARY
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.ATI.TH.INTF.GLOBAL.PARAM

*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------
    AF.TEMP = AF
    AV.TEMP = AV
    AS.TEMP = AS

    GOSUB INIT
    GOSUB PROCESS

    AF = AF.TEMP
    AV = AV.TEMP
    AS = AS.TEMP

    RETURN

*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
    FN.ACCOUNT = "F.ACCOUNT"
    CALL OPF(FN.ACCOUNT, F.ACCOUNT)

    FN.AA.ARRANGEMENT = "F.AA.ARRANGEMENT"
    CALL OPF(FN.AA.ARRANGEMENT, F.AA.ARRANGEMENT)

    FN.ATI.TH.INTF.GLOBAL.PARAM = "F.ATI.TH.INTF.GLOBAL.PARAM"
    CALL OPF(FN.ATI.TH.INTF.GLOBAL.PARAM, F.ATI.TH.INTF.GLOBAL.PARAM)

    FN.CUSTOMER.ACCOUNT = "F.CUSTOMER.ACCOUNT"
    CALL OPF(FN.CUSTOMER.ACCOUNT, F.CUSTOMER.ACCOUNT)

    RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    Y.OWNING.CUSTOMER = R.NEW(ARC.BEN.OWNING.CUSTOMER)
    Y.BEN.ACCT.NO     = R.NEW(ARC.BEN.BEN.ACCT.NO)

    CALL F.READ(FN.ATI.TH.INTF.GLOBAL.PARAM, "SYSTEM", R.ATI.TH.INTF.GLOBAL.PARAM, F.ATI.TH.INTF.GLOBAL.PARAM, ERR.ATI.TH.INTF.GLOBAL.PARAM)
    Y.MAIN.PRODUCT = R.ATI.TH.INTF.GLOBAL.PARAM<GLOBAL.PARAM.MAIN.PRODUCT>

*-Check account owning customer-----------------------------------------------
    CALL F.READ(FN.CUSTOMER.ACCOUNT, Y.OWNING.CUSTOMER, R.CUSTOMER.ACCOUNT, F.CUSTOMER.ACCOUNT, ERR.CUSTOMER.ACCOUNT)
    FIND Y.BEN.ACCT.NO IN R.CUSTOMER.ACCOUNT SETTING POSF, POSV, POSS THEN
        AF    = ""
        AV    = ""
        ETEXT = "EB-AC.SAME.CUSTOMER"
        CALL STORE.END.ERROR
    END

*-Check main account or not---------------------------------------------------
    CALL F.READ(FN.ACCOUNT, Y.BEN.ACCT.NO, R.ACCOUNT, F.ACCOUNT, ERR.ACCOUNT)
    IF R.ACCOUNT THEN
        Y.ARRANGEMENT.ID = R.ACCOUNT<AC.ARRANGEMENT.ID>

        CALL F.READ(FN.AA.ARRANGEMENT, Y.ARRANGEMENT.ID, R.AA.ARRANGEMENT, F.AA.ARRANGEMENT, ERR.AA.ARRANGEMENT)
        Y.PRODUCT = R.AA.ARRANGEMENT<AA.ARR.PRODUCT, 1>

        IF Y.PRODUCT NE Y.MAIN.PRODUCT THEN
            AF    = ""
            AV    = ""
            ETEXT = "EB-AC.NOT.SAVING"
            CALL STORE.END.ERROR		
        END
    END

    RETURN
*-----------------------------------------------------------------------------
END
