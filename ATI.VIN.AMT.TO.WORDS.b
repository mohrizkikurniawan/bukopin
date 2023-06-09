*-----------------------------------------------------------------------------
* <Rating>-181</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.VIN.AMT.TO.WORDS
*-----------------------------------------------------------------------------
* Developer Name     : Dwi K
* Development Date   : 2017
* Description        : Routine for
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date            Modified by                Description
*-----------------------------------------------------------------------------
* 20180713        Dhio Faizar Wahyudi        tambah kondisi untuk validasi amount yang ada decimalnya (untuk top up teller)
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.USER
    $INSERT I_F.LANGUAGE
    $INSERT I_F.CURRENCY

*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------
    GOSUB INIT
    GOSUB PROCESS

    RETURN

*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
    FN.CUR = "F.CURRENCY"
    F.CUR  = ""
    CALL OPF(FN.CUR,F.CUR)

    Y.APP      = 'FUNDS.TRANSFER'
    Y.FLD.NAME = 'ATI.AMT.WORDS'
    Y.POS      = ''
    CALL MULTI.GET.LOC.REF(Y.APP,Y.FLD.NAME,Y.POS)
    Y.ATI.AMT.WORDS.POS  = Y.POS<1,1>

    Y.AMT.WORDS   = ''
	Y.LANGUAGE    = 'ID'
    Y.LINE.LENGTH = 180
	Y.NO.OF.LINES = 1
    Y.ERR.MSG     = ''
	CTR.OUT       = 1
	Y.OUT         = ''
    FLAG          = 1
	Y.WORDS       = ''
	Y.CHQ         = ''
	
    Y.AMOUNT = COMI
    Y.CUR    = R.NEW(FT.DEBIT.CURRENCY)
    R.NEW(FT.LOCAL.REF)<1,Y.ATI.AMT.WORDS.POS> = ""
	
*<20180713_Dhio
	GOSUB CHECK.DECIMAL
*>20180713_Dhio

    RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------

    CALL DE.O.PRINT.WORDS(Y.AMOUNT,Y.AMT.WORDS,Y.LANGUAGE,Y.LINE.LENGTH,Y.NO.OF.LINES,Y.ERR.MSG)
    CTR = DCOUNT(Y.AMT.WORDS,"*")
    FOR I = 1 TO CTR
        Y.AMT.WORDS.POS = FIELD(Y.AMT.WORDS,"*",I)
        CONVERT "X" TO '' IN Y.AMT.WORDS
        IF (Y.AMT.WORDS.POS NE ",") AND Y.AMT.WORDS.POS THEN
            IF (Y.AMT.WORDS.POS EQ "Seratus") OR (Y.AMT.WORDS.POS EQ "Seribu") THEN
                Y.OUT<CTR.OUT-1> = Y.AMT.WORDS.POS : " "
            END ELSE
                Y.OUT<CTR.OUT> = Y.AMT.WORDS.POS : " "
                CTR.OUT = CTR.OUT + 1
            END
        END
    NEXT
	
    FOR I = 1 TO (CTR.OUT-1)
        AMT.LEN = LEN(R.NEW(FT.LOCAL.REF)<1,Y.ATI.AMT.WORDS.POS,FLAG>) + LEN(Y.OUT<I>)
        IF (AMT.LEN GT 65) THEN
            FLAG    = FLAG + 1
            AMT.LEN = 0
        END
        R.NEW(FT.LOCAL.REF)<1,Y.ATI.AMT.WORDS.POS,FLAG> := Y.OUT<I>
    NEXT

    CALL F.READ(FN.CUR,Y.CUR,R.CUR,F.CUR,CUR.ERR)
    Y.CURRENCY = R.CUR<EB.CUR.CCY.NAME,1>
    CUR        = FIELD(Y.CURRENCY," ",2)

    R.NEW(FT.LOCAL.REF)<1,Y.ATI.AMT.WORDS.POS,FLAG> := CUR
	
    RETURN
*-----------------------------------------------------------------------------
CHECK.DECIMAL:
*-----------------------------------------------------------------------------
	
	IF FIELD(Y.AMOUNT, ".", 2) NE "00" THEN
		AF = FT.CREDIT.AMOUNT
		ETEXT = "EB-DECIMAL.POINT.NOT.ALLOW"
		CALL STORE.END.ERROR
	END
	
	RETURN
*-----------------------------------------------------------------------------
END




