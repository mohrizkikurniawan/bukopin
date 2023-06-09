*-----------------------------------------------------------------------------
* <Rating>-80</Rating>
* 17:29:49 15 JAN 2016 * 16:37:47 15 JAN 2016 * 12:07:56 15 JAN 2016
* CBS-APP1-JKT/t24sit * CBS-APP1-JKT/t24sit * CBS-APP1-JKT/t24sit
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.BM.PURGE.FILE(Y.ID)
*-----------------------------------------------------------------------------
* Developer Name   : ATI-YUDISTIA ADNAN
* Development Date : 02 DECEMBER 2015
* Description      : Purge based on Table Parameter
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date        : 10 October 2017
* Modified by : Dhio Faizar Wahyudi
* Description : Move read OPF $HIS table
* No Log      :
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ATI.BM.PURGE.FILE.COMMON
    $INSERT I_F.ATI.TH.PURGE.PARAM
    $INSERT I_BATCH.FILES

*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------

    GOSUB INIT
    GOSUB PROCESS

    RETURN

*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
    Y.APP.NAME = CONTROL.LIST<1,1>

    FN.FILE.NAME = "F.":Y.APP.NAME
    F.FILE.NAME  = ""
    CALL OPF(FN.FILE.NAME, F.FILE.NAME)

*    FN.FILE.NAME.HIS = "F.":Y.APP.NAME:"$HIS"
*    F.FILE.NAME.HIS  = ""
*    CALL OPF(FN.FILE.NAME.HIS, F.FILE.NAME.HIS)

    FN.FILE.ARC = "F.ATI.":Y.APP.NAME:".ARC"
    OPEN FN.FILE.ARC TO F.FILE.ARC ELSE
        PRINT "CANT OPEN FILE"
    END

    CALL GET.STANDARD.SELECTION.DETS(Y.APP.NAME, R.SS)
    CALL FIELD.NAMES.TO.NUMBERS("CURR.NO",R.SS,Y.CURR.NO.POS,"","","","","")

    RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    CALL F.READ(FN.FILE.NAME, Y.ID, R.RECORD, F.FILE.NAME, ERR.REC)

    CALL F.READ(FN.PRG.PARAM, Y.APP.NAME, R.PARAM, F.PRG.PARAM, PRG.PARAM.ERR)
    Y.ARCHIVE = R.PARAM<PRG.FL.ARCHIVE.REC>

    IF R.RECORD THEN
        BEGIN CASE
        CASE Y.ARCHIVE EQ "DELETE"
            GOSUB DELETE.REC

        CASE Y.ARCHIVE EQ "ARCHIVE"
            GOSUB CREATE.ARCHIVE.REC
            GOSUB DELETE.REC

        CASE Y.ARCHIVE EQ "HISTORY"
			FN.FILE.NAME.HIS = "F.":Y.APP.NAME:"$HIS"
			F.FILE.NAME.HIS  = ""
			CALL OPF(FN.FILE.NAME.HIS, F.FILE.NAME.HIS)

            GOSUB CREATE.HIS.REC
            GOSUB DELETE.REC
        END CASE
    END

    RETURN

*-----------------------------------------------------------------------------
CREATE.HIS.REC:
*-----------------------------------------------------------------------------
    Y.ID.HIS = Y.ID:";":R.RECORD<Y.CURR.NO.POS>
    CALL F.WRITE(FN.FILE.NAME.HIS, Y.ID.HIS, R.RECORD)

    RETURN

*-----------------------------------------------------------------------------
CREATE.ARCHIVE.REC:
*-----------------------------------------------------------------------------
    WRITE R.RECORD TO F.FILE.ARC, Y.ID

    RETURN

*-----------------------------------------------------------------------------
DELETE.REC:
*-----------------------------------------------------------------------------
    CALL F.DELETE(FN.FILE.NAME, Y.ID)

    RETURN
*-----------------------------------------------------------------------------
END

















