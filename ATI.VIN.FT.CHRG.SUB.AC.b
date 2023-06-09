*-----------------------------------------------------------------------------
* <Rating>-181</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.VIN.FT.CHRG.SUB.AC
*-----------------------------------------------------------------------------
* Developer Name     : Dwi K
* Development Date   : 20171219
* Description        : Routine for default closure charges
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
	$INSERT I_F.ATI.TH.INTF.GLOBAL.PARAM
	$INSERT I_F.STANDING.ORDER
	$INSERT I_F.FT.COMMISSION.TYPE

*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------
    GOSUB INIT
    GOSUB PROCESS

    RETURN

*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
    FN.ATI.TH.INTF.GLOBAL.PARAM = 'F.ATI.TH.INTF.GLOBAL.PARAM'
    F.ATI.TH.INTF.GLOBAL.PARAM  = ''
    CALL OPF(FN.ATI.TH.INTF.GLOBAL.PARAM,F.ATI.TH.INTF.GLOBAL.PARAM)
	
	FN.STO.ACCOUNT.LIST = 'F.STO.ACCOUNT.LIST'
	F.STO.ACCOUNT.LIST  = ''
	CALL OPF(FN.STO.ACCOUNT.LIST, F.STO.ACCOUNT.LIST)

    FN.STANDING.ORDER = 'F.STANDING.ORDER'
    F.STANDING.ORDER  = ''
    CALL OPF(FN.STANDING.ORDER,F.STANDING.ORDER)
	
	FN.FT.COMMISSION.TYPE = 'F.FT.COMMISSION.TYPE'
	F.FT.COMMISSION.TYPE  = ''
	CALL OPF(FN.FT.COMMISSION.TYPE, F.FT.COMMISSION.TYPE)
	
    RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    Y.DEBIT.ACCT.NO  = R.NEW(FT.DEBIT.ACCT.NO)
	Y.CREDIT.ACCT.NO = R.NEW(FT.CREDIT.ACCT.NO)
	
*	SEL.CMD  = "SELECT ":FN.STANDING.ORDER:" WITH CPTY.ACCT.NO EQ ":Y.DEBIT.ACCT.NO
*	SEL.LIST = ""
*	CALL EB.READLIST(SEL.CMD, SEL.LIST, "", Y.RECORD, ERR)
	
	CALL F.READ(FN.STO.ACCOUNT.LIST, Y.CREDIT.ACCT.NO, R.STO.ACCOUNT.LIST, F.STO.ACCOUNT.LIST, STO.LIST.ERR)
	Y.CNT.REC = DCOUNT(R.STO.ACCOUNT.LIST, FM)
	
	FOR YLOOP = 2 TO Y.CNT.REC
		Y.CURR.STO.ID = Y.CREDIT.ACCT.NO:'.':R.STO.ACCOUNT.LIST<YLOOP> 
		CALL F.READ(FN.STANDING.ORDER, Y.CURR.STO.ID, R.STANDING.ORDER, F.STANDING.ORDER, STO.ERR)
		Y.CPTY.ACCT.NO = R.STANDING.ORDER<STO.CPTY.ACCT.NO>
		
		IF Y.CPTY.ACCT.NO EQ Y.DEBIT.ACCT.NO THEN
			CALL F.READ(FN.ATI.TH.INTF.GLOBAL.PARAM, "SYSTEM", R.ATI.TH.INTF.GLOBAL.PARAM, F.ATI.TH.INTF.GLOBAL.PARAM, GLOBAL.PARAM.ERR)
			Y.CLOSE.AC.CHARGE = R.ATI.TH.INTF.GLOBAL.PARAM<GLOBAL.PARAM.CLOSE.AC.CHARGE>
			
			R.NEW(FT.COMMISSION.CODE) = "CREDIT LESS CHARGES"
			R.NEW(FT.COMMISSION.TYPE) = Y.CLOSE.AC.CHARGE
			
			CALL F.READ(FN.FT.COMMISSION.TYPE, Y.CLOSE.AC.CHARGE, R.FT.COMMISSION.TYPE, F.FT.COMMISSION.TYPE, FT.COMM.TYPE.ERR)
			Y.CHARGE.AMOUNT = R.FT.COMMISSION.TYPE<FT4.FLAT.AMT>
			Y.CURRENCY      = R.FT.COMMISSION.TYPE<FT4.CURRENCY>
			
			R.NEW(FT.COMMISSION.AMT) = Y.CURRENCY:" ":Y.CHARGE.AMOUNT
		END
	NEXT YLOOP
	
*	IF Y.RECORD THEN
*		CALL F.READ(FN.ATI.TH.INTF.GLOBAL.PARAM, "SYSTEM", R.ATI.TH.INTF.GLOBAL.PARAM, F.ATI.TH.INTF.GLOBAL.PARAM, GLOBAL.PARAM.ERR)
*		Y.CLOSE.AC.CHARGE = R.ATI.TH.INTF.GLOBAL.PARAM<GLOBAL.PARAM.CLOSE.AC.CHARGE>
*		
*		R.NEW(FT.COMMISSION.TYPE) = Y.CLOSE.AC.CHARGE
*	END
		
    RETURN
*-----------------------------------------------------------------------------
END




