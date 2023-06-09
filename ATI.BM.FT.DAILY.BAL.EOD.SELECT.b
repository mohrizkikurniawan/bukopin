    SUBROUTINE ATI.BM.FT.DAILY.BAL.EOD.SELECT
*-----------------------------------------------------------------------------
* Developer Name     : 20170620
* Development Date   : Natasha
* Description        : Routine for daily balance EOM
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date               :
* Modified by        :
* Description        :
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ATI.BM.FT.DAILY.BAL.EOD.COMMON

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

    Y.CHECK.DATE = TODAY[1,6] : Y.PERIOD.INT

 *   IF Y.PERIOD.INT GT 27 THEN
 *       Y.MONTH = TODAY[1,6]
 *       CALL GET.LAST.DOM(Y.MONTH, Y.DOM.DATE, Y.END.DATE, M.NAME)
 *       IF Y.END.DATE LT Y.PERIOD.INT THEN
 *           Y.CHECK.DATE = Y.DOM.DATE
 *       END
 *   END

 *   IF Y.CHECK.DATE GE TODAY AND Y.CHECK.DATE LT Y.NWORK.DAY THEN
        GOSUB GET.SELECTION
 *   END

    RETURN

*-----------------------------------------------------------------------------
GET.SELECTION:
*-----------------------------------------------------------------------------

    LIST.PARAM<1> = ""
    LIST.PARAM<2> = FN.CUST.ARR
    LIST.PARAM<3> = ""
    LIST.PARAM<6> = ""
    LIST.PARAM<7> = ""

    CALL BATCH.BUILD.LIST(LIST.PARAM, "")

    RETURN
*-----------------------------------------------------------------------------
END
