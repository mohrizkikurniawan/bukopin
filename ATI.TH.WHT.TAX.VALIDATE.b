    SUBROUTINE ATI.TH.WHT.TAX.VALIDATE
*-----------------------------------------------------------------------------
* Developer Name        : Natasha
* Development Date      : 20170620
* Description           : Tax Parameter Table Validation
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date        :
* Modified by :
* Description :
* No Log      :
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ATI.TH.WHT.TAX

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
    Y.PERIOD.INT = R.NEW(HRP.PERIOD.INT)
    
    SAVE.AF = AF
    SAVE.AV = AV
    SAVE.AS = AS
    SAVE.COMI = COMI

    IF NOT(Y.PERIOD.INT) THEN
        AF    = HRP.PERIOD.INT
		    ETEXT = "AC-INPUT.MISSING"
		    CALL STORE.END.ERROR
    END

    IF (Y.PERIOD.INT LT 1) OR (Y.PERIOD.INT GT 31) THEN
        AF    = HRP.PERIOD.INT
		    ETEXT = "EB-DAY.CAN..13"
        CALL STORE.END.ERROR
    END
    
    AF = SAVE.AF
    AV = SAVE.AV
    AS = SAVE.AS
    COMI = SAVE.COMI

    RETURN
*-----------------------------------------------------------------------------
END
