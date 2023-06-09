*-----------------------------------------------------------------------------
* <Rating>-1</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.BM.EXT.JURNAL.TRANS
*-----------------------------------------------------------------------------
* Developer Name     : Dhio Faizar Wahyudi
* Development Date   : 20171024
* Description        : Routine to extract JURNAL TRANSACTION
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date            Modified by                Description
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_F.ATI.TH.EXT.CAL.CPL.PARAM
    $INSERT I_F.ATI.TH.EXT.GL.MAP
    $INSERT I_F.TRANSACTION
    $INSERT I_F.RE.TXN.CODE
	
	
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
	
	FN.ATI.TH.EXT.CAL.CPL.PARAM = 'F.ATI.TH.EXT.CAL.CPL.PARAM'
	F.ATI.TH.EXT.CAL.CPL.PARAM  = ''
	CALL OPF(FN.ATI.TH.EXT.CAL.CPL.PARAM,F.ATI.TH.EXT.CAL.CPL.PARAM)
	
	FN.ATI.TH.EXT.GL.MAP = 'F.ATI.TH.EXT.GL.MAP'
	F.ATI.TH.EXT.GL.MAP  = ''
	CALL OPF(FN.ATI.TH.EXT.GL.MAP,F.ATI.TH.EXT.GL.MAP)
	
	FN.ATI.TT.EXT.GL.MAP.CONCAT = 'F.ATI.TT.EXT.GL.MAP.CONCAT'
	F.ATI.TT.EXT.GL.MAP.CONCAT = ''
	CALL OPF(FN.ATI.TT.EXT.GL.MAP.CONCAT, F.ATI.TT.EXT.GL.MAP.CONCAT)	
	
	YAPP = 'TRANSACTION' : @FM : 'RE.TXN.CODE'
	YFLD = 'ATI.GL.CODE' : @FM : 'ATI.GL.CODE'
	YPOS = ''
	
	CALL MULTI.GET.LOC.REF(YAPP, YFLD, YPOS)
	
	Y.ATI.GL.CODE.POS = YPOS<1, 1>
	Y.ATI.GL.CODE.CONSOL.POS = YPOS<2, 1>
	
	Y.LAST.WORKING.DAY = R.DATES(EB.DAT.LAST.WORKING.DAY)
	
	CALL F.READ(FN.ATI.TH.EXT.CAL.CPL.PARAM,'SYSTEM',R.ATI.TH.EXT.CAL.CPL.PARAM,F.ATI.TH.EXT.CAL.CPL.PARAM,ATI.TH.EXT.CAL.CPL.PARAM.ERR)
	
	Y.TEXTFILE = R.ATI.TH.EXT.CAL.CPL.PARAM<CAL.CPL.PAR.TEXTFILE>	
*    Y.FILE        = Y.TEXTFILE : '.' : Y.LAST.WORKING.DAY
	Y.FOLDER      = R.ATI.TH.EXT.CAL.CPL.PARAM<CAL.CPL.PAR.FOLDER>
	Y.SEP         = R.ATI.TH.EXT.CAL.CPL.PARAM<CAL.CPL.PAR.DELIM>
	Y.EXT.COMPANY = R.ATI.TH.EXT.CAL.CPL.PARAM<CAL.CPL.PAR.EXT.COMPANY>
	
	Y.TRANSACTION.DB = R.ATI.TH.EXT.CAL.CPL.PARAM<CAL.CPL.PAR.TRANSACTION.DB>
	Y.TRANSACTION.CR = R.ATI.TH.EXT.CAL.CPL.PARAM<CAL.CPL.PAR.TRANSACTION.CR>
	
	Y.TRANSACTION.SPLIT.DB = R.ATI.TH.EXT.CAL.CPL.PARAM<CAL.CPL.PAR.TRANSACTION.SPLIT.DB>
	Y.TRANSACTION.SPLIT.CR = R.ATI.TH.EXT.CAL.CPL.PARAM<CAL.CPL.PAR.TRANSACTION.SPLIT.CR>
	
	Y.TRANSACTION.ADJ.DB = R.ATI.TH.EXT.CAL.CPL.PARAM<CAL.CPL.PAR.TRANSACTION.ADJ.DB>
	Y.TRANSACTION.ADJ.CR = R.ATI.TH.EXT.CAL.CPL.PARAM<CAL.CPL.PAR.TRANSACTION.ADJ.CR>
	
	F.FLDR.OUTPUT = ''
