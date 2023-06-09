*-----------------------------------------------------------------------------
* <Rating>-104</Rating>
* 17:40:56 15 DEC 2016 * 09:42:19 14 DEC 2016 * 11:06:06 13 DEC 2016 * 10:56:15 13 DEC 2016 * 14:54:55 19 MAR 2015 * 14:51:17 19 MAR 2015 * 16:58:29 13 MAR 2015 * 13:55:19 26 JUN 2015
* CBS-APP1-JKT/t24poc * CBS-APP1-JKT/t24poc * CBS-APP1-JKT/t24poc * CBS-APP1-JKT/t24poc * WIN-KVUAVRB60BE/R14 * WIN-KVUAVRB60BE/R14 * WIN-KVUAVRB60BE/R14 * WIN-KVUAVRB60BE/R14
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.VIN.CU.CALC.RISK
*-----------------------------------------------------------------------------
* Create by   : Novi Leo
* Create Date : 20151207
* Description : Routine to calculation high risk
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date         :
* Modified by  :
* Description  :
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.COMPANY
    $INSERT I_F.COUNTRY
    $INSERT I_F.EB.LOOKUP
    $INSERT I_F.ATI.TH.JOB.RISK
    $INSERT I_F.ATI.TH.ECO.SEC
    $INSERT I_F.ATI.TH.HIGH.RISK.PARAM

*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------

    GOSUB INIT
    GOSUB PROCESS

    RETURN
*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------

    FN.CUS = "F.CUSTOMER"
    F.CUS  = ""
    CALL OPF(FN.CUS, F.CUS)

    FN.COMP = "F.COMPANY"
    F.COMP  = ""
    CALL OPF(FN.COMP, F.COMP)

    FN.COUNTRY = "F.COUNTRY"
    F.COUNTRY  = ""
    CALL OPF(FN.COUNTRY, F.COUNTRY)

    FN.JOB.RISK = "F.ATI.TH.JOB.RISK"
    F.JOB.RISK  = ""
    CALL OPF(FN.JOB.RISK, F.JOB.RISK)

    FN.ECOSEC = "F.ATI.TH.ECO.SEC"
    F.ECOSEC  = ""
    CALL OPF(FN.ECOSEC, F.ECOSEC)

    FN.HIGH.RISK.PAR = "F.ATI.TH.HIGH.RISK.PARAM"
    F.HIGH.RISK.PAR  = ""
    CALL OPF(FN.HIGH.RISK.PAR, F.HIGH.RISK.PAR)

    Y.APP       = "CUSTOMER":FM:"COMPANY":FM:"COUNTRY"
    Y.FLD.NAME  = "ATI.LGAL.MAT.DT":VM:"ATI.DISTRICT":VM:"ATI.LGAL.ID.RSK"
    Y.FLD.NAME := VM:"ATI.NATION.RISK":VM:"ATI.JOB.RISK":VM:"ATI.ECO.TYPE"
    Y.FLD.NAME := VM:"ATI.ECO.RISK":VM:"ATI.COUNTRY.RSK":VM:"ATI.CUST.TYPE"
    Y.FLD.NAME := VM:"ATI.CUST.RISK":VM:"ATI.ADD.DSTRCT":VM:"ATI.LGL.EXP.DT"
    Y.FLD.NAME := FM:"ATI.DISTRICT"
    Y.FLD.NAME := FM:"ATI.COUNTRY.RSK"
    Y.POS       = ""
    CALL MULTI.GET.LOC.REF(Y.APP, Y.FLD.NAME, Y.POS)
    Y.LGL.MAT.DT.POS   = Y.POS<1,1>
    Y.DISTRICT.POS     = Y.POS<1,2>
    Y.LGL.ID.RISK.POS  = Y.POS<1,3>
    Y.NATION.RISK.POS  = Y.POS<1,4>
    Y.JOB.RISK.POS     = Y.POS<1,5>
    Y.ECO.TYPE.POS     = Y.POS<1,6>
    Y.ECO.RISK.POS     = Y.POS<1,7>
    Y.CUS.COU.RISK.POS = Y.POS<1,8>
    Y.CUS.TYPE.POS     = Y.POS<1,9>
    Y.CUST.RISK.POS    = Y.POS<1,10>
    Y.ADD.DSTRCT.POS   = Y.POS<1,11>
    Y.LGL.EXP.DT.POS   = Y.POS<1,12>

    Y.DIST.COMP.POS = Y.POS<2,1>

    Y.COUNTRY.RISK.POS = Y.POS<3,1>

    RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    GOSUB CHK.LEGAL.ID.RISK
    GOSUB CHK.NATION.RISK
    GOSUB CHK.JOB.RISK
    GOSUB CHK.ECO.RISK
    GOSUB CHK.COUNTRY.RISK
    GOSUB CNT.HIGH.RISK.CUSTOMER

    RETURN
