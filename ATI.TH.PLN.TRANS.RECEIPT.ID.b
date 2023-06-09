*-----------------------------------------------------------------------------
* <Rating>70</Rating>
* 04:43:28 31 OCT 2017 
* JFT/t24r11 
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.TH.PLN.TRANS.RECEIPT.ID
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
    IF V$FUNCTION NE "I" THEN RETURN

    GOSUB INIT
    GOSUB PROCESS

    RETURN

*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
    FN.ATI.TH.PLN.TRANS.RECEIPT = "F.ATI.TH.PLN.TRANS.RECEIPT"
    CALL OPF(FN.ATI.TH.PLN.TRANS.RECEIPT, F.ATI.TH.PLN.TRANS.RECEIPT)

    FN.ATI.TH.PLN.TRANS.RECEIPT.NAU = "F.ATI.TH.PLN.TRANS.RECEIPT$NAU"
    CALL OPF(FN.ATI.TH.PLN.TRANS.RECEIPT.NAU, F.ATI.TH.PLN.TRANS.RECEIPT.NAU)

    RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    Y.ID = ID.NEW

    IF Y.ID EQ "" THEN
        CALL UNIQUE.ID(Y.UNIQUE.KEY, "PLN")
        ID.NEW = Y.UNIQUE.KEY
        RETURN
    END

    CALL F.READ(FN.ATI.TH.PLN.TRANS.RECEIPT, Y.ID, R.ATI.TH.PLN.TRANS.RECEIPT, F.ATI.TH.PLN.TRANS.RECEIPT, ERR.ATI.TH.PLN.TRANS.RECEIPT)

    IF NOT(R.ATI.TH.PLN.TRANS.RECEIPT) THEN
        CALL F.READ(FN.ATI.TH.PLN.TRANS.RECEIPT.NAU, Y.ID, R.ATI.TH.PLN.TRANS.RECEIPT.NAU, F.ATI.TH.PLN.TRANS.RECEIPT.NAU, ERR.ATI.TH.PLN.TRANS.RECEIPT.NAU)

        IF NOT(R.ATI.TH.PLN.TRANS.RECEIPT.NAU) AND Y.ID[1,3] NE "PLN" AND LEN(Y.ID) NE 12 THEN
            CALL UNIQUE.ID(Y.UNIQUE.KEY, "PLN")
            ID.NEW = Y.UNIQUE.KEY
        END
    END

    RETURN
*-----------------------------------------------------------------------------
END
