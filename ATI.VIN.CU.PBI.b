*-----------------------------------------------------------------------------
* <Rating>-100</Rating>
* 14:04:47 13 JUL 2016 * 14:54:55 19 MAR 2015 * 14:51:17 19 MAR 2015 * 16:58:29 13 MAR 2015 * 13:55:19 26 JUN 2015 
* CBS-APP1-JKT/t24poc * WIN-KVUAVRB60BE/R14 * WIN-KVUAVRB60BE/R14 * WIN-KVUAVRB60BE/R14 * WIN-KVUAVRB60BE/R14 
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.VIN.CU.PBI
*-----------------------------------------------------------------------------
* Developer Name     : Dwi K
* Development Date   : 20151207
* Description        :
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date               :
* Modified by        :
* Description        :
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER

*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------

    IF V$FUNCTION EQ 'I' THEN
        SAVE.AF = AF
        SAVE.AV = AV
        SAVE.AS = AS
        SAVE.COMI = COMI
        GOSUB INIT
        GOSUB PROCESS
        COMI = SAVE.COMI
        AF = SAVE.AF
        AV = SAVE.AV
        AS = SAVE.AS
    END

    RETURN

*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------

    Y.APP       = 'CUSTOMER'
    Y.FLD.NAME  = 'ATI.MOTH.MAIDEN':VM:'ATI.LGAL.MAT.DT':VM:'ATI.ADD.PHNE.NO'
    Y.FLD.NAME := VM:'ATI.CELL.PHONE':VM:'ATI.RT.RW':VM:'ATI.EMP.STATUS'
    Y.FLD.NAME := VM:'ATI.EMPLYER.ADD':VM:'ATI.EMPLYER.NM':VM:'ATI.EMPLYER.BSS'
    Y.FLD.NAME := VM:'ATI.EMP.STRT.DT':VM:'ATI.FUND.PRV.NM':VM:'ATI.FUND.PRV.JB'
    Y.FLD.NAME := VM:'ATI.FUND.PRV.PH':VM:'ATI.FUND.PRV.AD'

    Y.POS = ''
    CALL MULTI.GET.LOC.REF(Y.APP, Y.FLD.NAME, Y.POS)
    Y.ATI.MOTH.MAIDEN.POS = Y.POS<1,1>
    Y.ATI.LGAL.MAT.DT.POS = Y.POS<1,2>
    Y.ATI.ADD.PHNE.NO.POS = Y.POS<1,3>
    Y.ATI.CELL.PHONE.POS  = Y.POS<1,4>
    Y.ATI.RT.RW.POS       = Y.POS<1,5>
    Y.ATI.EMP.STATUS.POS  = Y.POS<1,6>
    Y.ATI.EMPLYER.ADD.POS = Y.POS<1,7>
    Y.ATI.EMPLYER.NM.POS  = Y.POS<1,8>
    Y.ATI.EMPLYER.BSS.POS = Y.POS<1,9>
    Y.ATI.EMP.STRT.DT.POS = Y.POS<1,10>
    Y.ATI.FUND.PRV.NM.POS = Y.POS<1,11>
    Y.ATI.FUND.PRV.JB.POS = Y.POS<1,12>
    Y.ATI.FUND.PRV.PH.POS = Y.POS<1,13>
    Y.ATI.FUND.PRV.AD.POS = Y.POS<1,14>

    Y.CHAR = "-'& "

    RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    Y.NAME = R.NEW(EB.CUS.SHORT.NAME)
    Y.AF = EB.CUS.SHORT.NAME
    GOSUB CHECK.NAME

    Y.NAME = R.NEW(EB.CUS.LOCAL.REF)<1,Y.ATI.MOTH.MAIDEN.POS>
    Y.AF = EB.CUS.LOCAL.REF
    Y.AV = Y.ATI.MOTH.MAIDEN.POS
    GOSUB CHECK.NAME

    Y.NAME = R.NEW(EB.CUS.NAME.1)
    Y.AF = EB.CUS.NAME.1
    GOSUB CHECK.NAME

    GOSUB CHECK.EXPIRED.DATE
    GOSUB CHECK.PHONE.NO
    GOSUB CHECK.NPWP
    GOSUB CHECK.RT.RW
    GOSUB CHECK.EMPLOYMENT

    RETURN
