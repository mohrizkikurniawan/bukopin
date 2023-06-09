    SUBROUTINE ATI.BM.FT.DAILY.BAL.EOD(Y.ID)
*-----------------------------------------------------------------------------
* Developer Name     : 20170620
* Development Date   : Natasha
* Description        : Routine for daily balance EOM
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date               :
* Modified by        :
* Description        :
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ATI.BM.FT.DAILY.BAL.EOD.COMMON
    $INSERT I_F.ACCOUNT
    $INSERT I_F.ATI.TL.DAILY.BAL
    $INSERT I_F.DATES
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ATI.TH.WHT.TAX
    $INSERT I_F.AA.CUSTOMER.ARRANGEMENT
    $INSERT I_F.AA.ARRANGEMENT
	$INSERT I_F.CUSTOMER.CHARGE

*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------

    GOSUB INIT
    GOSUB PROCESS

    RETURN
*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------

    Y.ARR.LIST   = ""
    Y.AC.CTR     = 0
    Y.TOT.AV.BAL = 0

    RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------

    CALL F.READ(FN.CUST.ARR, Y.ID, R.CUST.ARR, F.CUST.ARR, CUST.ARR.ERR)
    LOCATE "ACCOUNTS" IN R.CUST.ARR<AA.CUSARR.PRODUCT.LINE, 1> SETTING Y.POSV THEN
        Y.ARR.LIST = R.CUST.ARR<AA.CUSARR.ARRANGEMENT, Y.POSV>
    END ELSE
        RETURN
    END

    Y.ARR.CNT = DCOUNT(Y.ARR.LIST, SM)

    FOR I = 1 TO Y.ARR.CNT
        Y.ARR.ID = Y.ARR.LIST<1, 1, I>
        CALL F.READ(FN.AA.ARR, Y.ARR.ID, R.AA.ARR, F.AA.ARR, AA.ARR.ERR)
        Y.AC.ID = R.AA.ARR<AA.ARR.LINKED.APPL.ID>

        CALL F.READ(FN.AC, Y.AC.ID, R.AC, F.AC, AC.ERR)
        IF R.AC<AC.INACTIV.MARKER> EQ "Y" THEN
            CONTINUE
        END
        GOSUB WRT.FT.BAL
        Y.SEL.ID    = Y.TODAY[1,6]:"*":Y.AC.ID
		READ R.DAILY.BAL FROM F.DAILY.BAL,Y.SEL.ID THEN
*        CALL F.READ(FN.DAILY.BAL,Y.SEL.ID,R.DAILY.BAL,F.DAILY.BAL,DAILY.BAL.ERR)
            GOSUB CALCULATE.AV.BAL
            GOSUB GET.TAX.CUSTOMER
		END
    NEXT I

    GOSUB WRITE.TO.CUSTOMER

    RETURN

*-----------------------------------------------------------------------------
WRT.FT.BAL:
*-----------------------------------------------------------------------------

    Y.WORK.BAL = R.AC<AC.WORKING.BALANCE>
    IF Y.WORK.BAL LT 0 THEN
        Y.WORK.BAL = 0
    END
    Y.AC.CATEG = R.AC<AC.CATEGORY>
    Y.CUST     = R.AC<AC.CUSTOMER>
    Y.AC.CUR   = R.AC<AC.CURRENCY>
    Y.TEMP 		 = ""

    Y.DAYS = "C"
    Y.NWORK.DAY = R.DATES(EB.DAT.NEXT.WORKING.DAY)
    CALL CDD("", TODAY, Y.NWORK.DAY, Y.DAYS)

    Y.DAYS = ABS(Y.DAYS)
    Y.FORWARD.DAY = TODAY
    FOR J = 1 TO Y.DAYS
        IF Y.TEMP NE Y.FORWARD.DAY[1,6] THEN
            IF Y.TEMP NE '' THEN
                WRITE R.DAILY.BAL TO F.DAILY.BAL, Y.SEL.ID
            END
            Y.SEL.ID    = Y.FORWARD.DAY[1,6]:"*":Y.AC.ID
            CALL F.READ(FN.DAILY.BAL,Y.SEL.ID,R.DAILY.BAL,F.DAILY.BAL,DAILY.BAL.ERR)
            Y.TEMP = Y.FORWARD.DAY[1,6]
        END
        R.DAILY.BAL<DBAL.DATE,-1>    = Y.FORWARD.DAY[2]
        R.DAILY.BAL<DBAL.BALANCE,-1> = Y.WORK.BAL
        Y.DAY = "+1C"
        CALL CDT("", Y.FORWARD.DAY, Y.DAY)
    NEXT J
    WRITE R.DAILY.BAL TO F.DAILY.BAL, Y.SEL.ID

    RETURN

