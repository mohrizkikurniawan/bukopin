*-----------------------------------------------------------------------------
    SUBROUTINE ATI.BM.DEL.CUST.ONBOARD.SELECT
*-----------------------------------------------------------------------------
* Developer Name     : Dhio Faizar Wahyudi
* Development Date   : 20170816
* Description        : Routine Delete Customer Onboarding with status pending on ATI.TH.INTF.ORK.DATA
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date               :
* Modified by        :
* Description        :
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ATI.TH.INTF.ORK.DATA
	$INSERT I_ATI.BM.DEL.CUST.ONBOARD.COMMON

*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------
    GOSUB PROCESS

    RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
	
	SEL.CMD = "SELECT " : FN.ATI.TH.INTF.ORK.DATA
	CALL EB.READLIST(SEL.CMD, SEL.LIST, "", NO.OF.REC, RET.CODE)
		
	CALL BATCH.BUILD.LIST("", SEL.LIST)
	
    RETURN
*-----------------------------------------------------------------------------
END


