    SUBROUTINE ATI.BM.AB.FORCE.MAJEUR.EXPIRY.SELECT
*-----------------------------------------------------------------------------
* Developer Name     : Fatkhur Rohman
* Development Date   : 20180604
* Description        : Subroutine to set flag expired force majeur
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date            Modified by                Description
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ATI.BM.AB.FORCE.MAJEUR.EXPIRY.COMMON

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
    LIST.PARAM<1> = ""
    LIST.PARAM<2> = FN.ATI.TH.AB.FORCE.MAJEUR
    LIST.PARAM<3> = "END.DATE LE " : Y.NEXT.WORKING.DAY
    LIST.PARAM<6> = ""
    LIST.PARAM<7> = ""

    CALL BATCH.BUILD.LIST(LIST.PARAM,"")

    RETURN
*-----------------------------------------------------------------------------
END