*-----------------------------------------------------------------------------
CHK.LEGAL.ID.RISK:
*-----------------------------------------------------------------------------
    Y.CUST.TYPE   = R.NEW(EB.CUS.LOCAL.REF)<1, Y.CUS.TYPE.POS>
    Y.COMP.BOOK   = R.NEW(EB.CUS.COMPANY.BOOK)
    IF Y.CUST.TYPE EQ "C" THEN
        Y.LGL.MAT.DT  = R.NEW(EB.CUS.LOCAL.REF)<1,Y.LGL.EXP.DT.POS>
        Y.DISTRICT.CD = R.NEW(EB.CUS.LOCAL.REF)<1,Y.ADD.DSTRCT.POS>
    END ELSE
        Y.LGL.MAT.DT  = R.NEW(EB.CUS.LOCAL.REF)<1,Y.LGL.MAT.DT.POS>
        Y.DISTRICT.CD = R.NEW(EB.CUS.LOCAL.REF)<1,Y.DISTRICT.POS>
    END

    Y.TODAY       = TODAY

    CALL F.READ(FN.COMP, Y.COMP.BOOK, R.COMP, F.COMP, COMP.ERR)
    Y.DIST.COMP = R.COMP<EB.COM.LOCAL.REF, Y.DIST.COMP.POS>

    IF Y.LGL.MAT.DT LE Y.TODAY THEN
        Y.LGL.MAT.DT.RISK = 5
    END

    IF Y.DISTRICT.CD NE Y.DIST.COMP THEN
        Y.DISTRICT.CD.RISK = 5
    END ELSE
        IF Y.DISTRICT.CD EQ Y.DIST.COMP THEN
            Y.DISTRICT.CD.RISK = 1
        END
    END

    IF Y.DISTRICT.CD.RISK GT Y.LGL.MAT.DT.RISK THEN
        R.NEW(EB.CUS.LOCAL.REF)<1,Y.LGL.ID.RISK.POS> = Y.DISTRICT.CD.RISK
    END ELSE
        R.NEW(EB.CUS.LOCAL.REF)<1,Y.LGL.ID.RISK.POS> = Y.LGL.MAT.DT.RISK
    END

    RETURN
*-----------------------------------------------------------------------------
CHK.NATION.RISK:
*-----------------------------------------------------------------------------

    Y.NATION = R.NEW(EB.CUS.NATIONALITY)
    CALL F.READ(FN.COUNTRY, Y.NATION, R.COUNTRY, F.COUNTRY, COUNTRY.ERR)
    Y.NATION.RISK = R.COUNTRY<EB.COU.LOCAL.REF, Y.COUNTRY.RISK.POS>

    R.NEW(EB.CUS.LOCAL.REF)<1,Y.NATION.RISK.POS> = Y.NATION.RISK

    RETURN
*-----------------------------------------------------------------------------
CHK.JOB.RISK:
*-----------------------------------------------------------------------------

    Y.JOB.TITLE = R.NEW(EB.CUS.JOB.TITLE)
    CALL F.READ(FN.JOB.RISK, Y.JOB.TITLE, R.JOB.RISK, F.JOB.RISK, JOB.RISK.ERR)
    Y.RISK.LEVEL = R.JOB.RISK<JR.RISK.LEVEL>

    R.NEW(EB.CUS.LOCAL.REF)<1,Y.JOB.RISK.POS> = Y.RISK.LEVEL

    RETURN
