*-----------------------------------------------------------------------------
* <Rating>-24</Rating>
* 11:34:23 24 JAN 2017 * 15:58:36 13 JUL 2016 * 19:43:55 12 JUL 2016 * 14:00:07 29 JUN 2016 * 13:51:39 29 JUN 2016
* CBS-APP1-JKT/t24poc * CBS-APP1-JKT/t24poc * CBS-APP1-JKT/t24poc * CBS-APP1-JKT/t24poc * CBS-APP1-JKT/t24poc
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.BM.MSG.SERVICE.LOAD
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
    $INSERT I_F.ATI.TH.MSG.SERVICE
    $INSERT I_ATI.BM.MSG.SERVICE.COMMON

*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------
    GOSUB INIT

    RETURN

*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
    FN.MSG.SERVICE = 'F.ATI.TH.MSG.SERVICE'
    F.MSG.SERVICE  = ''
    CALL OPF(FN.MSG.SERVICE, F.MSG.SERVICE)

    FN.MSG.SERVICE.HIS = 'F.ATI.TH.MSG.SERVICE$HIS'
    F.MSG.SERVICE.HIS  = ''
    CALL OPF(FN.MSG.SERVICE.HIS, F.MSG.SERVICE.HIS)

*    OFS.SRC.ID   = "GENERIC.OFS.PROCESS"
*    OFFLINE.FLAG = ""
*    LOG.NAME     = "ATI.MSG.LOG"
*    CALL OFS.INITIALISE.SOURCE(OFS.SRC.ID, OFFLINE.FLAG, LOG.NAME)

    RETURN
*-----------------------------------------------------------------------------
END




















