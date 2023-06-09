*-----------------------------------------------------------------------------
* <Rating>-30</Rating>
* 04:56:39 31 OCT 2017
* JFT/t24r11
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.TH.PLN.TRANS.RECEIPT.VALIDATE
*-----------------------------------------------------------------------------
* Developer Name     : ATI Juan Felix
* Development Date   : 20171031
* Description        : Template Table ATI.TH.PLN.TRANS.RECEIPT
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date            Modified by                Description
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ATI.TH.PLN.TRANS.RECEIPT

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

    RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    Y.ACCOUNT = R.NEW(PLN.RCP.ACCOUNT)

    CALL F.READ(FN.ACCOUNT, Y.ACCOUNT, R.ACCOUNT, F.ACCOUNT, ERR.ACCOUNT)
    Y.CUSTOMER = R.ACCOUNT<AC.CUSTOMER>

    CALL F.READ(FN.CUSTOMER, Y.CUSTOMER, R.CUSTOMER, F.CUSTOMER, ERR.CUSTOMER)
    Y.EMAIL = R.CUSTOMER<EB.CUS.EMAIL.1>

    R.NEW(PLN.RCP.CUSTOMER) = Y.CUSTOMER
    R.NEW(PLN.RCP.EMAIL)    = Y.EMAIL

    RETURN
*-----------------------------------------------------------------------------
END