*-----------------------------------------------------------------------------
CHECK.NAME:
*-----------------------------------------------------------------------------
    Y.LEN = LEN(Y.CHAR)
    FOR Y.LOOP = 1 TO Y.LEN
        Y.NAME = TRIM(Y.NAME,Y.CHAR[Y.LOOP,1],'A')
    NEXT Y.LOOP

    IF NOT(ISALPHA(Y.NAME)) THEN
        AF = Y.AF
        AV = Y.AV
        ETEXT = "EB-CU.ERR.CHAR"
        CALL STORE.END.ERROR
    END

    RETURN
*-----------------------------------------------------------------------------
CHECK.EXPIRED.DATE:
*-----------------------------------------------------------------------------
    IF R.NEW(EB.CUS.LOCAL.REF)<1,Y.ATI.LGAL.MAT.DT.POS> LT TODAY THEN
        TEXT  = "CU.EXP.DATE"
        NO.OF.OVERR = DCOUNT(R.NEW(V-9),VM)+1
        CALL STORE.OVERRIDE(NO.OF.OVERR)
    END

    RETURN
*-----------------------------------------------------------------------------
CHECK.PHONE.NO:
*-----------------------------------------------------------------------------
    Y.PHONE = R.NEW(EB.CUS.LOCAL.REF)<1,Y.ATI.ADD.PHNE.NO.POS>
    IF Y.PHONE NE '' THEN
        Y.PHONE.CNT = DCOUNT(Y.PHONE,SM)
        FOR Y.LOOP2 = 1 TO Y.PHONE.CNT
            IF NOT(NUM(Y.PHONE<1,1,Y.LOOP2>)) THEN
                AF = EB.CUS.LOCAL.REF
                AV = Y.ATI.ADD.PHNE.NO.POS
                AS = Y.LOOP2
                ETEXT = "EB-CU.PHONE.NUMBER"
                CALL STORE.END.ERROR
            END
        NEXT Y.LOOP2
    END

    Y.CELL.PHONE = R.NEW(EB.CUS.LOCAL.REF)<1,Y.ATI.CELL.PHONE.POS>
    IF Y.CELL.PHONE NE '' THEN
        Y.CELL.PHONE.CNT = DCOUNT(Y.CELL.PHONE,SM)
        FOR Y.LOOP3 = 1 TO Y.CELL.PHONE.CNT
            IF NOT(NUM(Y.CELL.PHONE<1,1,Y.LOOP3>)) THEN
                AF = EB.CUS.LOCAL.REF
                AV = Y.ATI.CELL.PHONE.POS
                AS = Y.LOOP3
                ETEXT = "EB-CU.PHONE.NUMBER"
                CALL STORE.END.ERROR
            END
        NEXT Y.LOOP3
    END

    RETURN
*-----------------------------------------------------------------------------
CHECK.NPWP:
*-----------------------------------------------------------------------------
    Y.TAX = R.NEW(EB.CUS.TAX.ID)
    Y.LEN.TAX = LEN(Y.TAX)
    IF Y.LEN.TAX NE 15 THEN
        AF = EB.CUS.TAX.ID
        ETEXT = "EB-CU.LEN.TAX"
        CALL STORE.END.ERROR
    END

    FOR Y.LOOP4 = 1 TO Y.LEN.TAX
        Y.NPWP = TRIM(Y.TAX[Y.LOOP4,1],'-','A')
        Y.NPWP = TRIM(Y.TAX[Y.LOOP4,1],'.','A')

        IF NOT(NUM(Y.NPWP)) THEN
            AF = EB.CUS.TAX.ID
            ETEXT = "EB-CU.TAX"
            CALL STORE.END.ERROR
        END
    NEXT Y.LOOP4

    RETURN
*-----------------------------------------------------------------------------
CHECK.RT.RW:
*-----------------------------------------------------------------------------
    Y.RT.RW = R.NEW(EB.CUS.LOCAL.REF)<1,Y.ATI.RT.RW.POS>
    IF Y.RT.RW NE '' THEN
        Y.RT.RW = TRIM(Y.RT.RW,'/','A')
        IF NOT(NUM(Y.RT.RW)) THEN
            AF = EB.CUS.LOCAL.REF
            AV = Y.ATI.RT.RW.POS
            ETEXT = "EB-CU.TAX.S"
            CALL STORE.END.ERROR
        END
    END

    RETURN
