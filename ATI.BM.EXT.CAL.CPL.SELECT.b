*-----------------------------------------------------------------------------
* <Rating>20</Rating>
*-----------------------------------------------------------------------------
	SUBROUTINE ATI.BM.EXT.CAL.CPL.SELECT
*-----------------------------------------------------------------------------
* Developer Name     : ATI
* Development Date   : 
* Description        : 
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date            Modified by                Description
*-----------------------------------------------------------------------------	
	$INSERT I_COMMON
	$INSERT I_EQUATE
	$INSERT I_TSA.COMMON
	$INSERT I_F.DATES
	$INSERT I_F.ATI.TH.EXT.GL.MAP
	$INSERT I_F.ATI.TH.EXT.CAL.CPL.PARAM
	$INSERT I_ATI.BM.EXT.CAL.CPL.COMMON

	SEL.CMD  = 'SELECT ':FN.CONSOLIDATE.ASST.LIAB
	CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,'')
		
	SEL.CMD1 = 'SELECT ':FN.CONSOLIDATE.PRFT.LOSS
	CALL EB.READLIST(SEL.CMD1,SEL.LIST1,'',NO.OF.REC1,'')
		
	Y.ALL.DATA = SEL.LIST  : FM : SEL.LIST1
		
	CALL BATCH.BUILD.LIST('',Y.ALL.DATA)
	
	RETURN
END	