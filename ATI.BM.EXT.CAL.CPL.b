*-----------------------------------------------------------------------------
* <Rating>20</Rating>
*-----------------------------------------------------------------------------
	SUBROUTINE ATI.BM.EXT.CAL.CPL(Y.ID)
*-----------------------------------------------------------------------------
* Developer Name     : ATI
* Development Date   : 
* Description        : 
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date            Modified by                Description
*-----------------------------------------------------------------------------	
* 20170803        Dhio Faizar Wahyudi        add field ACCOUNT.TYPE and change DESCRIPTION to CONSOL KEY
* 20171025        Dhio Faizar Wahyudi        Change logic to take amount from CONSOLIDATE.ASST.LIAB
*-----------------------------------------------------------------------------	
	$INSERT I_COMMON
	$INSERT I_EQUATE
	$INSERT I_F.DATES
	$INSERT I_F.ATI.TH.EXT.GL.MAP
	$INSERT I_F.ATI.TH.EXT.CAL.CPL.PARAM
	$INSERT I_F.CONSOLIDATE.PRFT.LOSS
	$INSERT I_F.CONSOLIDATE.ASST.LIAB
	$INSERT I_ATI.BM.EXT.CAL.CPL.COMMON
	
	Y.LAST.DATE = R.DATES(EB.DAT.LAST.WORKING.DAY)
	Y.DEF.GL    = Y.GL.UNMAP		
	
*<20170802_Dhio
*	OPEN Y.FOLDER TO F.FOLDER ELSE
*		CRT.CMD = "CREATE.FILE ":Y.FOLDER:" TYPE=UD"
*		EXECUTE CRT.CMD
*		OPEN Y.FOLDER TO F.OUT ELSE
*			TEXT = "CANNOT OPEN SOURCE FILE FOLDER"
*		END
*    END
	
*	OPEN Y.FLDR.BKP TO F.FLDR.BKP ELSE
*		CRT.CMD = "CREATE.FILE ":Y.FLDR.BKP:" TYPE=UD"
*		EXECUTE CRT.CMD
*		OPEN Y.FLDR.BKP TO F.OUT ELSE
*			TEXT = "CANNOT OPEN SOURCE FILE FOLDER"
*		END
*    END
*>20170802_Dhio

	Y.CONSOL.KEY = ''
	GOSUB CLEAR.VAR
	
	IF Y.ID[1,2] EQ "PL" THEN
		GOSUB PROCESS.CPL
	END ELSE
		GOSUB PROCESS.CAL
	END
		
	RETURN

*-----------------------------------------------------------------------------
PROCESS.CPL:
*==========	
	CALL F.READ(FN.CONSOLIDATE.PRFT.LOSS,Y.ID,R.CONSOLIDATE.PRFT.LOSS,F.CONSOLIDATE.PRFT.LOSS,CONSOLIDATE.PRFT.LOSS.ERR)
	
	IF R.CONSOLIDATE.PRFT.LOSS<RE.PTL.DATE.LAST.UPDATE> EQ Y.LAST.DATE THEN
		Y.CCY    = R.CONSOLIDATE.PRFT.LOSS<RE.PTL.CURRENCY>
		Y.DB.AMT = R.CONSOLIDATE.PRFT.LOSS<RE.PTL.DEBIT.MOVEMENT>
		Y.CR.AMT = R.CONSOLIDATE.PRFT.LOSS<RE.PTL.CREDIT.MOVEMENT>
		
		Y.AMT.MVMT = Y.DB.AMT + Y.CR.AMT
		
		IF Y.GL.MVMT NE 0 THEN
			Y.ID.MAPPING = FIELD(Y.ID, ".",1) :".": FIELD(Y.ID, ".",2) :".": FIELD(Y.ID, ".",3)			
			FINDSTR Y.ID.MAPPING IN Y.MAPPING.EX.ALL SETTING AP.POS THEN
				RETURN
			END
			
			FINDSTR Y.ID.MAPPING IN Y.MAPPING.ALL SETTING AP.POS THEN			
				Y.GL = FIELD(Y.MAPPING.ALL<AP.POS>, "*", 3)
			END ELSE
				Y.ACCOUNT.TYPE = "50"
				Y.GL = Y.DEF.GL
			END
			
			IF Y.ACCOUNT.TYPE EQ "" THEN
				CALL F.READ(FN.ATI.TH.EXT.GL.MAP, Y.GL, R.ATI.TH.EXT.GL.MAP, F.ATI.TH.EXT.GL.MAP, ATI.TH.EXT.GL.MAP.ERR)
				Y.ACCOUNT.TYPE = R.ATI.TH.EXT.GL.MAP<GL.MAP.ACCOUNT.TYPE>
			END
			
			GOSUB CREATE.TEXTFILE
		END
	END
	
	RETURN

*-----------------------------------------------------------------------------
PROCESS.CAL:
*===========	
	CALL F.READ(FN.CONSOLIDATE.ASST.LIAB,Y.ID,R.CONSOLIDATE.ASST.LIAB,F.CONSOLIDATE.ASST.LIAB,ERR.CONSOLIDATE.ASST.LIAB)
	
	IF R.CONSOLIDATE.ASST.LIAB<RE.ASL.DATE.LAST.UPDATE> EQ Y.LAST.DATE THEN		
		 Y.CNT = DCOUNT(R.CONSOLIDATE.ASST.LIAB<RE.ASL.TYPE>, @VM)
		 Y.CCY = R.CONSOLIDATE.ASST.LIAB<RE.ASL.CURRENCY>
		 
		 FOR Y.I=1 TO Y.CNT
			Y.TYPE = R.CONSOLIDATE.ASST.LIAB<RE.ASL.TYPE, Y.I>
			Y.ID.MAPPING = FIELD(Y.ID, ".",1) :".": FIELD(Y.ID, ".",2) :".": FIELD(Y.ID, ".",3):".": FIELD(Y.ID, ".",4):".": FIELD(Y.ID, ".",5) :"*": Y.TYPE
						
			Y.DB.AMT  = R.CONSOLIDATE.ASST.LIAB<RE.ASL.CREDIT.MOVEMENT, Y.I>
			Y.CR.AMT  = R.CONSOLIDATE.ASST.LIAB<RE.ASL.DEBIT.MOVEMENT, Y.I>		
