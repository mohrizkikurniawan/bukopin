*-----------------------------------------------------------------------------
* <Rating>-30</Rating>
* 16:43:35 21 SEP 2016 * 16:39:55 21 SEP 2016 * 16:41:05 09 AUG 2016 * 16:40:43 09 AUG 2016 * 13:55:19 26 JUN 2015
* WIN-KVUAVRB60BE/R14 * WIN-KVUAVRB60BE/R14 * CBS-APP1-JKT/t24poc * CBS-APP1-JKT/t24poc * WIN-KVUAVRB60BE/R14
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.VID.AUTH.VERSION
*-----------------------------------------------------------------------------
* Developer Name     : Dwi K
* Development Date   : 20151203
* Description        : Routine to validate version name in ATI.LST.VER field
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
    FN.APPL = 'F.':APPLICATION:'$NAU'
    F.APPL  = ''
    CALL OPF(FN.APPL,F.APPL)

    RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    IF V$FUNCTION EQ 'A' THEN
        CALL GET.LOC.REF(APPLICATION,'ATI.LST.VER',LOC.POS.VER)
        CALL GET.LOC.REF(APPLICATION,'ATI.LST.VER.HIS',LOC.POS.VER.HIS)
        CALL GET.STANDARD.SELECTION.DETS(APPLICATION,R.STANDARD.SELECTION)
        CALL FIELD.NAMES.TO.NUMBERS("LOCAL.REF",R.STANDARD.SELECTION,FIELD.NO,YAF,YAV,YAS,DATA.TYPE,ERR.MSG)
        CALL FIELD.NAMES.TO.NUMBERS("RECORD.STATUS",R.STANDARD.SELECTION,FIELD.NO.STATUS,YAF,YAV,YAS,DATA.TYPE,ERR.MSG)
        Y.LAST.VER.VALUE = APPLICATION:PGM.VERSION

        CALL F.READ(FN.APPL,COMI,R.APPL,F.APPL,APPL.ERR)
        Y.CURR.LAST.VER      = R.APPL<FIELD.NO,LOC.POS.VER>
        Y.CURR.LAST.VER.HIS  = R.APPL<FIELD.NO,LOC.POS.VER.HIS>
        Y.RECORD.STATUS      = R.APPL<FIELD.NO.STATUS>

        IF Y.RECORD.STATUS[1] EQ 'O' THEN
            IF Y.CURR.LAST.VER.HIS NE Y.LAST.VER.VALUE THEN
                E = 'EB-VER.NOT.SAME'
            END
        END ELSE
            IF Y.CURR.LAST.VER NE Y.LAST.VER.VALUE THEN
                E = 'EB-VER.NOT.SAME'
            END
        END
    END

    RETURN
*-----------------------------------------------------------------------------
END


















