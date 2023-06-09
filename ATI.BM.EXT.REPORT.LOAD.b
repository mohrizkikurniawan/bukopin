*-----------------------------------------------------------------------------
* <Rating>-30</Rating>
* 15:36:01 07 OCT 2016 * 11:53:43 04 OCT 2016 * 10:28:14 04 OCT 2016 * 10:20:23 04 OCT 2016 * 17:35:20 03 OCT 2016 * 11:12:15 06 SEP 2016 * 15:02:45 05 SEP 2016 * 18:28:33 20 JUN 2016 * 10:50:23 17 JUN 2016 * 19:05:21 16 JUN 2016 
* WIN-KVUAVRB60BE/R14 * CBS-APP1-JKT/t24sit * CBS-APP1-JKT/t24sit * CBS-APP1-JKT/t24sit * CBS-APP1-JKT/t24sit * CBS-APP1-JKT/t24sit * CBS-APP1-JKT/t24sit * WIN-KVUAVRB60BE/R14 * WIN-KVUAVRB60BE/R14 * WIN-KVUAVRB60BE/R14 
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.BM.EXT.REPORT.LOAD
*-----------------------------------------------------------------------------
* Developer Name     : Dwi K
* Development Date   : 20150917
* Description        : Extract Report
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date            Modified by                Description
*-----------------------------------------------------------------------------
* 20160620        Dwi K                      Add function to splitted data
* 20161104        Dwi K                      Add function to create table for All DATA
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ATI.TH.EXT.REPORT
    $INSERT I_ATI.BM.EXT.REPORT.COMMON
    $INSERT I_F.DATES
    $INSERT I_F.FILE.CONTROL

*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------
    GOSUB INIT

    RETURN

*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
    FN.EXT.REPORT = 'F.ATI.TH.EXT.REPORT'
    CALL OPF(FN.EXT.REPORT, F.EXT.REPORT)

    FN.FILE.CONTROL = 'F.FILE.CONTROL'
    CALL OPF(FN.FILE.CONTROL,F.FILE.CONTROL)

    Y.BATCH.DETAILS = BATCH.DETAILS<3,1>
    Y.BATCH.CNT     = DCOUNT(Y.BATCH.DETAILS, SM)

    FOR Y.LOOP = 1 TO Y.BATCH.CNT
        Y.ID.EXT.REP = Y.BATCH.DETAILS<1,1,Y.LOOP>
        GOSUB CREATE.TABLE.TEMP
    NEXT Y.LOOP

    RETURN
*-----------------------------------------------------------------------------
CREATE.TABLE.TEMP:
*-----------------------------------------------------------------------------
*---------------------------TABLE TEMP----------------------------------------
    FN.EXT.TEMP = 'F.ATI.EXT.REP.':Y.ID.EXT.REP:'.TEMP'
    OPEN FN.EXT.TEMP TO F.EXT.TEMP ELSE
        READ R.FILE.CONTROL FROM F.FILE.CONTROL, 'JOB.LIST.1' THEN
            WRITE R.FILE.CONTROL TO F.FILE.CONTROL, 'ATI.EXT.REP.':Y.ID.EXT.REP:'.TEMP'
        END
        CALL EBS.CREATE.FILE(FN.EXT.TEMP,'',ERROR.MSG)
    END

*---------------------------TABLE DATA----------------------------------------
    FN.EXT.DATA = 'F.ATI.EXT.REP.':Y.ID.EXT.REP:'.DATA'
    OPEN FN.EXT.DATA TO F.EXT.DATA ELSE
        READ R.FILE.CONTROL FROM F.FILE.CONTROL, 'JOB.LIST.1' THEN
            WRITE R.FILE.CONTROL TO F.FILE.CONTROL, 'ATI.EXT.REP.':Y.ID.EXT.REP:'.DATA'
        END
        CALL EBS.CREATE.FILE(FN.EXT.DATA,'',ERROR.MSG)
    END

    RETURN

*-----------------------------------------------------------------------------
END





















