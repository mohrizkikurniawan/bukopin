*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
* 14:54:55 19 MAR 2015 * 14:51:17 19 MAR 2015 * 16:58:29 13 MAR 2015 * 11:29:42 28 JUL 2015 
* WIN-KVUAVRB60BE/R14 * WIN-KVUAVRB60BE/R14 * WIN-KVUAVRB60BE/R14 * WIN-KVUAVRB60BE/R14 
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.VIN.CHECK.CUST.SPREAD
*-----------------------------------------------------------------------------
* Create by   : Indah Bhekti
* Create Date : 28 JAN 2016
* Description : ATI.VIN.CHECK.CUST.SPREAD
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date         :
* Modified by  :
* Description  :
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.OVERRIDE.CLASS.DETAILS

    GOSUB INIT
    GOSUB PROCESS

    RETURN

*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
    FN.OVCLSSD = "F.OVERRIDE.CLASS.DETAILS"
    F.OVCLSSD = ""
    CALL OPF(FN.OVCLSSD, F.OVCLSSD)


    RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    IF R.NEW(FT.CUSTOMER.SPREAD) NE "" OR R.NEW(FT.CUSTOMER.SPREAD) NE 0 THEN
        Y.CUST.SPREAD = R.NEW(FT.CUSTOMER.SPREAD)
        IF R.NEW(FT.DEBIT.AMOUNT) THEN
            Y.AMT = Y.CUST.SPREAD * R.NEW(FT.DEBIT.AMOUNT)
        END ELSE
            Y.AMT.DEBITED = R.NEW(FT.AMOUNT.DEBITED)
            Y.AMT         = Y.AMT.DEBITED[4, LEN(Y.AMT.DEBITED)]
            Y.AMT         = Y.CUST.SPREAD * Y.AMT
        END
    END

    CALL F.READ(FN.OVCLSSD, "RATE.SPR", R.OVCLSSD, F.OVCLSSD, ERR.OVCLSSD)
    IF R.OVCLSSD THEN
        Y.CLASSIFICATION = R.OVCLSSD<EB.OVCLD.CLASSIFICATION>
        Y.CNT = DCOUNT(Y.CLASSIFICATION, @VM)
        FOR I = 1 TO Y.CNT
            Y.DATA.FROM = R.OVCLSSD<EB.OVCLD.DATA.FROM, I>
            Y.DATA.TO   = R.OVCLSSD<EB.OVCLD.DATA.TO, I>
            Y.CLASS     = Y.CLASSIFICATION<1, I>
            IF Y.AMT GE Y.DATA.FROM AND Y.AMT LE Y.DATA.TO THEN
                TEXT        = Y.CLASS
                NO.OF.OVERR = DCOUNT(R.NEW(V-9),VM)+1
                CALL STORE.OVERRIDE(NO.OF.OVERR)
                BREAK
            END
        NEXT I
    END


    RETURN
*-----------------------------------------------------------------------------
END



