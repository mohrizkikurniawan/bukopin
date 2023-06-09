*-----------------------------------------------------------------------------
* <Rating>-60</Rating>
* 14:54:55 19 MAR 2015 * 14:51:17 19 MAR 2015 * 16:58:29 13 MAR 2015 * 13:55:19 26 JUN 2015 
* WIN-KVUAVRB60BE/R14 * WIN-KVUAVRB60BE/R14 * WIN-KVUAVRB60BE/R14 * WIN-KVUAVRB60BE/R14 
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.VIN.CU.GEN.MNE
*-----------------------------------------------------------------------------
* Developer Name     : Dwi K
* Development Date   : 20151214
* Description        : Routine for generate MNEMONIC
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
    $INSERT I_F.DATES

*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------
    GOSUB INIT
    GOSUB PROCESS

    RETURN

*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------

    Y.APP      = "CUSTOMER"
    Y.FLD.NAME = "ATI.CUST.TYPE":VM:"ATI.MOTH.MAIDEN"
    Y.POS      = ""
    CALL MULTI.GET.LOC.REF(Y.APP,Y.FLD.NAME,Y.POS)
    Y.ATI.CUST.TYPE.POS   = Y.POS<1,1>
    Y.ATI.MOTH.MAIDEN.POS = Y.POS<1,2>

    RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    IF R.NEW(EB.CUS.LOCAL.REF)<1,Y.ATI.CUST.TYPE.POS> EQ "R" THEN
        GOSUB PROCESS.RETAIL
    END ELSE
        GOSUB PROCESS.CORP
    END

    GOSUB CHECK.MNEMONIC

    RETURN
*-----------------------------------------------------------------------------
PROCESS.RETAIL:
*-----------------------------------------------------------------------------
    Y.NAME     = TRIM(R.NEW(EB.CUS.SHORT.NAME),' ','A')
    Y.CNT.NAME = DCOUNT(Y.NAME,' ')
    BEGIN CASE
    CASE Y.CNT.NAME EQ 1
        Y.MNE.1 = Y.NAME[1,3]

    CASE Y.CNT.NAME EQ 2
        Y.NAME.1 = FIELD(Y.NAME," ",1)
        Y.NAME.1 = Y.NAME.1[1,1]
        Y.NAME.2 = FIELD(Y.NAME," ",2)
        Y.NAME.2 = Y.NAME.2[1,2]
        Y.MNE.1 = Y.NAME.1:Y.NAME.2

    CASE Y.CNT.NAME GE 3
        Y.NAME.1 = FIELD(Y.NAME," ",1)
        Y.NAME.1 = Y.NAME.1[1,1]
        Y.NAME.2 = FIELD(Y.NAME," ",2)
        Y.NAME.2 = Y.NAME.2[1,1]
        Y.NAME.3 = FIELD(Y.NAME," ",3)
        Y.NAME.3 = Y.NAME.3[1,1]
        Y.MNE.1 = Y.NAME.1:Y.NAME.2:Y.NAME.3

    END CASE

    Y.MNE.2 = R.NEW(EB.CUS.LOCAL.REF)<1,Y.ATI.MOTH.MAIDEN.POS>[1,1]
    Y.MNE.3 = R.NEW(EB.CUS.DATE.OF.BIRTH)[5,3]

    Y.MNE   = Y.MNE.1:Y.MNE.2:Y.MNE.3

    RETURN
*-----------------------------------------------------------------------------
PROCESS.CORP:
*-----------------------------------------------------------------------------
    Y.SH.NAME = TRIM(R.NEW(EB.CUS.SHORT.NAME),' ','A')
    Y.SH.NAME = UPCASE(Y.SH.NAME)[1,8]

    Y.SH.NAME = FMT(Y.SH.NAME, "8L&.")
    FOR Y.LOOP = 1 TO 8
        IF Y.SH.NAME[Y.LOOP,1] NE '.' AND (Y.SH.NAME[Y.LOOP,1] LT 'A' OR Y.SH.NAME[Y.LOOP,1] GT 'Z') THEN
            CONVERT Y.SH.NAME[Y.LOOP,1] TO "." IN Y.SH.NAME
        END
    NEXT Y.LOOP

    Y.MNE = Y.SH.NAME

    RETURN
*-----------------------------------------------------------------------------
CHECK.MNEMONIC:
*-----------------------------------------------------------------------------
    CALL ALLOCATE.UNIQUE.TIME(UNIQUE.TIME)
    Y.STRING = Y.MNE:ID.COMPANY:UNIQUE.TIME
    Y.CHKSUM = CHECKSUM(Y.STRING)
    R.NEW(EB.CUS.MNEMONIC) = Y.MNE[1,5]:Y.CHKSUM

    RETURN
*-----------------------------------------------------------------------------
END

















