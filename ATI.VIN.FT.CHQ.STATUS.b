*-----------------------------------------------------------------------------
* <Rating>-30</Rating>
* 10:43:34 20 MAR 2015 
* WIN-KVUAVRB60BE/R14 
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.VIN.FT.CHQ.STATUS
*-----------------------------------------------------------------------------
* Developer Name     : Dwi K
* Development Date   : 20160419
* Description        : Routine to validate cheq
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

    RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    Y.RES = ""
    CALL ATI.VALIDATE.CHEQUE(R.NEW(FT.CHEQ.TYPE),R.NEW(FT.CHEQUE.NUMBER), R.NEW(FT.DEBIT.ACCT.NO), Y.RES)

    IF Y.RES NE "" THEN
        AF    = FT.CHEQUE.NUMBER
        ETEXT = Y.RES
        CALL STORE.END.ERROR
    END

    RETURN
*-----------------------------------------------------------------------------
END