*<Dhio_20171025			
*			Y.GL.MVMT = Y.DB.AMT + Y.CR.AMT
			Y.GL.MVMT = Y.DB.AMT
*>Dhio_20171025
			
			Y.ACCOUNT.TYPE.LIST<-1> = ""
			
			IF Y.GL.MVMT NE 0 THEN
				FINDSTR Y.ID.MAPPING IN Y.MAPPING.EX.ALL SETTING AP.POS THEN
					CONTINUE
				END			
				
				FINDSTR Y.ID.MAPPING IN Y.MAPPING.ALL SETTING AP.POS THEN			
					Y.GL.TEMP = FIELD(Y.MAPPING.ALL<AP.POS>, "*", 3)
				END ELSE
					Y.ACCOUNT.TYPE.LIST<-1> = "50"
					Y.GL.TEMP = Y.DEF.GL
				END
				
				Y.CATEG = FIELD(Y.ID, ".",5)
				IF Y.CATEG EQ "6002" THEN
					Y.NARRATIVE = "Sub Account Interest"
				END
				
				FIND Y.GL.TEMP IN Y.GL.LIST SETTING GL.POS THEN					
					Y.AMT.LIST<GL.POS> += Y.GL.MVMT
				END ELSE
					Y.GL.LIST<-1>  = Y.GL.TEMP
					Y.AMT.LIST<-1> = Y.GL.MVMT
				END
				
*<20170803_Dhio
				Y.TYPE.LIST<-1> = Y.TYPE
*>20170803_Dhio

			END
		 NEXT Y.I
		 
		 Y.CNT.GL = DCOUNT(Y.GL.LIST, @FM)
		 FOR Y.I=1 TO Y.CNT.GL
			Y.GL         = Y.GL.LIST<Y.I>
*<20170803_Dhio
			IF Y.ACCOUNT.TYPE.LIST<Y.I> EQ "" THEN
				CALL F.READ(FN.ATI.TH.EXT.GL.MAP, Y.GL, R.ATI.TH.EXT.GL.MAP, F.ATI.TH.EXT.GL.MAP, ATI.TH.EXT.GL.MAP.ERR)
				Y.ACCOUNT.TYPE = R.ATI.TH.EXT.GL.MAP<GL.MAP.ACCOUNT.TYPE>
			END ELSE
				Y.ACCOUNT.TYPE = Y.ACCOUNT.TYPE.LIST<Y.I>
			END
*>20170803_Dhio
			
			Y.AMT.MVMT   = Y.AMT.LIST<Y.I>	
			Y.CONSOL.KEY = "." : Y.TYPE.LIST<Y.I>
			GOSUB CREATE.TEXTFILE		 
		 NEXT Y.I		 		 
	END
		
	RETURN

*-----------------------------------------------------------------------------
CREATE.TEXTFILE:
*===============
	
	IF Y.AMT.MVMT EQ 0 OR Y.AMT.MVMT EQ '' THEN
		RETURN
	END
	
    OPENSEQ Y.FLDR.BKP,Y.FILE TO F.OUT ELSE
		CREATE F.OUT ELSE
			PRINT "CANNOT OPEN RESPONS FOLDER"				
		END
    END
	
	IF Y.AMT.MVMT LT 0 THEN
		Y.BIT.102 = Y.GL
		Y.BIT.103 = ""
	END ELSE
		Y.BIT.102 = ""
		Y.BIT.103 = Y.GL
	END
	
	Y.BIT.49 = Y.CCY	
	Y.BIT.4  = ABS(EREPLACE(FMT(Y.AMT.MVMT, "R2"),".",""))
	Y.BIT.13 = Y.LAST.DATE
	
*<20170803_Dhio
*	Y.BIT.62 = Y.NARRATIVE
	Y.BIT.62 = Y.ID : Y.CONSOL.KEY
*>20170803_Dhio
	
	Y.OUT  = Y.BIT.102 
	Y.OUT := Y.SEP : Y.BIT.103
	Y.OUT := Y.SEP : Y.BIT.49
	Y.OUT := Y.SEP : Y.BIT.4
	Y.OUT := Y.SEP : Y.BIT.13
*<20170803_Dhio
	Y.OUT := Y.SEP : Y.ACCOUNT.TYPE
*>20170803_Dhio
	Y.OUT := Y.SEP : Y.BIT.62
	
	WRITESEQ Y.OUT APPEND TO F.OUT ELSE
        RETURN
    END
	
	CLOSESEQ F.OUT
		
	RETURN

*-----------------------------------------------------------------------------	
CLEAR.VAR:
*===============

	Y.BIT.102      = ''
	Y.BIT.103      = ''
	Y.BIT.49       = ''
	Y.BIT.4        = ''
	Y.BIT.13       = ''
	Y.ACCOUNT.TYPE = ''
	Y.BIT.62       = ''
	
	RETURN
END