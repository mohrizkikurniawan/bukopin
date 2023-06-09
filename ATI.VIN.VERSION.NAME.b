*-----------------------------------------------------------------------------
* <Rating>-30</Rating>
* 13:55:19 26 JUN 2015 
* WIN-KVUAVRB60BE/R14 
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.VIN.VERSION.NAME
*-----------------------------------------------------------------------------
* Developer Name     : Dwi K
* Development Date   : 20151203
* Description        : Routine to default version name in LAST.VERSION field
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date               :
* Modified by        :
* Description        :
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE

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

    IF V$FUNCTION EQ 'R' OR V$FUNCTION EQ 'I' THEN
        CALL GET.LOC.REF(APPLICATION,'ATI.LST.VER',LOC.POS.VER)
		CALL GET.LOC.REF(APPLICATION,'ATI.LST.VER.HIS',LOC.POS.VER.HIS)
        CALL GET.STANDARD.SELECTION.DETS(APPLICATION,R.STANDARD.SELECTION)
        CALL FIELD.NAMES.TO.NUMBERS("LOCAL.REF",R.STANDARD.SELECTION,FIELD.NO,YAF,YAV,YAS,DATA.TYPE,ERR.MSG)
        R.NEW(FIELD.NO)<1,LOC.POS.VER> = APPLICATION:PGM.VERSION
		R.NEW(FIELD.NO)<1,LOC.POS.VER.HIS> = APPLICATION:PGM.VERSION
    END

    RETURN
*-----------------------------------------------------------------------------
END










