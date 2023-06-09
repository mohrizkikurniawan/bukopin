*-----------------------------------------------------------------------------
* <Rating>-181</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.BM.RESEND.POST.BUKISYS.SELECT
*-----------------------------------------------------------------------------
* Developer Name     : Dwi K
* Development Date   : 20190124
* Description        : Routine for resend posting journal Bukisys
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date            Modified by                Description
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
	$INSERT I_ATI.BM.RESEND.POST.BUKISYS.COMMON

*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------
    GOSUB SELECTION

    RETURN

*-----------------------------------------------------------------------------
SELECTION:
*-----------------------------------------------------------------------------
	LIST.PARAM<1> = ""
    LIST.PARAM<2> = FN.ATI.TH.INTF.OUT.TRANSACTION
*    LIST.PARAM<3> = "AGENT.ID NE '' AND STATUS EQ 'ERROR' AND VALUE.DATE EQ " : TODAY
    LIST.PARAM<3> = "STATUS EQ 'ERROR' AND VALUE.DATE EQ " : TODAY
    LIST.PARAM<6> = ""
    LIST.PARAM<7> = ""

    CALL BATCH.BUILD.LIST(LIST.PARAM,"")
		
    RETURN
	
*-----------------------------------------------------------------------------
END




