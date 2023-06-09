*-----------------------------------------------------------------------------
* <Rating>-1</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.BM.DEL.JURNAL.TRANS
*-----------------------------------------------------------------------------
* Developer Name     : Dhio Faizar Wahyudi
* Development Date   : 20171024
* Description        : Routine to DELETE JURNAL TRANSACTION
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date            Modified by                Description
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
	
*-----------------------------------------------------------------------------	
MAIN:
*-----------------------------------------------------------------------------

	GOSUB INIT
	GOSUB PROCESS
	
	RETURN
	
*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
	
	FN.ATI.TT.JURNAL.TRANSACTION = 'F.ATI.TT.JURNAL.TRANSACTION'
	F.ATI.TT.JURNAL.TRANSACTION = ''
	CALL OPF(FN.ATI.TT.JURNAL.TRANSACTION, F.ATI.TT.JURNAL.TRANSACTION)
	
	RETURN
	
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
	
	SEL.CMD = "SELECT " : FN.ATI.TT.JURNAL.TRANSACTION
	CALL EB.READLIST(SEL.CMD, SEL.LIST, "", SEL.CNT, SEL.ERR)
	
	FOR Y.LOOP = 1 TO SEL.CNT
		Y.ATI.TT.JURNAL.TRANSACTION.ID = SEL.LIST<Y.LOOP>
		DELETE F.ATI.TT.JURNAL.TRANSACTION, Y.ATI.TT.JURNAL.TRANSACTION.ID
	NEXT Y.LOOP
	
	
	RETURN
	
*-----------------------------------------------------------------------------
END





