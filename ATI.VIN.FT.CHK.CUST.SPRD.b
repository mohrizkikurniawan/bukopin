*-----------------------------------------------------------------------------
* <Rating>-31</Rating>
* 14:54:55 19 MAR 2015 * 14:51:17 19 MAR 2015 * 16:58:29 13 MAR 2015 * 14:36:37 09 FEB 2015 * 14:36:19 09 FEB 2015 * 15:59:21 15 AUG 2015 * 15:08:11 03 AUG 2015 * 15:07:53 03 AUG 2015 * 15:07:41 03 AUG 2015
* WIN-KVUAVRB60BE/R14 * WIN-KVUAVRB60BE/R14 * WIN-KVUAVRB60BE/R14 * WIN-KVUAVRB60BE/R14 * WIN-KVUAVRB60BE/R14 * WIN-KVUAVRB60BE/R14 * WIN-KVUAVRB60BE/R14 * WIN-KVUAVRB60BE/R14 * WIN-KVUAVRB60BE/R14
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.VIN.FT.CHK.CUST.SPRD
*-----------------------------------------------------------------------------
* Create by   : ATI-NUI
* Create Date : 03 AUG 2015
* Description :
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date         : 20160215
* Modified by  : Indah Bhekti
* Description  : Change condition for check customer spread
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.OVERRIDE.CLASS.DETAILS

    GOSUB INIT
    GOSUB PROCESS

    RETURN

*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------

    FN.OVD = "F.OVERRIDE.CLASS.DETAILS"
		CALL OPF(FN.OVD, F.OVD)
    RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------

    Y.FT.CUSTOMER.SPREAD = R.NEW(FT.CUSTOMER.SPREAD)
    Y.FT.DEBIT.AMOUNT    = R.NEW(FT.DEBIT.AMOUNT)
    Y.FT.AMOUNT.DEBITED  = R.NEW(FT.AMOUNT.DEBITED)

*    IF (Y.FT.CUSTOMER.SPREAD GT 0) THEN
    IF R.NEW(FT.CUSTOMER.SPREAD) NE '' OR R.NEW(FT.CUSTOMER.SPREAD) NE 0 THEN
        IF (Y.FT.DEBIT.AMOUNT) THEN
            Y.AMT = Y.FT.CUSTOMER.SPREAD * Y.FT.DEBIT.AMOUNT

        END ELSE
            Y.AMT  = Y.FT.AMOUNT.DEBITED[4, LEN(Y.FT.AMOUNT.DEBITED)-3]
            Y.AMT *= Y.FT.CUSTOMER.SPREAD
        END

        CALL F.READ(FN.OVD, "RATE.SPR", R.OVD, F.OVD, OVD.ERR)
        Y.CLASSIFICATION = R.OVD<EB.OVCLD.CLASSIFICATION>
        Y.DATA.FROM      = R.OVD<EB.OVCLD.DATA.FROM>
        Y.DATA.TO        = R.OVD<EB.OVCLD.DATA.TO>

        IF (R.OVD) THEN
            GOSUB GET.OVD
        END
    END

    RETURN
*-----------------------------------------------------------------------------
GET.OVD:
*-----------------------------------------------------------------------------

    Y.CNT = DCOUNT(Y.CLASSIFICATION, VM)

    FOR OVD = 1 TO Y.CNT
        IF (Y.AMT GE Y.DATA.FROM<1, OVD>) AND (Y.AMT LE Y.DATA.TO<1, OVD>) THEN
            TEXT = "" :Y.CLASSIFICATION<OVD>
            NO.OVER = DCOUNT(R.NEW(V-9),VM)+1
            CALL STORE.OVERRIDE(NO.OVER)
            BREAK
        END
    NEXT OVD

    RETURN
*-----------------------------------------------------------------------------
END





