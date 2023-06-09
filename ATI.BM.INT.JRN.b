*-----------------------------------------------------------------------------
    SUBROUTINE ATI.BM.INT.JRN(Y.ID)
*-----------------------------------------------------------------------------
* Developer Name     : Dwi K
* Development Date   : 20170905
* Description        : Routine 
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date               :
* Modified by        :
* Description        :
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
	$INSERT I_F.ATI.TL.AC.DETAILS
	$INSERT I_ATI.BM.INT.JRN.COMMON

*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------
    GOSUB PROCESS

    RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------

    CALL F.READ(FN.ATI.TL.AC.DETAILS, Y.ID, R.ATI.TL.AC.DETAILS, F.ATI.TL.AC.DETAILS, ERR.ATI.TL.AC.DETAILS)
	Y.ENTRIES = R.ATI.TL.AC.DETAILS<AC.DET.ENTRIES>
	
	CONVERT VM TO FM IN Y.ENTRIES
	CONVERT "|" TO VM IN Y.ENTRIES
	IF Y.ENTRIES NE "" THEN
        Y.SYSTEM.ID = 'AC'
        Y.TYPE      = "SAO"
        V = 500
		Y.CO.CODE = FIELD(Y.ENTRIES, VM, 2)
        IF C$MULTI.BOOK AND Y.CO.CODE NE ID.COMPANY THEN
            CALL LOAD.COMPANY(Y.CO.CODE)
        END

        CALL EB.ACCOUNTING(Y.SYSTEM.ID, Y.TYPE, Y.ENTRIES, '')
    END
	
	R.ATI.TL.AC.DETAILS<AC.DET.ENTRIES> = ""
	CALL F.WRITE(FN.ATI.TL.AC.DETAILS, Y.ID, R.ATI.TL.AC.DETAILS)
	
    RETURN
*-----------------------------------------------------------------------------
END