*	FN.FLDR.OUTPUT = Y.FOLDER
	FN.FLDR.OUTPUT = ".\" : Y.FOLDER
    OPEN FN.FLDR.OUTPUT TO F.FLDR.OUTPUT ELSE
        TEXT = "CANNOT OPEN SOURCE FILE FOLDER"
    END
	
	F.FLDR.BKP = ''
	FN.FLDR.BKP = ".\" : FIELD(Y.FOLDER, "\", 1) :"\backup"
    OPEN FN.FLDR.BKP TO F.FLDR.BKP ELSE
        TEXT = "CANNOT OPEN SOURCE FILE FOLDER"
    END
		
	RETURN
	
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    Y.EXT.COMPANY.CNT    = DCOUNT(Y.EXT.COMPANY,@VM)
	
	Y.TRANSACTION.DB    := VM : Y.TRANSACTION.SPLIT.DB
	Y.TRANSACTION.CR    := VM : Y.TRANSACTION.SPLIT.CR
	
	Y.TRANSACTION.DB.CNT = DCOUNT(Y.TRANSACTION.DB, @VM)
	
	FOR YLOOP.COMP = 1 TO Y.EXT.COMPANY.CNT
	    Y.CURRENT.COMPANY = Y.EXT.COMPANY<1, YLOOP.COMP>
		
		FOR Y.LOOP = 1 TO Y.TRANSACTION.DB.CNT
			Y.ATI.TT.JURNAL.TRANSACTION.ID = Y.CURRENT.COMPANY :"*": Y.TRANSACTION.DB<1, Y.LOOP>
			R.ATI.TT.JURNAL.TRANSACTION    = ''
			CALL F.READ(FN.ATI.TT.JURNAL.TRANSACTION, Y.ATI.TT.JURNAL.TRANSACTION.ID, R.ATI.TT.JURNAL.TRANSACTION, F.ATI.TT.JURNAL.TRANSACTION, ATI.TT.JURNAL.TRANSACTION.ERR)
			
			GOSUB CLEAR.VAR
			GOSUB GET.DATA
		NEXT Y.LOOP	
	NEXT YLOOP.COMP
		
*<20171222_Dhio	
*	IF TODAY[7,2] EQ '01' THEN
*>20171222_Dhio

*	GOSUB PROCESS.SPLIT.TRANSACTION
		
*<20171222_Dhio
*	END
*>20171222_Dhio
	
	GOSUB PROCESS.ADJUSTMENT.TRANSACTION
	
	RETURN
	
*-----------------------------------------------------------------------------
PROCESS.SPLIT.TRANSACTION:
*-----------------------------------------------------------------------------
	
	Y.TRANSACTION.DB = Y.TRANSACTION.SPLIT.DB
	Y.TRANSACTION.CR = Y.TRANSACTION.SPLIT.CR
	
	Y.TRANSACTION.DB.CNT = DCOUNT(Y.TRANSACTION.DB, @VM)
	
	FOR YLOOP.COMP = 1 TO Y.EXT.COMPANY.CNT
		Y.CURRENT.COMPANY = Y.EXT.COMPANY<1, YLOOP.COMP>
		
		FOR Y.LOOP = 1 TO Y.TRANSACTION.DB.CNT
			Y.ATI.TT.JURNAL.TRANSACTION.ID = Y.CURRENT.COMPANY :"*": Y.TRANSACTION.DB<1, Y.LOOP>
			R.ATI.TT.JURNAL.TRANSACTION    = ''
			CALL F.READ(FN.ATI.TT.JURNAL.TRANSACTION, Y.ATI.TT.JURNAL.TRANSACTION.ID, R.ATI.TT.JURNAL.TRANSACTION, F.ATI.TT.JURNAL.TRANSACTION, ATI.TT.JURNAL.TRANSACTION.ERR)
			
			GOSUB CLEAR.VAR
			GOSUB GET.DATA
		NEXT Y.LOOP
	NEXT YLOOP.COMP
	
	RETURN
	
