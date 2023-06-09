*-----------------------------------------------------------------------------
* <Rating>-30</Rating>
* 04:56:39 31 OCT 2017
* JFT/t24r11
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.TH.PLN.TRANS.RECEIPT.RECORD
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
    IF NOT(R.NEW(PLN.RCP.VALUE.DATE))THEN
        R.NEW(PLN.RCP.VALUE.DATE) = TODAY
    END
    
	Y.DATE = FIELD(TIMEDATE(), " ", 2, 99)
	Y.TIME = FIELD(TIMEDATE(), " ", 1)
	
	Y.DATE = OCONV(Y.DATE, 'MCT' )
	CONVERT " " TO "-" IN Y.DATE
	
    R.NEW(PLN.RCP.DATE.TIME.CREATE) = Y.DATE : " " : Y.TIME

    RETURN
*-----------------------------------------------------------------------------
END
