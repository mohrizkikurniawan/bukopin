*-----------------------------------------------------------------------------
* <Rating>-181</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.VIN.FT.MIN.AMT.TXN
*-----------------------------------------------------------------------------
* Developer Name     : Dwi K
* Development Date   : 20180215
* Description        : Routine to validate minimum amount transaction
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date            Modified by                Description
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FT.TXN.TYPE.CONDITION
	$INSERT I_F.FUNDS.TRANSFER

*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------
    GOSUB INIT
    GOSUB PROCESS

    RETURN

*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
    FN.FT.TXN.TYPE.CONDITION = 'F.FT.TXN.TYPE.CONDITION'
    F.FT.TXN.TYPE.CONDITION  = ''
    CALL OPF(FN.FT.TXN.TYPE.CONDITION,F.FT.TXN.TYPE.CONDITION)
	
    Y.APP      = 'FT.TXN.TYPE.CONDITION'
    Y.FLD.NAME = 'ATI.MIN.AMT.TXN'
    Y.POS      = ''
    CALL MULTI.GET.LOC.REF(Y.APP,Y.FLD.NAME,Y.POS)
    Y.ATI.MIN.AMT.TXN.POS  = Y.POS<1,1>

    RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    Y.DB.AMOUNT = R.NEW(FT.DEBIT.AMOUNT)
    IF Y.DB.AMOUNT EQ "" THEN
		RETURN
	END
	
    Y.TRANSACTION.TYPE = R.NEW(FT.TRANSACTION.TYPE)
    CALL F.READ(FN.FT.TXN.TYPE.CONDITION, Y.TRANSACTION.TYPE, R.FT.TXN.TYPE.CONDITION, F.FT.TXN.TYPE.CONDITION, FT.TXN.TYPE.CONDITION.ERR)
	Y.ATI.MIN.AMT.TXN = R.FT.TXN.TYPE.CONDITION<FT6.LOCAL.REF, Y.ATI.MIN.AMT.TXN.POS>
	
	IF (Y.ATI.MIN.AMT.TXN NE "") AND (Y.DB.AMOUNT LT Y.ATI.MIN.AMT.TXN) THEN
	   ETEXT = "FT-MIN.AMT.TXN"
	   CALL STORE.END.ERROR
	END
		
    RETURN
*-----------------------------------------------------------------------------
END