*-----------------------------------------------------------------------------
CHK.ECO.RISK:
*-----------------------------------------------------------------------------

    Y.ECO.TYPE = R.NEW(EB.CUS.LOCAL.REF)<1,Y.ECO.TYPE.POS>
    CALL F.READ(FN.ECOSEC, Y.ECO.TYPE, R.ECOSEC, F.ECOSEC, ECOSEC.ERR)
    Y.RISK.LEVEL = R.ECOSEC<ECO.RISK.LEVEL>

    R.NEW(EB.CUS.LOCAL.REF)<1,Y.ECO.RISK.POS> = Y.RISK.LEVEL

    RETURN
*-----------------------------------------------------------------------------
CHK.COUNTRY.RISK:
*-----------------------------------------------------------------------------

    Y.RESIDENCE = R.NEW(EB.CUS.RESIDENCE)
    CALL F.READ(FN.COUNTRY, Y.RESIDENCE, R.COUNTRY, F.COUNTRY, COUNTRY.ERR)
    Y.COUNTRY.RISK = R.COUNTRY<EB.COU.LOCAL.REF, Y.COUNTRY.RISK.POS>

    R.NEW(EB.CUS.LOCAL.REF)<1,Y.CUS.COU.RISK.POS> = Y.COUNTRY.RISK

    RETURN
