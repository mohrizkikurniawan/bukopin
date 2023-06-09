*-----------------------------------------------------------------------------
* <Rating>-31</Rating>
* 11:34:23 24 JAN 2017 * 15:58:25 13 JUL 2016 * 19:59:27 12 JUL 2016 * 19:44:36 12 JUL 2016 * 19:44:09 12 JUL 2016 * 19:44:07 12 JUL 2016 * 14:52:24 29 JUN 2016 * 14:00:38 29 JUN 2016
* CBS-APP1-JKT/t24poc * CBS-APP1-JKT/t24poc * CBS-APP1-JKT/t24poc * CBS-APP1-JKT/t24poc * CBS-APP1-JKT/t24poc * CBS-APP1-JKT/t24poc * CBS-APP1-JKT/t24poc * CBS-APP1-JKT/t24poc
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.BM.MSG.SERVICE(Y.ID)
*-----------------------------------------------------------------------------
* Developer Name     : Dwi K
* Development Date   : 20160629
* Description        : Routine for running ofs bulk manager
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date               :
* Modified by        :
* Description        :
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ATI.BM.MSG.SERVICE.COMMON
    $INSERT I_F.ATI.TH.MSG.SERVICE
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

    CALL F.READ(FN.MSG.SERVICE,Y.ID,R.MSG.SERVICE,F.MSG.SERVICE,MSG.SERVICE.ERR)
    Y.OFS.MSG = R.MSG.SERVICE<MSS.OFS.MESSAGE>
    Y.CNT.MSG = DCOUNT(Y.OFS.MSG,VM)
    Y.ID.HIS = Y.ID:';':R.MSG.SERVICE<MSS.CURR.NO>

    FOR YLOOP1 = 1 TO Y.CNT.MSG
        Y.PROCESS.FLAG = ""
        Y.MESSAGE    = Y.OFS.MSG<1,YLOOP1>

        Y.APP = FIELD(Y.MESSAGE, ',', 1)
        IF Y.APP EQ "AA.ARRANGEMENT.ACTIVITY" THEN
            OFS.SRC.ID   = "AA.COB"
        END ELSE
            OFS.SRC.ID   = "GENERIC.OFS.PROCESS"
        END 
        OFFLINE.FLAG = ""
        LOG.NAME     = "ATI.MSG.LOG"
        CALL OFS.INITIALISE.SOURCE(OFS.SRC.ID, OFFLINE.FLAG, LOG.NAME)
        CALL OFS.BULK.MANAGER(Y.MESSAGE, Y.PROCES.FLAG, "")

        Y.OFS.OUT = Y.PROCESS.FLAG
        Y.PROC    = FIELD(Y.OFS.OUT,',',1)
        Y.SUC.IND = FIELD(Y.PROC,'/',3,1)

        IF Y.SUC.IND EQ '-1' THEN
            Y.CNT.ERR = DCOUNT(Y.OFS.OUT,',')
            FOR YLOOP2 = 1 TO Y.CNT.ERR
                R.MSG.SERVICE<MSS.T24.ERROR,-1> = FIELD(Y.OFS.OUT,',',YLOOP2)
            NEXT YLOOP2
            BREAK
        END

    NEXT YLOOP1

    CALL F.WRITE(FN.MSG.SERVICE.HIS,Y.ID.HIS,R.MSG.SERVICE)

*    DELETE F.MSG.SERVICE, Y.ID
    CALL F.DELETE(FN.MSG.SERVICE, Y.ID)

    RETURN
*-----------------------------------------------------------------------------
END