*-----------------------------------------------------------------------------
PROCESS.ADJUSTMENT.TRANSACTION:
*-----------------------------------------------------------------------------
	
	Y.TRANSACTION.DB = Y.TRANSACTION.ADJ.DB
	Y.TRANSACTION.CR = Y.TRANSACTION.ADJ.CR
	
	Y.TRANSACTION.DB.CNT = DCOUNT(Y.TRANSACTION.DB, @VM)
	
	FOR YLOOP.COMP = 1 TO Y.EXT.COMPANY.CNT	
		Y.CURRENT.COMPANY = Y.EXT.COMPANY<1, YLOOP.COMP>
		
		FOR Y.LOOP = 1 TO Y.TRANSACTION.DB.CNT
			Y.ATI.TT.JURNAL.TRANSACTION.ID = Y.CURRENT.COMPANY :"*": Y.TRANSACTION.CR<1, Y.LOOP>
			R.ATI.TT.JURNAL.TRANSACTION    = ''
			CALL F.READ(FN.ATI.TT.JURNAL.TRANSACTION, Y.ATI.TT.JURNAL.TRANSACTION.ID, R.ATI.TT.JURNAL.TRANSACTION, F.ATI.TT.JURNAL.TRANSACTION, ATI.TT.JURNAL.TRANSACTION.ERR)
			
			GOSUB CLEAR.VAR
			GOSUB GET.DATA
		NEXT Y.LOOP
	NEXT YLOOP.COMP
	
	RETURN
*-----------------------------------------------------------------------------
GET.DATA:
*-----------------------------------------------------------------------------
	
	Y.AMT.MVMT = R.ATI.TT.JURNAL.TRANSACTION
	
	IF Y.AMT.MVMT EQ 0 OR Y.AMT.MVMT EQ '' THEN
		RETURN
	END	
	
****Debit
	IF FIELD(Y.TRANSACTION.DB<1, Y.LOOP>,"*",3) NE '' THEN
		Y.TRANSACTION.VAL = FIELD(Y.TRANSACTION.DB<1, Y.LOOP>,"*",2) :"*": FIELD(Y.TRANSACTION.DB<1, Y.LOOP>,"*",3)
	END ELSE
		Y.TRANSACTION.VAL = FIELD(Y.TRANSACTION.DB<1, Y.LOOP>,"*",2)
	END
	
	GOSUB GET.GL.CODE
	Y.GL.CODE.DB = Y.GL.CODE
	
	Y.GL.CODE = Y.SAVE.GL.CODE
	GOSUB GET.ACCOUNT.TYPE
	Y.ACCOUNT.TYPE.DB = Y.ACCOUNT.TYPE	
	
****Credit
	IF FIELD(Y.TRANSACTION.CR<1, Y.LOOP>,"*",3) NE '' THEN
		Y.TRANSACTION.VAL = FIELD(Y.TRANSACTION.CR<1, Y.LOOP>,"*",2) :"*": FIELD(Y.TRANSACTION.CR<1, Y.LOOP>,"*",3)
	END ELSE
		Y.TRANSACTION.VAL = FIELD(Y.TRANSACTION.CR<1, Y.LOOP>,"*",2)
	END

*<03092020_Glend	
****CURRENCY CREDIT
	IF FIELD(Y.TRANSACTION.CR<1, Y.LOOP>,"*",2) NE '' THEN
		Y.TRX.CURR.CR 	= FIELD(Y.TRANSACTION.CR<1, Y.LOOP>,"*",2)
		Y.FIELD.CURR.CR = FIELD(Y.TRX.CURR.CR,".",4)
			
	END ELSE
		Y.FIELD.CURR.CR  = ""
	END