*-----------------------------------------------------------------------------
CNT.HIGH.RISK.CUSTOMER:
*-----------------------------------------------------------------------------

    Y.CUST.TYPE   = R.NEW(EB.CUS.LOCAL.REF)<1, Y.CUS.TYPE.POS>
    Y.LGL.ID.RISK = R.NEW(EB.CUS.LOCAL.REF)<1, Y.LGL.ID.RISK.POS>
    Y.NATION.RISK = R.NEW(EB.CUS.LOCAL.REF)<1, Y.NATION.RISK.POS>
    Y.JOB.RISK    = R.NEW(EB.CUS.LOCAL.REF)<1, Y.JOB.RISK.POS>
    Y.ECO.RISK    = R.NEW(EB.CUS.LOCAL.REF)<1, Y.ECO.RISK.POS>

    CALL F.READ(FN.HIGH.RISK.PAR, "SYSTEM", R.HIGH.RISK.PAR, F.HIGH.RISK.PAR, HIGH.RISK.PAR.ERR)
    Y.CRIT      = R.HIGH.RISK.PAR<HRP.CRITERIA>
    Y.PERC      = R.HIGH.RISK.PAR<HRP.PERCENTAGE>
    Y.THRESHOLD = R.HIGH.RISK.PAR<HRP.THRESHOLD>
    Y.VALUE     = R.HIGH.RISK.PAR<HRP.VALUE>
    CUST.TYPE.LIST = R.HIGH.RISK.PAR<HRP.CUST.TYPE>

    LOCATE Y.CUST.TYPE IN CUST.TYPE.LIST<1,1> SETTING Y.POS.CUST.TYPE THEN
        Y.CRITERIA = Y.CRIT<1,Y.POS.CUST.TYPE>
        Y.PERCTG   = Y.PERC<1,Y.POS.CUST.TYPE>
    END

    IF Y.CUST.TYPE EQ "R" THEN
        LOCATE "LEGAL.ID" IN Y.CRITERIA<1,1,1> SETTING Y.POS.CRITERIA1 THEN
            Y.PERSENTASE.LEGAL.ID = Y.PERCTG<1,1,Y.POS.CRITERIA1>
            Y.TOTAL.PERC<-1>      = Y.PERSENTASE.LEGAL.ID * Y.LGL.ID.RISK/100
        END

        LOCATE "NATION" IN Y.CRITERIA<1,1,1> SETTING Y.POS.CRITERIA1 THEN
            Y.PR.NATION      = Y.PERCTG<1,1,Y.POS.CRITERIA1>
            Y.TOTAL.PERC<-1> = Y.PR.NATION * Y.NATION.RISK/100
        END

        LOCATE "JOB" IN Y.CRITERIA<1,1,1> SETTING Y.POS.CRITERIA1 THEN
            Y.PR.JOB         = Y.PERCTG<1,1,Y.POS.CRITERIA1>
            Y.TOTAL.PERC<-1> = Y.PR.JOB * Y.JOB.RISK/100
        END

        LOCATE "ECONOMY" IN Y.CRITERIA<1,1,1> SETTING Y.POS.CRITERIA1 THEN
            Y.PR.ECO         = Y.PERCTG<1,1,Y.POS.CRITERIA1>
            Y.TOTAL.PERC<-1> = Y.PR.ECO * Y.ECO.RISK/100
        END
    END ELSE
        LOCATE "LEGAL.ID" IN Y.CRITERIA<1,1,1> SETTING Y.POS.CRITERIA1 THEN
            Y.PERSENTASE.LEGAL.ID = Y.PERCTG<1,1,Y.POS.CRITERIA1>
            Y.TOTAL.PERC<-1>      = Y.PERSENTASE.LEGAL.ID * Y.LGL.ID.RISK/100
        END

        LOCATE "ECONOMY" IN Y.CRITERIA<1,1,1> SETTING Y.POS.CRITERIA1 THEN
            Y.PR.ECO         = Y.PERCTG<1,1,Y.POS.CRITERIA1>
            Y.TOTAL.PERC<-1> = Y.PR.ECO * Y.ECO.RISK/100
        END

        LOCATE "COUNTRY" IN Y.CRITERIA<1,1,1> SETTING Y.POS.CRITERIA1 THEN
            Y.PR.COU         = Y.PERCTG<1,1,Y.POS.CRITERIA1>
            Y.TOTAL.PERC<-1> = Y.PR.COU * Y.COUNTRY.RISK/100
        END
    END

    Y.TOTAL.PERCENTAGE = SUM(Y.TOTAL.PERC)
    Y.TH.COUNT         = DCOUNT(Y.THRESHOLD, VM)

    FOR LOOP1 = 1 TO Y.TH.COUNT
        IF Y.TOTAL.PERCENTAGE GE Y.THRESHOLD<1,LOOP1> THEN
            R.NEW(EB.CUS.LOCAL.REF)<1,Y.CUST.RISK.POS> = Y.VALUE<1,LOOP1>
            BREAK
        END
    NEXT LOOP1

    Y.LIST = "RISK.LEVEL"
    CALL EB.LOOKUP.LIST(Y.LIST)
    Y.RISK.LIST.ID    = Y.LIST<2>
    Y.RISK.LIST.DESC  = Y.LIST<11>
    CONVERT '_' TO FM IN Y.RISK.LIST.ID

    LOCATE R.NEW(EB.CUS.LOCAL.REF)<1,Y.CUST.RISK.POS> IN Y.RISK.LIST.ID SETTING Y.RISK.POS THEN
        TEXT<1>  = "ATI.CU.RISK"
        TEXT<2>  = FIELDS(Y.RISK.LIST.DESC, '_', Y.RISK.POS)
        NO.OF.OVERR = DCOUNT(R.NEW(V-9),VM)+1
        CALL STORE.OVERRIDE(NO.OF.OVERR)
    END

*   IF R.NEW(EB.CUS.LOCAL.REF)<1,Y.CUST.RISK.POS> EQ 5  THEN
*       TEXT  = "EB-CU.HR.HIGH"
*       NO.OF.OVERR = DCOUNT(R.NEW(V-9),VM)+1
*       CALL STORE.OVERRIDE(NO.OF.OVERR)
*   END ELSE
*       IF  R.NEW(EB.CUS.LOCAL.REF)<1,Y.CUST.RISK.POS> EQ 3  THEN
*           TEXT  = "EB-CU.HR.MID"
*           NO.OF.OVERR = DCOUNT(R.NEW(V-9),VM)+1
*           CALL STORE.OVERRIDE(NO.OF.OVERR)
*       END ELSE
*           IF  R.NEW(EB.CUS.LOCAL.REF)<1,Y.CUST.RISK.POS> EQ 1  THEN
*               TEXT  = "EB-CU.HR.LOW"
*               NO.OF.OVERR = DCOUNT(R.NEW(V-9),VM)+1
*               CALL STORE.OVERRIDE(NO.OF.OVERR)
*           END
*       END
*   END

    RETURN
*-----------------------------------------------------------------------------
END





















