*-----------------------------------------------------------------------------
* <Rating>-181</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.VIN.FT.REP.VAL.CODE
*-----------------------------------------------------------------------------
* Developer Name     : Dwi K
* Development Date   : 20170925
* Description        : Routine for generate validation code
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
	$INSERT I_F.ATI.TH.REPRINT.DEALSLIP

*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------
    GOSUB INIT
	
	BEGIN CASE
	CASE APPLICATION EQ "FUNDS.TRANSFER"
		GOSUB PROCESS.FT
	CASE APPLICATION EQ "ATI.TH.REPRINT.DEALSLIP"
		GOSUB PROCESS.REPRINT
	END CASE

    RETURN

*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
    FN.FUNDS.TRANSFER = "F.FUNDS.TRANSFER"
	F.FUNDS.TRANSFER  = ""
	CALL OPF(FN.FUNDS.TRANSFER, F.FUNDS.TRANSFER)
	
	FN.ATI.TH.REPRINT.DEALSLIP = "F.ATI.TH.REPRINT.DEALSLIP"
	F.ATI.TH.REPRINT.DEALSLIP  = ""
	CALL OPF(FN.ATI.TH.REPRINT.DEALSLIP, F.ATI.TH.REPRINT.DEALSLIP)
	
	FN.ATI.TH.REPRINT.DEALSLIP.HIS = "F.ATI.TH.REPRINT.DEALSLIP$HIS"
	F.ATI.TH.REPRINT.DEALSLIP.HIS  = ""
	CALL OPF(FN.ATI.TH.REPRINT.DEALSLIP.HIS, F.ATI.TH.REPRINT.DEALSLIP.HIS)
	
    Y.APP      = 'FUNDS.TRANSFER'
    Y.FLD.NAME = 'ATI.VAL.CODE'
    Y.POS      = ''
    CALL MULTI.GET.LOC.REF(Y.APP,Y.FLD.NAME,Y.POS)
    Y.ATI.VAL.CODE.POS  = Y.POS<1,1>

    RETURN

*-----------------------------------------------------------------------------
PROCESS.FT:
*-----------------------------------------------------------------------------
    Y.VAL.CODE = RND(100)
	R.NEW(FT.LOCAL.REF)<1,Y.ATI.VAL.CODE.POS> = FMT(Y.VAL.CODE, 'R%2')

    RETURN
*-----------------------------------------------------------------------------
PROCESS.REPRINT:
*-----------------------------------------------------------------------------
    Y.VAL.CODE.LIST = ""
	CALL F.READ(FN.FUNDS.TRANSFER, ID.NEW, R.FUNDS.TRANSFER, F.FUNDS.TRANSFER, ERR.FT)
	Y.VAL.CODE.LIST<-1> = R.FUNDS.TRANSFER<FT.LOCAL.REF,Y.ATI.VAL.CODE.POS>
	
    Y.ID = ID.NEW
	CALL F.READ(FN.ATI.TH.REPRINT.DEALSLIP, Y.ID, R.ATI.TH.REPRINT.DEALSLIP, F.ATI.TH.REPRINT.DEALSLIP, ERR.REP)
	Y.VAL.CODE.LIST<-1> = R.ATI.TH.REPRINT.DEALSLIP<REPRINT.DS.VALIDATION.CODE>
		
	Y.CURR.NO = R.NEW(REPRINT.DS.CURR.NO) -1
	FOR YLOOP = 1 TO Y.CURR.NO
	    Y.ID.HIS = ID.NEW:';':YLOOP
		CALL F.READ(FN.ATI.TH.REPRINT.DEALSLIP.HIS, Y.ID.HIS, R.ATI.TH.REPRINT.DEALSLIP.HIS, F.ATI.TH.REPRINT.DEALSLIP.HIS, ERR.REP.HIS)
	    Y.VAL.CODE.LIST<-1> = R.ATI.TH.REPRINT.DEALSLIP.HIS<REPRINT.DS.VALIDATION.CODE>
	NEXT YLOOP
	
	Y.FLAG = 1
	LOOP
    WHILE Y.FLAG = 1 DO
	    Y.VAL.CODE = RND(100)
		FIND Y.VAL.CODE IN Y.VAL.CODE.LIST SETTING POS THEN
			Y.FLAG = 1
		END ELSE
			Y.FLAG = 0
		END
	REPEAT
	
	R.NEW(REPRINT.DS.VALIDATION.CODE) = FMT(Y.VAL.CODE, 'R%2')    
	
    RETURN
*-----------------------------------------------------------------------------
END

