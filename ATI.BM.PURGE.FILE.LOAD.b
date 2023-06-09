*-----------------------------------------------------------------------------
* <Rating>-50</Rating>
* 17:30:10 15 JAN 2016 * 16:38:29 15 JAN 2016 * 12:08:09 15 JAN 2016
* CBS-APP1-JKT/t24sit * CBS-APP1-JKT/t24sit * CBS-APP1-JKT/t24sit
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.BM.PURGE.FILE.LOAD
*-----------------------------------------------------------------------------
* Developer Name        : ATI-YUDISTIA ADNAN
* Development Date      : 02 DECEMBER 2015
* Description           : Purge based on Table Parameter
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
    $INSERT I_ATI.BM.PURGE.FILE.COMMON
    $INSERT I_F.ATI.TH.PURGE.PARAM

*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------
    GOSUB INIT
    GOSUB PROCESS

    RETURN

*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
    FN.PRG.PARAM = "F.ATI.TH.PURGE.PARAM"
    F.PRG.PARAM  = ""
    CALL OPF(FN.PRG.PARAM, F.PRG.PARAM)

    RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    Y.BATCH.DETAILS = BATCH.DETAILS<3,1>
    Y.BATCH.CNT     = DCOUNT(Y.BATCH.DETAILS, SM)

    FOR Y.LOOP = 1 TO Y.BATCH.CNT
        Y.ID = Y.BATCH.DETAILS<1,1,Y.LOOP>

        CALL F.READ(FN.PRG.PARAM, Y.ID, R.PRG.PARAM, F.PRG.PARAM, PARAM.ERR)

        IF R.PRG.PARAM<PRG.FL.ARCHIVE.REC> EQ "ARCHIVE" THEN
            GOSUB CREATE.TABLE.ARC
        END
    NEXT Y.LOOP

    RETURN

*-----------------------------------------------------------------------------
CREATE.TABLE.ARC:
*-----------------------------------------------------------------------------
    FN.EXT.TEMP  = "F.ATI.":Y.ID:".ARC"

    OPEN FN.EXT.TEMP TO F.EXT.TEMP ELSE
        CALL EBS.CREATE.FILE(FN.EXT.TEMP,"",ERR.MSG)
    END

    RETURN
*-----------------------------------------------------------------------------
END