*-----------------------------------------------------------------------------
CHECK.EMPLOYMENT:
*-----------------------------------------------------------------------------
    Y.EMP.STATUS = R.NEW(EB.CUS.LOCAL.REF)<1,Y.ATI.EMP.STATUS.POS>
    IF(Y.EMP.STATUS EQ 'Hired' OR Y.EMP.STATUS EQ 'Freelance') THEN
        IF R.NEW(EB.CUS.LOCAL.REF)<1,Y.ATI.EMPLYER.ADD.POS> EQ "" THEN
            AF = EB.CUS.LOCAL.REF
            AV = Y.ATI.EMPLYER.ADD.POS
            ETEXT = "EB-CU.EMPLOYEE.ADDRES"
            CALL STORE.END.ERROR
        END

        IF R.NEW(EB.CUS.LOCAL.REF)<1,Y.ATI.EMPLYER.NM.POS> EQ "" THEN
            AF = EB.CUS.LOCAL.REF
            AV = Y.ATI.EMPLYER.NM.POS
            ETEXT = "EB-CU.EMPLOYEE.NAME"
            CALL STORE.END.ERROR
        END

        IF R.NEW(EB.CUS.LOCAL.REF)<1,Y.ATI.EMPLYER.BSS.POS> EQ "" THEN
            AF = EB.CUS.LOCAL.REF
            AV = Y.ATI.EMPLYER.BSS.POS
            ETEXT = "EB-CU.EMPLOYEE.BUSSINESS"
            CALL STORE.END.ERROR
        END

        IF R.NEW(EB.CUS.LOCAL.REF)<1,Y.ATI.EMP.STRT.DT.POS> LT TODAY AND R.NEW(EB.CUS.LOCAL.REF)<1,Y.ATI.EMP.STRT.DT.POS> GT R.NEW(EB.CUS.DATE.OF.BIRTH) ELSE
            AF = EB.CUS.LOCAL.REF
            AV = Y.ATI.EMP.STRT.DT.POS
            ETEXT = "EB-CU.EMPLOYEE.START"
            CALL STORE.END.ERROR
        END

        IF R.NEW(EB.CUS.LOCAL.REF)<1,Y.ATI.EMP.STRT.DT.POS> EQ "" THEN
            AF = EB.CUS.LOCAL.REF
            AV = Y.ATI.EMP.STRT.DT.POS
            ETEXT = "EB-CU.EMPLOYEE.START.REQ"
            CALL STORE.END.ERROR
        END

        IF R.NEW(EB.CUS.JOB.TITLE) EQ "" THEN
            AF = EB.CUS.JOB.TITLE
            ETEXT = "EB-CU.JOB.TITLE"
            CALL STORE.END.ERROR
        END
    END

    RETURN
*-----------------------------------------------------------------------------
CHECK.JOB.TITLE:
*-----------------------------------------------------------------------------
    IF R.NEW(EB.CUS.JOB.TITLE) EQ "STUDENT" OR R.NEW(EB.CUS.JOB.TITLE) EQ "HOUSEWIFE" THEN
        IF(R.NEW(EB.CUS.LOCAL.REF)<1,Y.ATI.FUND.PRV.NM.POS>) EQ "" THEN
            AF = EB.CUS.LOCAL.REF
            AV = Y.ATI.FUND.PRV.NM.POS
            ETEXT = "EB-CU.BENEF.NAME"
            CALL STORE.END.ERROR
        END

        IF(R.NEW(EB.CUS.LOCAL.REF)<1,Y.ATI.FUND.PRV.JB.POS>) EQ "" THEN
            AF = EB.CUS.LOCAL.REF
            AV = Y.ATI.FUND.PRV.JB.POS
            ETEXT = "EB-CU.BENEF.JOB"
            CALL STORE.END.ERROR
        END

        IF(R.NEW(EB.CUS.LOCAL.REF)<1,Y.ATI.FUND.PRV.PH.POS>) EQ "" THEN
            AF = EB.CUS.LOCAL.REF
            AV = Y.ATI.FUND.PRV.PH.POS
            ETEXT = "EB-CU.BENEF.PHONE"
            CALL STORE.END.ERROR
        END

        IF(R.NEW(EB.CUS.LOCAL.REF)<1,Y.ATI.FUND.PRV.AD.POS>) EQ "" THEN
            AF = EB.CUS.LOCAL.REF
            AV = Y.ATI.FUND.PRV.AD.POS
            ETEXT = "EB-CU.BENEF.ADDRESS"
            CALL STORE.END.ERROR
        END
    END

    RETURN

*-----------------------------------------------------------------------------
END



















