    SUBROUTINE ATI.BM.FT.DAILY.BAL.SELECT
*-----------------------------------------------------------------------------
* Developer Name     : 20160204
* Development Date   : Novi Leo
* Description        : Routine for daily balance
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date               : 20170620
* Modified by        : Natasha
* Description        : Change selection to AA.CUSTOMER.ARRANGEMENT
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
	$INSERT I_F.ATI.TH.WHT.TAX
    $INSERT I_ATI.BM.FT.DAILY.BAL.COMMON

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

*	IF Y.LWORK.DAY[1,6] NE Y.TODAY[1,6] THEN
*		RETURN
*    END
*	
*	CALL F.READ(FN.TAX,"SYSTEM",R.TAX,F.TAX,TAX.ERR)
*	Y.PERIOD.INT = R.TAX<HRP.PERIOD.INT> 'R%2'
*	
*	Y.DAY = "+1C"
*	Y.DATE = TODAY[1, 6] : Y.PERIOD.INT
*	CALL CDT("", Y.DATE, Y.DAY)
*	
*	IF Y.DATE EQ TODAY THEN
*		RETURN
*	END
	
	LIST.PARAM<1> = ""
    LIST.PARAM<2> = FN.CUST.ARR
    LIST.PARAM<3> = ""
	LIST.PARAM<6> = ""
    LIST.PARAM<7> = ""

    CALL BATCH.BUILD.LIST(LIST.PARAM, "")

    RETURN
*-----------------------------------------------------------------------------
END

