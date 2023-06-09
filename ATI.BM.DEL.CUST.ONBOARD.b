*-----------------------------------------------------------------------------
    SUBROUTINE ATI.BM.DEL.CUST.ONBOARD(Y.ID)
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

	Y.NO.OF.MONTHS = ""
	
	CALL F.READ(FN.ATI.TH.INTF.ORK.DATA, Y.ID, R.ATI.TH.INTF.ORK.DATA, F.ATI.TH.INTF.ORK.DATA, ATI.TH.INTF.ORK.DATA.ERR)
	Y.ATI.TH.INTF.ORK.DATA.MAPPING     = R.ATI.TH.INTF.ORK.DATA<ORK.DATA.MAPPING>
	Y.ATI.TH.INTF.ORK.DATA.STATUS      = R.ATI.TH.INTF.ORK.DATA<ORK.DATA.STATUS>
	Y.ATI.TH.INTF.ORK.DATA.VALUE.DATE  = R.ATI.TH.INTF.ORK.DATA<ORK.DATA.VALUE.DATE>
	
	CALL F.READ(FN.ATI.TH.INTF.ORK.DATA.NAU, Y.ID, R.ATI.TH.INTF.ORK.DATA.NAU, F.ATI.TH.INTF.ORK.DATA.NAU, ATI.TH.INTF.ORK.DATA.NAU.ERR)
	
	IF Y.ATI.TH.INTF.ORK.DATA.MAPPING EQ "CUSTOMER.ONBOARDING" AND Y.ATI.TH.INTF.ORK.DATA.STATUS EQ "PENDING" THEN
		CALL EB.NO.OF.MONTHS(Y.ATI.TH.INTF.ORK.DATA.VALUE.DATE, TODAY, Y.NO.OF.MONTHS)
		Y.NO.OF.MONTHS += 1
		
		IF Y.NO.OF.MONTHS GT Y.CUS.ONBOARD.PENDING.PAR THEN
			IF R.ATI.TH.INTF.ORK.DATA.NAU THEN
				GOSUB PROCESS.DELETE.ORK.DATA.NAU
			END
			
			GOSUB PROCESS.DELETE.ORK.DATA
		END
	END
	
    RETURN
*-----------------------------------------------------------------------------
PROCESS.DELETE.ORK.DATA:
*-----------------------------------------------------------------------------	
	
	Y.OFS.FUNCT      = "R"
	GOSUB PROCESS.OFS
	
	RETURN

*-----------------------------------------------------------------------------
PROCESS.DELETE.ORK.DATA.NAU:
*-----------------------------------------------------------------------------

	Y.OFS.FUNCT      = "D"
	GOSUB PROCESS.OFS

	RETURN
*-----------------------------------------------------------------------------
PROCESS.OFS:
*-----------------------------------------------------------------------------

	Y.OFS.SOURCE     = "GENERIC.OFS.PROCESS"
    Y.APP.NAME       = "ATI.TH.INTF.ORK.DATA"    
    Y.PROCESS        = "PROCESS"
    Y.OFS.VERSION    = "ATI.TH.INTF.ORK.DATA,ATI.CUST.KYC"
    Y.GTS.MODE       = ""
    Y.NO.OF.AUTH     = "0"
    Y.TRANSACTION.ID = Y.ID

    CALL OFS.BUILD.RECORD(Y.APP.NAME, Y.OFS.FUNCT, Y.PROCESS, Y.OFS.VERSION, Y.GTS.MODE, Y.NO.OF.AUTH, Y.TRANSACTION.ID, R.APP.OFS, Y.OFS.TEMP.MESSAGE)
	
	CALL OFS.CALL.BULK.MANAGER(Y.OFS.SOURCE, Y.OFS.TEMP.MESSAGE, Y.OFS.RESPONSE, Y.TXN.RESULT)

	RETURN
END


