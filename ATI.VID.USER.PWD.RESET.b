*-----------------------------------------------------------------------------
* <Rating>-181</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.VID.USER.PWD.RESET
*-----------------------------------------------------------------------------
* Developer Name     : Dwi K
* Development Date   : 20171020
* Description        : Routine for check id reset password
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date            Modified by                Description
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.PASSWORD.RESET
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_System

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
    Y.TIME.VAL = TIME()
    Y.TIME.VAL = OCONV(Y.TIME.VAL,"MTS")
    CONVERT ":" TO "" IN Y.TIME.VAL
	Y.TIME = Y.TIME.VAL 
    
	Y.DATE.VAL = DATE()
    Y.DATE.VAL = FMT(OCONV(Y.DATE.VAL,"DY4"),"R%4"):FMT(OCONV(Y.DATE.VAL,"DM"),"R%2"):FMT(OCONV(Y.DATE.VAL,"DD"),"R%2")

    IF COMI AND (V$FUNCTION = 'I') THEN
        COMI = "P-":Y.DATE.VAL[6]:Y.TIME
    END
	
    Y.USER.ID = System.getVariable('CURRENT.USER.ID')

    SEL.CMD = "SELECT F.PASSWORD.RESET$NAU WITH USER.RESET EQ ": Y.USER.ID
    CALL EB.READLIST(SEL.CMD,SEL.LIST,"",SEL.CNT,SEL.ERR)

    IF SEL.LIST THEN
        E = "EB-MISSING.RECORD"
        CALL ERR
    END ELSE
        R.NEW(EB.PWR.USER.RESET) = Y.USER.ID
    END

    RETURN
*-----------------------------------------------------------------------------
END
