*-----------------------------------------------------------------------------
* <Rating>-30</Rating>
* 02:36:55 15 NOV 2017 
* JFT/t24r11 
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.VID.STO.AC.SUB.CLOSE
*-----------------------------------------------------------------------------
* Developer Name     : ATI Juan Felix
* Development Date   : 20171115
* Description        : ID Routine for get STO ID
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date            Modified by                Description
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ATI.TH.INTF.ORK.DATA
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ATI.TH.EC.USERNAME
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
    FN.ACCOUNT = "F.ACCOUNT"
    CALL OPF(FN.ACCOUNT, F.ACCOUNT)

    FN.CUSTOMER = "F.CUSTOMER"
    CALL OPF(FN.CUSTOMER, F.CUSTOMER)

    FN.ATI.TH.EC.USERNAME = "F.ATI.TH.EC.USERNAME"
    CALL OPF(FN.ATI.TH.EC.USERNAME, F.ATI.TH.EC.USERNAME)

    FN.STO.ACCOUNT.LIST = "F.STO.ACCOUNT.LIST"
    CALL OPF(FN.STO.ACCOUNT.LIST, F.STO.ACCOUNT.LIST)

    FN.STANDING.ORDER = "F.STANDING.ORDER"
    CALL OPF(FN.STANDING.ORDER, F.STANDING.ORDER)

    RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    Y.AC.SUB.ID = COMI

    CALL F.READ(FN.ACCOUNT, Y.AC.SUB.ID, R.ACCOUNT, F.ACCOUNT, ERR.ACCOUNT)
    Y.CUSTOMER = R.ACCOUNT<AC.CUSTOMER>

    CALL F.READ(FN.CUSTOMER, Y.CUSTOMER, R.CUSTOMER, F.CUSTOMER, ERR.CUSTOMER)
    Y.EMAIL.1 = R.CUSTOMER<EB.CUS.EMAIL.1>

    CALL F.READ(FN.ATI.TH.EC.USERNAME, Y.EMAIL.1, R.ATI.TH.EC.USERNAME, F.ATI.TH.EC.USERNAME, ERR.ATI.TH.EC.USERNAME)
    Y.SAVING.AC = R.ATI.TH.EC.USERNAME<EC.USER.SAVING.AC>

    CALL F.READ(FN.STO.ACCOUNT.LIST, Y.SAVING.AC, R.STO.ACCOUNT.LIST, F.STO.ACCOUNT.LIST, ERR.STO.ACCOUNT.LIST)
    R.STO.ACCOUNT.CNT = DCOUNT(R.STO.ACCOUNT.LIST, FM)

    FOR I = 2 TO R.STO.ACCOUNT.CNT
        Y.SEQ = R.STO.ACCOUNT.LIST<I>

        Y.STANDING.ORDER.ID = Y.SAVING.AC : "." : Y.SEQ

        CALL F.READ(FN.STANDING.ORDER, Y.STANDING.ORDER.ID, R.STANDING.ORDER, F.STANDING.ORDER, ERR.STANDING.ORDER)
        Y.CPTY.ACCT.NO = R.STANDING.ORDER<STO.CPTY.ACCT.NO>

        IF Y.CPTY.ACCT.NO EQ Y.AC.SUB.ID THEN
            COMI = Y.STANDING.ORDER.ID
            BREAK
        END
    NEXT I

    RETURN
*-----------------------------------------------------------------------------
END