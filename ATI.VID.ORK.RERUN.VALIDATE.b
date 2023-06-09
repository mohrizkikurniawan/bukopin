*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.VID.ORK.RERUN.VALIDATE
*-----------------------------------------------------------------------------
* Developer Name     : Aristya 
* Development Date   : 20170712
* Description        : Routine validate only status ERROR 
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date            Modified by                Description
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
	$INSERT I_F.ATI.TH.INTF.ORK.DATA	

*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------
    GOSUB INIT
    GOSUB PROCESS

    RETURN
*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
	FN.ATI.TH.INTF.ORK.DATA = "F.ATI.TH.INTF.ORK.DATA"
	F.ATI.TH.INTF.ORK.DATA = ""
	CALL OPF(FN.ATI.TH.INTF.ORK.DATA, F.ATI.TH.INTF.ORK.DATA)

    RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------	
	Y.ID.ORK = COMI
	
	CALL F.READ(FN.ATI.TH.INTF.ORK.DATA, Y.ID.ORK, R.ATI.TH.INTF.ORK.DATA, F.ATI.TH.INTF.ORK.DATA, ERR.ATI.TH.INTF.ORK.DATA)
	Y.STATUS    = R.ATI.TH.INTF.ORK.DATA<ORK.DATA.STATUS>
	
	IF Y.STATUS NE 'ERROR' THEN
        E = "Hanya untuk status ERROR"
        CALL ERR
	END
	
	RETURN	
END	