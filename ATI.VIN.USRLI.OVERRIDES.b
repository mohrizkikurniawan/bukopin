*-----------------------------------------------------------------------------
* <Rating>-27</Rating>
* 16:43:35 21 SEP 2016 * 16:39:55 21 SEP 2016 * 15:11:45 09 AUG 2016 * 15:08:26 09 AUG 2016 * 13:50:28 09 AUG 2016 * 13:49:53 09 AUG 2016 * 13:33:26 09 AUG 2016 * 13:33:22 09 AUG 2016 * 13:31:01 09 AUG 2016 * 13:16:02 09 AUG 2016 
* WIN-KVUAVRB60BE/R14 * WIN-KVUAVRB60BE/R14 * CBS-APP1-JKT/t24poc * CBS-APP1-JKT/t24poc * CBS-APP1-JKT/t24poc * CBS-APP1-JKT/t24poc * CBS-APP1-JKT/t24poc * CBS-APP1-JKT/t24poc * CBS-APP1-JKT/t24poc * CBS-APP1-JKT/t24poc 
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.VIN.USRLI.OVERRIDES
*---------------------------------------------------------------------------------------------------------------------------
*
* 23 Jan 2007 - * UD070123001 *
*             The program checks for the version limit first, if no limit specific to version then the program takes the
*             application limit. This change will add more flexibility to the setup.
*
* 14 Apr 2009 - Update by Iin for Indonesia model bank
* 28 Oct 2010 - Update by Fike Inda Gunawan for Override Teller (Cash/Non Cash)
* 28 Dec 2010 - Update by Gustino for defining account.1 and account.2 Teller
*    Y.ACCT.1 = CREDIT ACCOUNT (TELLER OR FUNDS TRANSFER)
*    Y.ACCT.2 = DEBIT ACCOUNT (TELLER OR FUNDS TRANSFER)
*============================================================================================================================

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.USER
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.DATA.CAPTURE
    $INSERT I_F.TELLER

    IF V$FUNCTION EQ 'I' THEN
        CALL GET.LOC.REF("USER","LIMIT.VERSION",Y.USER.VERSION.POS)
        CALL GET.LOC.REF("USER","LIMIT.APP",Y.USER.APPLICATION.POS)
        CALL GET.LOC.REF("USER","LIMIT.AMT",Y.LIMIT.AMOUNT.POS)

        CURR.NO = 1
        Y.AMOUNT.IN.LCCY = 0
        Y.CURRENT.USER.VERSION = APPLICATION:PGM.VERSION
        Y.LIMIT.VERSION = R.USER<EB.USE.LOCAL.REF,Y.USER.VERSION.POS>
        Y.LIMIT.APPLICATION = R.USER<EB.USE.LOCAL.REF,Y.USER.APPLICATION.POS>

        LOCATE Y.CURRENT.USER.VERSION IN Y.LIMIT.VERSION<1,1,1> SETTING Y.USR.VER.LRF.VPOS THEN
            Y.USER.LIMIT.AMOUNT = R.USER<EB.USE.LOCAL.REF,Y.LIMIT.AMOUNT.POS,Y.USR.VER.LRF.VPOS>
            GOSUB GET.AMOUNT.IN.LCCY
            GOSUB PROCESS.OVERRIDE
        END
        ELSE
            LOCATE APPLICATION IN Y.LIMIT.APPLICATION<1,1,1> SETTING Y.USR.APPLN.LRF.VPOS THEN
                Y.USER.LIMIT.AMOUNT = R.USER<EB.USE.LOCAL.REF,Y.LIMIT.AMOUNT.POS,Y.USR.APPLN.LRF.VPOS>
                GOSUB GET.AMOUNT.IN.LCCY
                GOSUB PROCESS.OVERRIDE
            END
        END
    END

*    ETEXT = "DATA:" : Y.USER.LIMIT.AMOUNT : "|" : Y.AMOUNT.IN.LCCY
*    AF = FT.DEBIT.ACCT.NO
*    CALL STORE.END.ERROR


    RETURN
*--------------------------------------------------------------------------------------------------
GET.AMOUNT.IN.LCCY:
*==================

    BEGIN CASE
    CASE APPLICATION EQ "FUNDS.TRANSFER"
        Y.AMOUNT.IN.LCCY = R.NEW(FT.LOC.AMT.DEBITED)
        Y.ACCT.1 = R.NEW(FT.CREDIT.ACCT.NO)
        Y.ACCT.2 = R.NEW(FT.DEBIT.ACCT.NO)
    CASE APPLICATION EQ "TELLER"
        Y.AMOUNT.IN.LCCY = R.NEW(TT.TE.AMOUNT.LOCAL.1)
*Y.ACCT.1 = R.NEW(TT.TE.ACCOUNT.1)
*Y.ACCT.2 = R.NEW(TT.TE.ACCOUNT.2)
*----------------------Gustino 28 December 2010---------------------------------------
        IF R.NEW(TT.TE.DR.CR.MARKER) EQ "CREDIT" THEN
            Y.ACCT.1 = R.NEW(TT.TE.ACCOUNT.1)
            Y.ACCT.2 = R.NEW(TT.TE.ACCOUNT.2)
        END ELSE
            Y.ACCT.2 = R.NEW(TT.TE.ACCOUNT.1)
            Y.ACCT.1 = R.NEW(TT.TE.ACCOUNT.2)
        END
*----------------------Gustino 28 December 2010---------------------------------------
    CASE APPLICATION EQ "DATA.CAPTURE"
        Y.AMOUNT.IN.LCCY = R.NEW(DC.DC.AMOUNT.LCY)
    END CASE

    RETURN
*--------------------------------------------------------------------------------------------------
PROCESS.OVERRIDE:
*================

    IF Y.AMOUNT.IN.LCCY GT Y.USER.LIMIT.AMOUNT THEN
        IF APPLICATION EQ "TELLER" OR APPLICATION EQ "FUNDS.TRANSFER" THEN
            IF NUM(Y.ACCT.1) AND NUM(Y.ACCT.2) THEN
                TEXT  = "ATI.NONCASH.TXN.OVERRIDE"
                TEXT<2> = Y.AMOUNT.IN.LCCY
                NO.OF.OVERR = DCOUNT(R.NEW(V-9),VM)+1
                CALL STORE.OVERRIDE(NO.OF.OVERR)
            END ELSE
                TEXT  = "ATI.CASH.TXN.OVERRIDE"
                TEXT<2> = Y.AMOUNT.IN.LCCY
                NO.OF.OVERR = DCOUNT(R.NEW(V-9),VM)+1
                CALL STORE.OVERRIDE(NO.OF.OVERR)
            END
		END 
*		ELSE
*            TEXT  = "IDI.LIMIT.TXN.OVERRIDE"
*            TEXT<2> = Y.AMOUNT.IN.LCCY
*            NO.OF.OVERR = DCOUNT(R.NEW(V-9),VM)+1
*            CALL STORE.OVERRIDE(NO.OF.OVERR)
*        END
    END

    RETURN
*--------------------------------------------------------------------------------------------------
END














