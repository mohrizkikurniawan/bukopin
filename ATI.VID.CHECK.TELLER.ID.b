*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
* 13:55:19 26 JUN 2015 
* WIN-KVUAVRB60BE/R14 
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.VID.CHECK.TELLER.ID
*-----------------------------------------------------------------------------
* Create by   : Shokhib
* Create Date : 03 Des 2015
* Description : Routine to check TELLER.ID
*-----------------------------------------------------------------------------
* Modification History:
* Mod by      :
* Mod date    :
* Mod Reason  :
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.TELLER.ID

    GOSUB INIT
    GOSUB PROCESS

    RETURN

*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------

    FN.TELLER.ID = 'F.TELLER.ID'
    F.TELLER.ID  = ''
    CALL OPF(FN.TELLER.ID, F.TELLER.ID)

    RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------

    SEL.CMD = "SELECT " : FN.TELLER.ID : " WITH K.USER EQ ":OPERATOR:" AND STATUS EQ 'OPEN'"
    CALL EB.READLIST(SEL.CMD, LISTTID, "", SEL.NO, ERR.NO)

    Y.ID = LISTTID
    Y.ID.COMPANY = ID.COMPANY

    CALL F.READ(FN.TELLER.ID, Y.ID, R.TELLER.ID, F.TELLER.ID, TELLER.ERR)
    Y.CO.CODE = R.TELLER.ID<TT.TID.CO.CODE>

    IF Y.ID EQ "" THEN
        E = 'TELLER.ID.NOT.EXIST'
    END ELSE

        IF Y.CO.CODE NE Y.ID.COMPANY THEN
            E = 'TELLER.ID.NE.IDCOMP'
        END
    END

    RETURN

*-----------------------------------------------------------------------------





