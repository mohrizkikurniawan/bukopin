*-----------------------------------------------------------------------------
    SUBROUTINE ATI.BM.DEL.GL.MAP.CONCAT
*-----------------------------------------------------------------------------
* Developer Name     : Dhio Faizar Wahyudi
* Development Date   : 20171107
* Description        : Routine to DELETE AT.TT.EXT.GL.MAP.CONCAT
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date            Modified by                Description
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ATI.TT.EXT.GL.MAP.CONCAT
	
	
*-----------------------------------------------------------------------------	
MAIN:
*-----------------------------------------------------------------------------

	GOSUB INIT
	GOSUB PROCESS
	
	RETURN
	
*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
	
	FN.ATI.TT.EXT.GL.MAP.CONCAT = 'F.ATI.TT.EXT.GL.MAP.CONCAT'
	F.ATI.TT.EXT.GL.MAP.CONCAT = ''
	CALL OPF(FN.ATI.TT.EXT.GL.MAP.CONCAT, F.ATI.TT.EXT.GL.MAP.CONCAT)
	
	RETURN
	
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------

	SEL.CMD = "SELECT " : FN.ATI.TT.EXT.GL.MAP.CONCAT
	CALL EB.READLIST(SEL.CMD, SEL.LIST, '', NO.OF.REC, RET.CODE)
	
	FOR Y.LOOP = 1 TO NO.OF.REC
		Y.ATI.TT.EXT.GL.MAP.CONCAT.ID = SEL.LIST<Y.LOOP>
		DELETE F.ATI.TT.EXT.GL.MAP.CONCAT, Y.ATI.TT.EXT.GL.MAP.CONCAT
	NEXT Y.LOOP
	
	RETURN
	
END