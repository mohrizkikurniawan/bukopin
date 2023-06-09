*-----------------------------------------------------------------------------
* <Rating>-30</Rating>
* 11:52:29 19 FEB 2015 * 11:52:26 19 FEB 2015 * 11:50:06 19 FEB 2015 * 16:51:19 05 FEB 2015 * 11:17:24 05 FEB 2015 * 11:04:11 05 FEB 2015 * 10:43:47 05 FEB 2015 * 10:38:58 05 FEB 2015 * 14:53:56 02 FEB 2015 * 17:41:07 31 JAN 2015
* WIN-KVUAVRB60BE/R14 * WIN-KVUAVRB60BE/R14 * WIN-KVUAVRB60BE/R14 * WIN-KVUAVRB60BE/R14 * WIN-KVUAVRB60BE/R14 * WIN-KVUAVRB60BE/R14 * WIN-KVUAVRB60BE/R14 * WIN-KVUAVRB60BE/R14 * WIN-KVUAVRB60BE/R14 * WIN-KVUAVRB60BE/R14
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.VIN.CHECK.CHEQUE
*-----------------------------------------------------------------------------
* Developer Name     : Novi Leo
* Development Date   : 20160302
* Description        : Routine to check cheque status
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date               :
* Modified by        :
* Description        :
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER

*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------

    GOSUB INIT
    GOSUB PROCESS

    RETURN
*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------

    Y.APP      = "FUNDS.TRANSFER"
    Y.FLD.NAME = "ATI.CHEQUE.TYPE"
    Y.POS      = ""
    CALL MULTI.GET.LOC.REF(Y.APP, Y.FLD.NAME, Y.POS)
    Y.CHQ.TYP.POS = Y.POS<1,1>

    RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------

    Y.CHEQUE.TYPE   = R.NEW(FT.CHEQ.TYPE)
    Y.CHEQUE.NUM    = R.NEW(FT.CHEQUE.NUMBER)
    Y.ACCT.NO       = R.NEW(FT.DEBIT.ACCT.NO)
    Y.CHEQUE.REG.ID = Y.CHEQUE.TYPE:".":Y.ACCT.NO

    CALL ATI.VALIDATE.CHEQUE(Y.CHEQUE.TYPE,Y.CHEQUE.NUM,Y.ACCT.NO,Y.RES)
    IF Y.RES THEN
        ETEXT = Y.RES
        AF    = FT.CHEQUE.NUMBER
        CALL STORE.END.ERROR
    END

    RETURN
*-----------------------------------------------------------------------------
END





