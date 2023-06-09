*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
* 17:19:03 04 AUG 2015 * 17:14:52 04 AUG 2015 * 17:14:13 04 AUG 2015 * 17:02:28 04 AUG 2015 * 16:59:53 04 AUG 2015 * 16:50:52 04 AUG 2015 * 13:58:34 27 JUL 2015 
* WIN-KVUAVRB60BE/R14 * WIN-KVUAVRB60BE/R14 * WIN-KVUAVRB60BE/R14 * WIN-KVUAVRB60BE/R14 * WIN-KVUAVRB60BE/R14 * WIN-KVUAVRB60BE/R14 * WIN-KVUAVRB60BE/R14 
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.VIN.CHECK.WIC
*-----------------------------------------------------------------------------
* Create by   : Indah Bhekti
* Create Date : 27 JAN 2016
* Description : Validate total transaction compared with maximal amount transaction
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
    $INSERT I_F.ATI.TH.WIC.PARAM
    $INSERT I_F.ATI.TL.WIC.TXN

    GOSUB INIT
    GOSUB PROCESS

    RETURN

*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
    FN.PARAM = "F.ATI.TH.WIC.PARAM"
    F.PARAM = ""
    CALL OPF(FN.PARAM, F.PARAM)

    FN.WIC.TXN = "F.ATI.TL.WIC.TXN"
    F.WIC.TXN = ""
    CALL OPF(FN.WIC.TXN, F.WIC.TXN)

    APPLICATION = "FUNDS.TRANSFER"
    CALL GET.LOC.REF(APPLICATION, "ATI.WIC.FLAG", ATI.WIC.FLAG.POS)
    CALL GET.LOC.REF(APPLICATION, "ATI.WIC.ID", ATI.WIC.ID.POS)

    Y.AMT = ""
    Y.TXN = ""

    RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    Y.WIC.FLAG = R.NEW(FT.LOCAL.REF)<1, ATI.WIC.FLAG.POS>
    Y.WIC.ID   = R.NEW(FT.LOCAL.REF)<1, ATI.WIC.ID.POS>

    IF Y.WIC.FLAG EQ "Y" THEN
        IF Y.WIC.ID EQ "" THEN
            E = "WIC ID is mandatory"
            CALL STORE.END.ERROR
            RETURN
        END
    END ELSE
        RETURN
    END

    CALL F.READ(FN.PARAM, "SYSTEM", R.PARAM, F.PARAM, ERR.PARAM)
    Y.MAX.TXN = R.PARAM<WP.MAX.TXN>
    Y.MAX.AMT = R.PARAM<WP.MAX.AMT>

    CALL F.READ(FN.WIC.TXN, Y.WIC.ID, R.WIC.TXN, F.WIC.TXN, ERR.WIC.TXN)
    Y.TXN.DATE = R.WIC.TXN<WT.TXN.DATE>
    Y.TXN.AMT  = R.WIC.TXN<WT.TXN.AMT>

    Y.CNT.TXN.DATE = DCOUNT(Y.TXN.DATE, @VM)
    FOR I = 1 TO Y.CNT.TXN.DATE
        IF Y.TXN.DATE<1, I> EQ TODAY THEN
            Y.AMT += Y.TXN.AMT<1, I>
            Y.TXN += 1
        END
    NEXT I

    IF Y.AMT GE Y.MAX.AMT THEN
        E = "Maximum Transaction are " : Y.MAX.TXN : " But your total transaction are " : Y.TXN
        CALL STORE.END.ERROR
    END


    RETURN

*-----------------------------------------------------------------------------
END