*-----------------------------------------------------------------------------
CALCULATE.AV.BAL:
*-----------------------------------------------------------------------------

    Y.DATE       = R.DAILY.BAL<DBAL.DATE>
    Y.DATE.CNT   = DCOUNT(Y.DATE, VM)
    Y.TOT.BAL    = SUM(R.DAILY.BAL<DBAL.BALANCE>)
    IF Y.DATE.CNT GT 0 THEN
        Y.AV.BAL     = Y.TOT.BAL / Y.DATE.CNT
    END ELSE
        Y.AV.BAL = 0
    END

    RETURN
*-----------------------------------------------------------------------------
GET.TAX.CUSTOMER:
*-----------------------------------------------------------------------------

    LOCATE Y.AC.CATEG IN Y.TAX.CATEG<1,1> SETTING Y.POS.TAX.CATEG THEN
        Y.AC.CTR++
		Y.TOT.AV.BAL += Y.AV.BAL
    END

    RETURN
*-----------------------------------------------------------------------------
WRITE.TO.CUSTOMER:
*-----------------------------------------------------------------------------

*    Y.AV.BAL.CUST = Y.TOT.AV.BAL / Y.AC.CTR
    Y.AV.BAL.CUST = Y.TOT.AV.BAL

    CALL F.READ(FN.CUS,Y.CUST,R.CUS,F.CUS,CUS.ERR)
    IF NOT(R.CUS) THEN
        RETURN
    END

	CALL F.READ(FN.CUSTOMER.CHARGE, Y.CUST, R.CUSTOMER.CHARGE, F.CUSTOMER.CHARGE, ERR.CUSTOMER.CHARGE)
    IF Y.AV.BAL.CUST GE Y.THRESHOLD THEN
        R.CUS<EB.CUS.LOCAL.REF,Y.SYSTAXABLE.POS> = "Y"
*		FIND "WHT" IN R.CUSTOMER.CHARGE<EB.CCH.TAX.TYPE> SETTING YPOSF.TAX, YPOSV.TAX THEN
*			R.CUSTOMER.CHARGE<EB.CCH.TAX.DEF.GROUP, YPOSV.TAX> = "099"
*			R.CUSTOMER.CHARGE<EB.CCH.TAX.ACT.GROUP, YPOSV.TAX> = "099"
*			WRITE R.CUSTOMER.CHARGE TO F.CUSTOMER.CHARGE, Y.CUST
*		END
    END ELSE
        R.CUS<EB.CUS.LOCAL.REF,Y.SYSTAXABLE.POS> = ""
*		FIND "WHT" IN R.CUSTOMER.CHARGE<EB.CCH.TAX.TYPE> SETTING YPOSF.TAX, YPOSV.TAX THEN
*			R.CUSTOMER.CHARGE<EB.CCH.TAX.DEF.GROUP, YPOSV.TAX> = "010"
*			R.CUSTOMER.CHARGE<EB.CCH.TAX.ACT.GROUP, YPOSV.TAX> = "010"
*			WRITE R.CUSTOMER.CHARGE TO F.CUSTOMER.CHARGE, Y.CUST
*		END
    END

    WRITE R.CUS TO F.CUS, Y.CUST

    RETURN

*-----------------------------------------------------------------------------
END
