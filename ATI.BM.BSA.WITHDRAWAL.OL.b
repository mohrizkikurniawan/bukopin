*-----------------------------------------------------------------------------
* <Rating>-40</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.BM.BSA.WITHDRAWAL.OL(Y.ID)
*-----------------------------------------------------------------------------
* Developer Name     : Dwi K
* Development Date   : 20180502
* Description        : Service BSA withdrawal
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date            Modified by                Description
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ATI.TH.AB.BTUNAI.CASHWD.RSV
    $INSERT I_ATI.BM.BSA.WITHDRAWAL.OL.COMMON

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
    CALL F.READ(FN.ATI.TH.AB.BTUNAI.CASHWD.RSV, Y.ID, R.ATI.TH.AB.BTUNAI.CASHWD.RSV, F.ATI.TH.AB.BTUNAI.CASHWD.RSV, ERR.ATI.TH.AB.BTUNAI.CASHWD.RSV)
    Y.STATUS        = R.ATI.TH.AB.BTUNAI.CASHWD.RSV<AB.WTD.RSV.STATUS>
    Y.FT.ID         = R.ATI.TH.AB.BTUNAI.CASHWD.RSV<AB.WTD.RSV.FT.ID.RESV>
    Y.EXP.DATE.TIME = R.ATI.TH.AB.BTUNAI.CASHWD.RSV<AB.WTD.RSV.EXP.DATE.TIME>
    Y.CURR.NO       = R.ATI.TH.AB.BTUNAI.CASHWD.RSV<AB.WTD.RSV.CURR.NO>
    Y.CO.CODE       = R.ATI.TH.AB.BTUNAI.CASHWD.RSV<AB.WTD.RSV.CO.CODE>

    IF Y.DATE.TIME GT Y.EXP.DATE.TIME[1,10] THEN
        GOSUB DELETE.FT
        GOSUB DELETE.BSA.WTD
    END

    RETURN

*-----------------------------------------------------------------------------
DELETE.FT:
*-----------------------------------------------------------------------------
    Y.APP.NAME       = "FUNDS.TRANSFER"
    Y.OFS.FUNCT      = "D"
    Y.PROCESS        = "PROCESS"
*change to auth version because FUNDS.TRANSFER,ATI.BSA.CASHWTD.RSV GTS is set to 4 (IHLD only)
*Y.OFS.VERSION    = Y.APP.NAME : ",ATI.BSA.CASHWTD.RSV"
    Y.OFS.VERSION    = Y.APP.NAME : ",ATI.INPUT.OFS"
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
DELETE.BSA.WTD:
*-----------------------------------------------------------------------------
    R.ATI.TH.AB.BTUNAI.CASHWD.RSV<AB.WTD.RSV.STATUS> = "EXPIRY"
    
	Y.ID.HIS = Y.ID : ";" : Y.CURR.NO
	R.ATI.TH.AB.BTUNAI.CASHWD.RSV.HIS = R.ATI.TH.AB.BTUNAI.CASHWD.RSV
	CALL F.WRITE(FN.ATI.TH.AB.BTUNAI.CASHWD.RSV.HIS, Y.ID.HIS, R.ATI.TH.AB.BTUNAI.CASHWD.RSV.HIS)
	
    CALL F.DELETE(FN.ATI.TH.AB.BTUNAI.CASHWD.RSV, Y.ID)

    RETURN

*-----------------------------------------------------------------------------
END