*>03092020_Glend	
	
	GOSUB GET.GL.CODE
	Y.GL.CODE.CR = Y.GL.CODE
	
	Y.GL.CODE = Y.SAVE.GL.CODE
	GOSUB GET.ACCOUNT.TYPE
	Y.ACCOUNT.TYPE.CR = Y.ACCOUNT.TYPE
	
	Y.BIT.102 = Y.GL.CODE.DB
	Y.BIT.103 = Y.GL.CODE.CR
	
	Y.BIT.49 = Y.FIELD.CURR.CR
	Y.BIT.4  = ABS(EREPLACE(FMT(Y.AMT.MVMT, "R2"),".",""))
	Y.BIT.13 = Y.LAST.WORKING.DAY
	Y.BIT.62 = ''
	
	Y.OUT  = Y.BIT.102 
	Y.OUT := Y.SEP : Y.BIT.103
	Y.OUT := Y.SEP : Y.BIT.49
	Y.OUT := Y.SEP : Y.BIT.4
	Y.OUT := Y.SEP : Y.BIT.13
	Y.OUT := Y.SEP : Y.ACCOUNT.TYPE.DB
	Y.OUT := Y.SEP : Y.ACCOUNT.TYPE.CR
	
	Y.PRINT = Y.OUT
	
*Write extract 
	
    Y.FILE = Y.TEXTFILE : '.' : Y.LAST.WORKING.DAY
    OPENSEQ FN.FLDR.OUTPUT,Y.FILE TO F.OUT ELSE
        CREATE F.OUT ELSE
            RETURN
        END
    END	

    WRITESEQ Y.PRINT APPEND TO F.OUT ELSE
        RETURN
    END
	
	CLOSESEQ F.OUT
	
*Write backup
    OPENSEQ FN.FLDR.BKP,Y.FILE TO F.OUT.BKP ELSE
        CREATE F.OUT.BKP ELSE
            RETURN
        END
    END	

    WRITESEQ Y.PRINT APPEND TO F.OUT.BKP ELSE
        RETURN
    END
	
	CLOSESEQ F.OUT.BKP
	

	RETURN

*-----------------------------------------------------------------------------	
CLEAR.VAR:
*-----------------------------------------------------------------------------	

	Y.BIT.102         = ''
	Y.BIT.103         = ''
	Y.BIT.49          = ''
	Y.BIT.4           = ''
	Y.BIT.13          = ''
	Y.ACCOUNT.TYPE.DB = ''
	Y.ACCOUNT.TYPE.CR = ''
	Y.BIT.62          = ''
	
	RETURN
*-----------------------------------------------------------------------------
GET.GL.CODE:
*-----------------------------------------------------------------------------
	
	CALL F.READ(FN.ATI.TT.EXT.GL.MAP.CONCAT, Y.TRANSACTION.VAL, R.ATI.TT.EXT.GL.MAP.CONCAT, F.ATI.TT.EXT.GL.MAP.CONCAT, ATI.TT.EXT.GL.MAP.CONCAT.ERR)
	Y.GL.CODE = R.ATI.TT.EXT.GL.MAP.CONCAT
	
	Y.SAVE.GL.CODE = Y.GL.CODE
	IF LEN(Y.GL.CODE) EQ 6 THEN
	   IF Y.CURRENT.COMPANY[4] EQ "0001" THEN
	      Y.GL.CODE := "0101"
	   END ELSE
	      Y.GL.CODE := Y.CURRENT.COMPANY[4]
	   END 
	END

	RETURN
	
*-----------------------------------------------------------------------------
GET.ACCOUNT.TYPE:
*-----------------------------------------------------------------------------

	CALL F.READ(FN.ATI.TH.EXT.GL.MAP, Y.GL.CODE, R.ATI.TH.EXT.GL.MAP, F.ATI.TH.EXT.GL.MAP, ATI.TH.EXT.GL.MAP.ERR)
	Y.ACCOUNT.TYPE = R.ATI.TH.EXT.GL.MAP<GL.MAP.ACCOUNT.TYPE>

	RETURN
*-----------------------------------------------------------------------------
END