*-----------------------------------------------------------------------------
* <Rating>20</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.BM.EMAIL.SMS.SEND(Y.ES.ID)
*-----------------------------------------------------------------------------
* Developer Name     : ATI Juan Felix
* Development Date   : 20170703
* Description        : Batch routine for send Email / SMS
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date            Modified by                Description
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ATI.TH.EMAIL.SMS.DATA
    $INSERT I_F.ATI.TT.EMAIL.SMS.OUT
    $INSERT I_ATI.BM.EMAIL.SMS.SEND.COMMON
    $INSERT I_DE.GENERIC.DATA

*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------
    GOSUB INIT
    GOSUB PROCESS

    RETURN

*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
    CALL ALLOCATE.UNIQUE.TIME(Y.UNIQUE.TIME)
 
    Y.DATE.TIME = FIELD(TIMEDATE(), " ", 2, 99) : " " : FIELD(TIMEDATE(), " ", 1)

    RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    CALL F.READ(FN.ATI.TH.EMAIL.SMS.DATA, Y.ES.ID, R.ATI.TH.EMAIL.SMS.DATA, F.ATI.TH.EMAIL.SMS.DATA, ERR.ATI.TH.EMAIL.SMS.DATA)
    Y.TYPE = R.ATI.TH.EMAIL.SMS.DATA<ES.DATA.TYPE>
    
    CALL F.READ(FN.ATI.TT.EMAIL.SMS.OUT, Y.ES.ID, R.ATI.TT.EMAIL.SMS.OUT, F.ATI.TT.EMAIL.SMS.OUT, ERR.ATI.TT.EMAIL.SMS.OUT)
    Y.MESSAGE = R.ATI.TT.EMAIL.SMS.OUT

    IF R.ATI.TT.EMAIL.SMS.OUT THEN
        CALLJ 'com.ati.email.AtiSendEmail', 'sendEmailXML', Y.MESSAGE SETTING Y.RESPONSE ON ERROR
        END

*-Update status EMAIL SMS DATA-----------------------------------------------
        IF Y.RESPONSE EQ "SUCCESS" THEN
            R.ATI.TH.EMAIL.SMS.DATA<ES.DATA.SEND.STATUS> = "SUCCESS"
        END
        ELSE
            R.ATI.TH.EMAIL.SMS.DATA<ES.DATA.SEND.STATUS> = "ERROR"
            R.ATI.TH.EMAIL.SMS.DATA<ES.DATA.RESPONSE>    = Y.RESPONSE
        END

        R.ATI.TH.EMAIL.SMS.DATA<ES.DATA.ACTION>         = "DONE"
		R.ATI.TH.EMAIL.SMS.DATA<ES.DATA.DATE.TIME.SEND> = Y.DATE.TIME
		
        CALL ID.LIVE.WRITE(FN.ATI.TH.EMAIL.SMS.DATA, Y.ES.ID, R.ATI.TH.EMAIL.SMS.DATA)
    END
    
	CALL F.DELETE(FN.ATI.TT.EMAIL.SMS.OUT, Y.ES.ID)
		
    RETURN
*-----------------------------------------------------------------------------
END
