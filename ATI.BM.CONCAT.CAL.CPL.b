	SUBROUTINE ATI.BM.CONCAT.CAL.CPL
	
	$INSERT I_COMMON
	$INSERT I_EQUATE
	$INSERT I_F.DATES
	$INSERT I_F.ATI.TH.EXT.CAL.CPL.PARAM

	GOSUB INIT	
	GOSUB PROCESS
	
	RETURN
*-----------------------------------------------------------------------------
INIT:
*=====		
	FN.ATI.TH.EXT.CAL.CPL.PARAM = 'F.ATI.TH.EXT.CAL.CPL.PARAM'
	F.ATI.TH.EXT.CAL.CPL.PARAM  = ''
	CALL OPF(FN.ATI.TH.EXT.CAL.CPL.PARAM,F.ATI.TH.EXT.CAL.CPL.PARAM)
	
	Y.LAST.DATE = R.DATES(EB.DAT.LAST.WORKING.DAY)
	
	CALL F.READ(FN.ATI.TH.EXT.CAL.CPL.PARAM,'SYSTEM',R.ATI.TH.EXT.CAL.CPL.PARAM,F.ATI.TH.EXT.CAL.CPL.PARAM,ATI.TH.EXT.CAL.CPL.PARAM.ERR)
	
	Y.FILE   = R.ATI.TH.EXT.CAL.CPL.PARAM<CAL.CPL.PAR.TEXTFILE>	: "." : Y.LAST.DATE
	Y.FOLDER = R.ATI.TH.EXT.CAL.CPL.PARAM<CAL.CPL.PAR.FOLDER>
	
	Y.LAST.DATE = R.DATES(EB.DAT.LAST.WORKING.DAY)
	    
    FN.FLDR        = ".\" : FIELD(Y.FOLDER, "\", 1) : '\temp'
    FN.FLDR.OUTPUT = ".\" : Y.FOLDER
	FN.FLDR.BKP    = ".\" : FIELD(Y.FOLDER, "\", 1) : '\backup'
	
    F.FLDR = ''
    OPEN FN.FLDR TO F.FLDR ELSE
        TEXT = "CANNOT OPEN SOURCE FILE FOLDER"
    END
	
	F.FLDR.OUTPUT = ''
    OPEN FN.FLDR.OUTPUT TO F.FLDR.OUTPUT ELSE
        TEXT = "CANNOT OPEN SOURCE FILE FOLDER"
    END
	
	F.FLDR.BKP = ''
    OPEN FN.FLDR.BKP TO F.FLDR.BKP ELSE
        TEXT = "CANNOT OPEN SOURCE FILE FOLDER"
    END	
	
	RETURN
*-----------------------------------------------------------------------------
PROCESS:
*=======	
	
	SEL.CMD = "SELECT ": FN.FLDR
	CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,RET.CODE)
	
	Y.PRINT = ''
    FOR I=1 TO NO.OF.REC
        CALL F.READ(FN.FLDR,SEL.LIST<I>,R.REC,F.FLDR,FLDR.ERR)
        IF Y.PRINT EQ '' THEN
            Y.PRINT = R.REC
        END ELSE
            Y.PRINT = Y.PRINT:@FM:R.REC
        END		
    NEXT I
	
    CONVERT @FM TO CHAR(10):CHAR(13) IN Y.PRINT	

*Write extract		
    OPENSEQ FN.FLDR.OUTPUT,Y.FILE TO F.OUT ELSE
        CREATE F.OUT ELSE
            RETURN
        END
    END	

    WRITESEQ Y.PRINT TO F.OUT ELSE
        RETURN
    END
	
	CLOSESEQ F.OUT

*Write backup	
    OPENSEQ FN.FLDR.BKP,Y.FILE TO F.OUT.BKP ELSE
        CREATE F.OUT.BKP ELSE
            RETURN
        END
    END	

    WRITESEQ Y.PRINT TO F.OUT.BKP ELSE
        RETURN
    END
	
	CLOSESEQ F.OUT.BKP
	
*	CMD.COPY = "COPY FROM " :FN.FLDR:" TO ":FN.FLDR.OUTPUT: " " :Y.FILE
*	EXECUTE CMD.COPY
*	
*	CMD.COPY1 = "COPY FROM " :FN.FLDR:" TO ":FN.FLDR.BKP: " " :Y.FILE
*	EXECUTE CMD.COPY1

    FOR I=1 TO NO.OF.REC
        CALL F.READ(FN.FLDR,SEL.LIST<I>,R.REC,F.FLDR,FLDR.ERR)
		CALL F.DELETE(FN.FLDR, SEL.LIST<I>)
    NEXT I		
	
	RETURN
END