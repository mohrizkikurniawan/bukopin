*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* 11:45:18 21 DEC 2016 * <Rating>-50</Rating>
* CBS-APP1-JKT/t24poc * CBS-APP1-JKT/t24poc * CBS-APP1-JKT/t24poc * CBS-APP1-JKT/t24poc * CBS-APP1-JKT/t24poc * CBS-APP1-JKT/t24poc * CBS-APP1-JKT/t24poc * CBS-APP1-JKT/t24poc * CBS-APP1-JKT/t24poc * CBS-APP1-JKT/t24poc 
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.VIN.AC.SET.STATUS
*-----------------------------------------------------------------------------
* Create by   : Kholida
* Create Date : 20161208
* Description : Routine to set field status
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date         :
* Modified by  :
* Description  :
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AC.LOCKED.EVENTS

*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------

    GOSUB INIT
    GOSUB PROCESS

    RETURN
*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------

    FN.ACCT = "F.ACCOUNT"
    F.ACCT  = ""
    CALL OPF(FN.ACCT, F.ACCT)
    
    FN.ACCT.HIS = "F.ACCOUNT$HIS"
    F.ACCT.HIS  = ""
    CALL OPF(FN.ACCT.HIS, F.ACCT.HIS)
    
    FN.LOCK = "F.ATI.TT.AC.LOCKED.AMT"
    F.LOCK  = ""
    CALL OPF (FN.LOCK, F.LOCK)
    
    FN.AC.LOCK = "F.AC.LOCKED.EVENTS"
    F.AC.LOCK  = ""
    CALL OPF (FN.AC.LOCK, F.AC.LOCK)

    Y.APP       = "ACCOUNT"
    Y.FLD.NAME  = "ATI.ACCT.STAT"
    Y.POS       = ""
    CALL MULTI.GET.LOC.REF(Y.APP, Y.FLD.NAME, Y.POS)
    Y.STATUS.REKENING.POS = Y.POS<1,1>

    RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------

    Y.ID.AC = ID.NEW
    CALL F.READ(FN.ACCT, Y.ID.AC, R.ACCT, F.ACCT, ACCT.ERR)
    Y.POSTING.RESTRICT = R.NEW(AC.POSTING.RESTRICT)
    Y.STATUS.REKENING  = R.NEW(AC.LOCAL.REF)<1,Y.STATUS.REKENING.POS>


    BEGIN CASE
    CASE APPLICATION EQ 'ACCOUNT.CLOSURE'
        IF NOT(R.ACCT) THEN
            CALL F.READ.HISTORY(FN.ACCT.HIS, Y.ID.AC, R.ACCT, F.ACCT.HIS, ACCT.ERR)
            R.ACCT<AC.LOCAL.REF, Y.STATUS.REKENING.POS> = "CLOSED"
            CALL F.WRITE(FN.ACCT.HIS, Y.ID.AC, R.ACCT)
        END ELSE
            R.ACCT<AC.LOCAL.REF, Y.STATUS.REKENING.POS> = "CLOSED"
            CALL F.WRITE(FN.ACCT, Y.ID.AC, R.ACCT)
        END

    CASE APPLICATION EQ 'ACCT.INACTIVE.RESET' AND Y.STATUS.REKENING EQ 'DORMANT'
        GOSUB CHECK.NEXT
        CALL F.WRITE(FN.ACCT, Y.ID.AC, R.ACCT)

    CASE APPLICATION EQ 'AC.LOCKED.EVENTS'
        IF ACCT.ERR THEN
            Y.ID.AC = R.NEW(AC.LCK.ACCOUNT.NUMBER)
            CALL F.READ(FN.ACCT, Y.ID.AC, R.ACCT, F.ACCT, ACCT.ERR)
        END

        IF R.NEW(AC.LCK.RECORD.STATUS)[1,1] EQ "R" THEN
            GOSUB CHECK.NEXT
        END ELSE
            R.ACCT<AC.LOCAL.REF, Y.STATUS.REKENING.POS>  = "FREEZE"
        END
        CALL F.WRITE(FN.ACCT, Y.ID.AC, R.ACCT)

    CASE R.NEW(AC.POSTING.RESTRICT) NE ''
        R.NEW(AC.LOCAL.REF)<1, Y.STATUS.REKENING.POS> = "SUSPEND"

    CASE 1
        R.NEW(AC.LOCAL.REF)<1, Y.STATUS.REKENING.POS> = "ACTIVE"
    END CASE
    
    RETURN

*-----------------------------------------------------------------------------
CHECK.NEXT:
*============
    
    R.ACCT<AC.LOCAL.REF, Y.STATUS.REKENING.POS>  = "ACTIVE"
    IF R.ACCT<AC.POSTING.RESTRICT> NE '' THEN
        R.ACCT<AC.LOCAL.REF, Y.STATUS.REKENING.POS> = "SUSPEND"
    END ELSE
        GOSUB CHECK.LOCKED
    END
    
    RETURN

*-----------------------------------------------------------------------------
CHECK.LOCKED:
*============
    
    CALL F.READ(FN.LOCK, Y.ID.AC, R.LOCK, F.LOCK, LOCK.ERR)
    IF NOT(R.LOCK) THEN
        RETURN
    END
    Y.MAX.LOOP = DCOUNT(R.LOCK, @FM)
    FOR I = 1 TO Y.MAX.LOOP
        CALL F.READ (FN.AC.LOCK, R.LOCK<I>, R.AC.LOCK, F.LOCK, LOCK.ERR)
        IF R.AC.LOCK THEN
            R.ACCT<AC.LOCAL.REF, Y.STATUS.REKENING.POS>  = "FREEZE"
            BREAK
        END
        
    NEXT I

    RETURN
*-----------------------------------------------------------------------------
END







