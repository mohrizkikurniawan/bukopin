*-----------------------------------------------------------------------------
* <Rating>-181</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.VIN.FT.WTD.ATM
*-----------------------------------------------------------------------------
* Developer Name     : Dwi K
* Development Date   : 20170605
* Description        : Routine for
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date            Modified by                Description
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
	$INSERT I_F.ATI.TH.WTD.FT
	$INSERT I_F.CUSTOMER
	$INSERT I_F.ATI.TH.INTF.GLOBAL.PARAM

*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------
    GOSUB INIT
    GOSUB PROCESS

    RETURN

*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
    FN.ATI.TH.WTD.FT = 'F.ATI.TH.WTD.FT'
    F.ATI.TH.WTD.FT  = ''
    CALL OPF(FN.ATI.TH.WTD.FT,F.ATI.TH.WTD.FT)
	
    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER  = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
	
    FN.ATI.TH.INTF.GLOBAL.PARAM = "F.ATI.TH.INTF.GLOBAL.PARAM"
	F.ATI.TH.INTF.GLOBAL.PARAM  = ""
	CALL OPF(FN.ATI.TH.INTF.GLOBAL.PARAM, F.ATI.TH.INTF.GLOBAL.PARAM)

    Y.APP      = 'FUNDS.TRANSFER'
    Y.FLD.NAME = 'ATI.TRANS.REF'
    Y.POS      = ''
    CALL MULTI.GET.LOC.REF(Y.APP,Y.FLD.NAME,Y.POS)
    Y.ATI.TRANS.REF.POS  = Y.POS<1,1>

    RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
	
	Y.DATE      = OCONV(DATE(),"D-")
	Y.TIME      = TIMEDATE()
	Y.DATE.TIME = Y.DATE[9,2]:Y.DATE[1,2]:Y.DATE[4,2]:Y.TIME[1,2]:Y.T
	
	CALL ALLOCATE.UNIQUE.TIME(UNIQUE.TIME)
	Y.STRING   = "100196":Y.DATE.TIME:UNIQUE.TIME
	CONVERT "." TO "" IN Y.STRING
	Y.CHKSUM   = CHECKSUM(Y.STRING)
	Y.REF.ID   = RND(9):Y.CHKSUM
	
	Y.CUST.ID = R.NEW(FT.DEBIT.CUSTOMER)
	CALL F.READ(FN.CUSTOMER, Y.CUST.ID, R.CUSTOMER, F.CUSTOMER, ERR.CUSTOMER)
	Y.MOBILE.NO = R.CUSTOMER<EB.CUS.SMS.1>
	
	Y.WTD.FT.ID = Y.MOBILE.NO:"-":Y.REF.ID
	CALL F.READ(FN.ATI.TH.WTD.FT, Y.WTD.FT.ID, R.ATI.TH.WTD.FT, F.ATI.TH.WTD.FT, ERR.ATI.TH.WTD.FT)
	R.ATI.TH.WTD.FT<WTD.FT.CUSTOMER>       = R.NEW(FT.DEBIT.CUSTOMER)
	R.ATI.TH.WTD.FT<WTD.FT.STATUS>         = "INPUT"
	R.ATI.TH.WTD.FT<WTD.FT.MOBILE.NO>      = Y.MOBILE.NO
	R.ATI.TH.WTD.FT<WTD.FT.DEBIT.ACCOUNT>  = R.NEW(FT.DEBIT.ACCT.NO)
	R.ATI.TH.WTD.FT<WTD.FT.AMOUNT>         = R.NEW(FT.DEBIT.AMOUNT)
	R.ATI.TH.WTD.FT<WTD.FT.FT.ID>          = ID.NEW
	R.ATI.TH.WTD.FT<WTD.FT.VALUE.DATE>     = R.NEW(FT.DEBIT.VALUE.DATE)
	
	Y.DATE      = OCONV(DATE(),"D-")
	Y.TIME      = TIMEDATE()
	Y.DATE.TIME = Y.DATE[9,2]:Y.DATE[1,2]:Y.DATE[4,2]:Y.TIME[1,2]:Y.TIME[4,2]
	
	CALL F.READ(FN.ATI.TH.INTF.GLOBAL.PARAM, "SYSTEM", R.ATI.TH.INTF.GLOBAL.PARAM, F.ATI.TH.INTF.GLOBAL.PARAM, ERR.ATI.TH.INTF.GLOBAL.PARAM)
	
	Y.DURATION   = R.ATI.TH.INTF.GLOBAL.PARAM<GLOBAL.PARAM.COT.WTD.ATM>
	Y.START.TIME = (Y.TIME[1,2] * 60) + Y.TIME[4,2]
	Y.END.TIME   = Y.START.TIME + Y.DURATION
	Y.MOD        = MOD(Y.END.TIME, 60)
	PRECISION 0
	Y.DIF        = Y.END.TIME/60
	R.ATI.TH.WTD.FT<WTD.FT.EXP.DATE.TIME> = Y.DATE[9,2]:Y.DATE[1,2]:Y.DATE[4,2]:FMT(Y.DIF, "R%2"):FMT(Y.MOD, "R%2")
	CALL F.WRITE(FN.ATI.TH.WTD.FT, Y.WTD.FT.ID, R.ATI.TH.WTD.FT)

    R.NEW(FT.LOCAL.REF)<1,Y.ATI.TRANS.REF.POS> = Y.WTD.FT.ID
		
    RETURN
*-----------------------------------------------------------------------------
END




