*-----------------------------------------------------------------------------
    SUBROUTINE ATI.BM.CLR.FT.WTD(Y.ID)
*-----------------------------------------------------------------------------
* Developer Name     : Dwi K
* Development Date   : 20170606
* Description        : Routine
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date               :
* Modified by        :
* Description        :
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ATI.BM.CLR.FT.WTD.COMMON
    $INSERT I_F.ATI.TH.WTD.FT
	$INSERT I_F.ATI.TH.MSG.SERVICE
	
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
DEBUG
    CALL F.READ(FN.ATI.TH.WTD.FT, Y.ID, R.ATI.TH.WTD.FT, F.ATI.TH.WTD.FT ,ERR.ATI.TH.WTD.FT)
	Y.EXP.DATE.TIME = R.ATI.BM.CLR.FT.WTD<WTD.FT.EXP.DATE.TIME>
	
    Y.DATE      = OCONV(DATE(),"D-")
	Y.TIME      = TIMEDATE()
	Y.DATE.TIME = Y.DATE[9,2]:Y.DATE[1,2]:Y.DATE[4,2]:Y.TIME[1,2]:Y.TIME[4,2]
	
	IF Y.DATE.TIME GT Y.EXP.DATE.TIME THEN
       GOSUB DELETE.FT.NAU
	   CALL F.DELETE(FN.ATI.TH.WTD.FT,Y.ID)
	END

    RETURN
*-----------------------------------------------------------------------------
DELETE.FT.NAU:
*-----------------------------------------------------------------------------
	Y.FT.ID = R.ATI.BM.CLR.FT.WTD<WTD.FT.FT.ID>
	
	R.APP.OFS        = ""
	
    Y.OFS.SOURCE     = "GENERIC.OFS.PROCESS"
    Y.APP.NAME       = "EB.SECURE.MESSAGE"
    Y.OFS.FUNCT      = "D"
    Y.PROCESS        = "PROCESS"
    Y.OFS.VERSION    = "FUNDS.TRANSFER,ATI.WTD.OFS"
    Y.GTS.MODE       = 1
    Y.NO.OF.AUTH     = 0
    Y.TRANSACTION.ID = Y.FT.ID

    CALL OFS.BUILD.RECORD(Y.APP.NAME, Y.OFS.FUNCT, Y.PROCESS, Y.OFS.VERSION, Y.GTS.MODE, Y.NO.OF.AUTH, Y.TRANSACTION.ID, R.APP.OFS, Y.OFS.MESSAGE)
	
*    OFS.MSG.ID    = ''
*    OPTIONS       = OPERATOR
*    CALL OFS.POST.MESSAGE(Y.OFS.MESSAGE, OFS.MSG.ID, Y.OFS.SOURCE, OPTIONS)
	
    CALL ALLOCATE.UNIQUE.TIME(UNIQUE.TIME)
    Y.STRING         = UNIQUE.TIME
    Y.CHKSUM         = CHECKSUM(Y.STRING)
    Y.MSG.SERVICE.ID = Y.FT.ID:"-":TODAY:Y.CHKSUM
    
	CALL F.READ(FN.ATI.TH.MSG.SERVICE, Y.MSG.SERVICE.ID, R.ATI.TH.MSG.SERVICE, F.ATI.TH.MSG.SERVICE, ERR.ATI.TH.MSG.SERVICE)
    R.ATI.TH.MSG.SERVICE<1, -1> = Y.OFS.MESSAGE

    X  = OCONV(DATE(),"D-")
    DT = X[9,2]:X[1,2]:X[4,2]:TIME.STAMP[1,2]:TIME.STAMP[4,2]
    R.ATI.TH.MSG.SERVICE<MSS.INPUTTER>   = TNO:"_":OPERATOR
    R.ATI.TH.MSG.SERVICE<MSS.DATE.TIME>  = DT
    R.ATI.TH.MSG.SERVICE<MSS.CO.CODE>    = ID.COMPANY
    R.ATI.TH.MSG.SERVICE<MSS.DEPT.CODE>  = R.USER<6>
    R.ATI.TH.MSG.SERVICE<MSS.AUTHORISER> = TNO:"_":OPERATOR
    R.ATI.TH.MSG.SERVICE<MSS.CURR.NO>    = ATI.TH.MSG.SERVICE<MSS.CURR.NO> + 1

    CALL F.WRITE(FN.ATI.TH.MSG.SERVICE, Y.MSG.SERVICE.ID, R.ATI.TH.MSG.SERVICE)

RETURN
*-----------------------------------------------------------------------------
END

