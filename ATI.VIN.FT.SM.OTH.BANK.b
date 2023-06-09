*-----------------------------------------------------------------------------
* <Rating>-30</Rating>
* 07:57:06 06 DEC 2017 * 07:51:45 06 DEC 2017
* JFT/t24r11 * JFT/t24r11
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.VIN.FT.SM.OTH.BANK
*-----------------------------------------------------------------------------
* Developer Name     : ATI Juan Felix
* Development Date   : 20180112
* Description        : Routine for send money other bank
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date            Modified by                Description
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.BC.SORT.CODE

*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------
    GOSUB INIT
    GOSUB PROCESS

    RETURN

*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
    FN.BC.SORT.CODE = "F.BC.SORT.CODE"
    CALL OPF(FN.BC.SORT.CODE, F.BC.SORT.CODE)

    RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    Y.PAYMENT.DETAILS.LIST = R.NEW(FT.PAYMENT.DETAILS)
    CONVERT VM TO "" IN Y.PAYMENT.DETAILS.LIST

    Y.BANK.CODE = TRIM(FIELDS(Y.PAYMENT.DETAILS.LIST, "-", 1), " ", "D")
    Y.DETAILS   = FIELDS(Y.PAYMENT.DETAILS.LIST, "-", 2, 999)

    CALL F.READ(FN.BC.SORT.CODE, Y.BANK.CODE, R.BC.SORT.CODE, F.BC.SORT.CODE, ERR.BC.SORT.CODE)

    IF R.BC.SORT.CODE THEN
        Y.BANK.NAME = R.BC.SORT.CODE<EB.BSC.NAME>

        Y.PAYMENT.DETAILS.NEW = Y.BANK.CODE : " " : Y.BANK.NAME : " - " : Y.DETAILS
        Y.PAYMENT.DETAILS.LEN = LEN(Y.PAYMENT.DETAILS.NEW)

        Y.LOOP = Y.PAYMENT.DETAILS.LEN / 35
        IF FIELD(Y.LOOP, ".", 2) THEN
            Y.LOOP = FIELD(Y.LOOP, ".", 1) + 1
        END

        Y.PAYMENT.DETAILS = ""

        Y.START = 1
        Y.END   = 35
        FOR I = 1 TO Y.LOOP
            Y.PAYMENT.DETAILS<1, -1> = Y.PAYMENT.DETAILS.NEW[Y.START, Y.END]

            Y.START += 35
            Y.END   += 35
        NEXT I

        R.NEW(FT.PAYMENT.DETAILS) = Y.PAYMENT.DETAILS
    END

    RETURN
*-----------------------------------------------------------------------------
END




