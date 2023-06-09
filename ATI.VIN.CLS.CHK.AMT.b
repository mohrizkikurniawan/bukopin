*-----------------------------------------------------------------------------
* <Rating>-181</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.VIN.CLS.CHK.AMT
*-----------------------------------------------------------------------------
* Developer Name     : Dwi K
* Development Date   : 2017
* Description        : Routine for
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date            Modified by                Description
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT

*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------
    IF V$FUNCTION NE 'I' THEN 
	   RETURN
	END

    GOSUB INIT
    GOSUB PROCESS

    RETURN

*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    Y.ACC.ID.BNK = ID.NEW[1,12]
    SEL.CMD = "SELECT ":FN.ACCOUNT:" WITH @ID LIKE ":Y.ACC.ID.BNK:"... AND CO.CODE NE ":ID.COMPANY
    CALL EB.READLIST(SEL.CMD,SEL.LIST,"",SEL.CNT,SEL.ERR)

	FOR I = 1 TO SEL.CNT
        Y.ACC.ID = SEL.LIST<I>

        CALL F.READ(FN.ACCOUNT,Y.ACC.ID,R.ACCOUNT,F.ACCOUNT,ERR.AC)
        Y.AC.WORK.BAL = R.ACCOUNT<AC.WORKING.BALANCE>
        Y.AC.CO.CODE  = R.ACCOUNT<AC.CO.CODE>

        IF (Y.AC.WORK.BAL NE 0) AND (Y.AC.WORK.BAL NE '') THEN
		    AF = ""
			AV = ""
            ETEXT = "Rekening cabang ":Y.AC.CO.CODE:" masih memiliki saldo"
            CALL STORE.END.ERROR
        END
    NEXT I
		
    RETURN
*-----------------------------------------------------------------------------
END




