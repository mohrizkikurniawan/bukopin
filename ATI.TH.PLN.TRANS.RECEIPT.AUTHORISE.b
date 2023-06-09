*-----------------------------------------------------------------------------
* <Rating>-50</Rating>
* 11:36:49 31 OCT 2017
* JFT/t24r11
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.TH.PLN.TRANS.RECEIPT.AUTHORISE
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
    RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    GOSUB GEN.PDF.FILE
	
    R.NEW(PLN.RCP.PDF.RECEIPT) = Y.PDF.FILE

    IF Y.ERROR.MESSAGE THEN
        AF    = ""
        ETEXT = Y.ERROR.MESSAGE
        CALL STORE.END.ERROR
        RETURN
    END

    GOSUB SEND.EMAIL

    RETURN

*-----------------------------------------------------------------------------
GEN.PDF.FILE:
*-----------------------------------------------------------------------------
    Y.PDF.MAPPING = R.NEW(PLN.RCP.PDF.MAPPING)

    MATBUILD R.APP FROM R.NEW

    CALL ATI.CONV.HTML2PDF.PROCESS(Y.PDF.MAPPING, APPLICATION, R.APP, Y.PDF.FILE, Y.ERROR.MESSAGE)

    RETURN

*-----------------------------------------------------------------------------
SEND.EMAIL:
*-----------------------------------------------------------------------------
    Y.TYPE = R.NEW(PLN.RCP.TYPE)

    BEGIN CASE
    CASE Y.TYPE EQ "PAYMENT"
        Y.MAPPING = "PLN.PAYMENT.RECEIPT"
    
    CASE Y.TYPE EQ "PURCHASE"
        Y.MAPPING = "PLN.PURCHASE.RECEIPT"
    END CASE
    
    Y.EMAIL = R.NEW(PLN.RCP.EMAIL)
	
	MATBUILD R.APP FROM R.NEW
    
    CALL ATI.EMAIL.SMS.WRITE("EMAIL", Y.MAPPING, "", Y.EMAIL, APPLICATION, "", R.APP, Y.ERROR)

    RETURN
*-----------------------------------------------------------------------------
END
