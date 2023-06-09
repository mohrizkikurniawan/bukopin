*-----------------------------------------------------------------------------
* <Rating>-60</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.BM.CARDLESS.WITHDRAWAL.OL(Y.ID)
*-----------------------------------------------------------------------------
* Developer Name     : ATI Juan Felix
* Development Date   : 20170620
* Description        : Service cardless withdrawal
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date            Modified by                Description
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ATI.TH.CARDLESS.WITHDRAWAL
    $INSERT I_ATI.BM.CARDLESS.WITHDRAWAL.OL.COMMON

*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------
    GOSUB INIT
    GOSUB PROCESS

    RETURN

*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
    Y.DATE      = OCONV(DATE(),"D-")
    Y.TIME      = TIMEDATE()
    Y.DATE.TIME = Y.DATE[9,2]:Y.DATE[1,2]:Y.DATE[4,2]:Y.TIME[1,2]:Y.TIME[4,2]

    RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    CALL F.READ(FN.ATI.TH.CARDLESS.WITHDRAWAL, Y.ID, R.ATI.TH.CARDLESS.WITHDRAWAL, F.ATI.TH.CARDLESS.WITHDRAWAL, ERR.ATI.TH.CARDLESS.WITHDRAWAL)
    Y.STATUS        = R.ATI.TH.CARDLESS.WITHDRAWAL<CL.WTD.STATUS>
    Y.FT.ID         = R.ATI.TH.CARDLESS.WITHDRAWAL<CL.WTD.FT.ID>
    Y.EXP.DATE.TIME = R.ATI.TH.CARDLESS.WITHDRAWAL<CL.WTD.EXP.DATE.TIME>
    Y.CURR.NO       = R.ATI.TH.CARDLESS.WITHDRAWAL<CL.WTD.CURR.NO>
    Y.CO.CODE       = R.ATI.TH.CARDLESS.WITHDRAWAL<CL.WTD.CO.CODE>
    Y.ISO.TRACE     = R.ATI.TH.CARDLESS.WITHDRAWAL<CL.WTD.ISO.TRACE>

    IF Y.DATE.TIME GT Y.EXP.DATE.TIME[1,10] THEN
        GOSUB DELETE.FT
        GOSUB DELETE.CL.WTD
        GOSUB DELETE.ISO.TRACE
    END

    RETURN

*-----------------------------------------------------------------------------
DELETE.FT:
*-----------------------------------------------------------------------------
    Y.APP.NAME       = "FUNDS.TRANSFER"
    Y.OFS.FUNCT      = "D"
    Y.PROCESS        = "PROCESS"
    Y.OFS.VERSION    = Y.APP.NAME : ",ATI.INTF.OFS"
    Y.GTS.MODE       = ""
    Y.NO.OF.AUTH     = 0
    Y.TRANSACTION.ID = Y.FT.ID

    IF Y.CO.CODE THEN
        CALL LOAD.COMPANY(Y.CO.CODE)
    END

    CALL OFS.BUILD.RECORD(Y.APP.NAME, Y.OFS.FUNCT, Y.PROCESS, Y.OFS.VERSION, Y.GTS.MODE, Y.NO.OF.AUTH, Y.TRANSACTION.ID, R.FUNDS.TRANSFER.OFS, Y.OFS.MESSAGE)

    Y.OFS.SOURCE = "GENERIC.OFS.PROCESS"

    CALL OFS.CALL.BULK.MANAGER(Y.OFS.SOURCE, Y.OFS.MESSAGE, Y.OFS.RESPONSE, Y.TXN.RESULT)

    RETURN

*-----------------------------------------------------------------------------
DELETE.CL.WTD:
*-----------------------------------------------------------------------------
    R.ATI.TH.CARDLESS.WITHDRAWAL<CL.WTD.STATUS> = "EXPIRY"
    
	Y.ID.HIS = Y.ID : ";" : Y.CURR.NO
	CALL F.WRITE(FN.ATI.TH.CARDLESS.WITHDRAWAL.HIS, Y.ID.HIS, R.ATI.TH.CARDLESS.WITHDRAWAL)
	
    CALL F.DELETE(FN.ATI.TH.CARDLESS.WITHDRAWAL, Y.ID)

    RETURN

*-----------------------------------------------------------------------------
DELETE.ISO.TRACE:
*-----------------------------------------------------------------------------
    CALL F.DELETE(FN.ATI.TT.ISO.TRACE.CONCAT, Y.ISO.TRACE)

    RETURN
*-----------------------------------------------------------------------------
END
