*-----------------------------------------------------------------------------
* <Rating>-151</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.BM.IMB.ACCRUAL(Y.ID)
*-----------------------------------------------------------------------------
* Developer Name      : Novi Leo
* Development Date    : 20170518
* Description         : Routine to calculate accrual and generate journal when amortization
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date               : ATI Julian Gerry
* Modified by        : 21 July 2017
* Description        : Update proses for termin ist grp prod
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ATI.BM.IMB.ACCRUAL.COMMON
    $INSERT I_F.ATI.TL.IMB.ACCRUAL
*    $INSERT I_F.IDIH.FIN.PROD.TYPE
*    $INSERT I_F.LD.LOANS.AND.DEPOSITS
    $INSERT I_F.CUSTOMER
    $INSERT I_F.COMPANY
    $INSERT I_F.ACCOUNT
    $INSERT I_F.STMT.ENTRY

*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------

    GOSUB INIT
    GOSUB PROCESS

    RETURN

*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------

    Y.ENTRIES = '' ; Y.ENTRY.NO = ''
    
    RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------

    CALL F.READU(FN.ATI.TL.IMB.ACCRUAL,Y.ID,R.ATI.TL.IMB.ACCRUAL,F.ATI.TL.IMB.ACCRUAL,ATI.TL.IMB.ACCRUAL.ERR, "")
    Y.MATURE.DATE  = R.ATI.TL.IMB.ACCRUAL<ACR.MATURE.DATE>
    Y.NEXT.POST.DT = R.ATI.TL.IMB.ACCRUAL<ACR.NEXT.POST.DT>
    Y.SCHD.AMT     = R.ATI.TL.IMB.ACCRUAL<ACR.SCHD.AMT>
    Y.SCHD.POST    = R.ATI.TL.IMB.ACCRUAL<ACR.SCHD.POST>
    Y.CUSTOMER.ID  = R.ATI.TL.IMB.ACCRUAL<ACR.CUSTOMER>
    Y.ACR.CURR     = R.ATI.TL.IMB.ACCRUAL<ACR.CURRENCY>
    Y.DB.ACCT      = R.ATI.TL.IMB.ACCRUAL<ACR.DB.ACCT>
    Y.CR.ACCT      = R.ATI.TL.IMB.ACCRUAL<ACR.CR.ACCT>
    Y.DB.TXN.CODE  = R.ATI.TL.IMB.ACCRUAL<ACR.DB.TXN.CODE>
    Y.CR.TXN.CODE  = R.ATI.TL.IMB.ACCRUAL<ACR.CR.TXN.CODE>
    Y.FREQ.POST    = R.ATI.TL.IMB.ACCRUAL<ACR.FREQ.POST>
    Y.CO.CODE      = R.ATI.TL.IMB.ACCRUAL<ACR.CO.CODE>
    Y.TERMIN.DATE  = R.ATI.TL.IMB.ACCRUAL<ACR.TERMIN.DATE>
    Y.TERMIN.AMT   = R.ATI.TL.IMB.ACCRUAL<ACR.TERMIN.AMT>
    
    CALL F.READ(FN.COMP, Y.CO.CODE, R.COMP, F.COMP, COMP.ERR)
    CALL F.READ(FN.CUSTOMER,Y.CUSTOMER.ID,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ERR)
    Y.DEPT.CODE = R.CUSTOMER<EB.CUS.DEPT.CODE>

*<dwk-20171113    
*    IF Y.TERMIN.DATE THEN
*       GOSUB PROC.TERMIN.IST
*    END ELSE
*        GOSUB PROC.ELSE
*    END
     GOSUB PROC.DORMANT
*>
    CALL F.WRITE(FN.ATI.TL.IMB.ACCRUAL, Y.ID, R.ATI.TL.IMB.ACCRUAL)
    
    IF Y.ENTRIES THEN
        Y.SYSTEM.ID = "AC"
        Y.TYPE      = "SAO"
        V           = 500
        IF C$MULTI.BOOK AND Y.CO.CODE NE ID.COMPANY THEN
            CALL LOAD.COMPANY(Y.CO.CODE)
        END
        CALL EB.ACCOUNTING(Y.SYSTEM.ID, Y.TYPE, Y.ENTRIES, '')
    END
    
    RETURN
    
*-----------------------------------------------------------------------------
PROC.TERMIN.IST:
*-----------------------------------------------------------------------------
    
    LOCATE Y.NEXT.POST.DT IN Y.DATE.LIST<1,1> SETTING Y.POS ELSE
        RETURN
    END
    
    Y.LD.ID = FIELD(Y.ID, "-", 1)
    CALL F.READ (FN.LD, Y.LD.ID, R.LD, F.LD, LD.ERR)
    IF R.LD<LD.LOCAL.REF, Y.SCHEME.POS> NE "IST" THEN
        RETURN
    END
    
    CALL F.READ(FN.FIN.PROD.TYPE, "SYSTEM", R.FIN, F.FIN.PROD.TYPE, FIN.PROD.TYPE.ERR)
    Y.DISB.CATEG = Y.ACR.CURR : R.FIN<FIN.DISB.CATEG> : "0001" : R.COMP<EB.COM.SUB.DIVISION.CODE>
    
    CALL F.READ(FN.FIN.PROD.TYPE, R.LD<LD.LOCAL.REF, Y.PROD.TYPE.POS>, R.FIN, F.FIN.PROD.TYPE, FIN.PROD.TYPE.ERR)
    Y.PR.IJR.IA 		= Y.ACR.CURR : R.FIN<FIN.PR.IJR.IA> : "0001" : R.COMP<EB.COM.SUB.DIVISION.CODE>
    Y.ACCRUE.PR.IJR 	= Y.ACR.CURR : R.FIN<FIN.ACCRUE.PR.IJR> : "0001" : R.COMP<EB.COM.SUB.DIVISION.CODE>
    Y.ACCRUE.PL.PR		= R.FIN<FIN.ACCRUE.PL.PR>
    Y.INVTRY.CATEG		= Y.ACR.CURR : R.FIN<FIN.INVTRY.CATEG> : "0001" : R.COMP<EB.COM.SUB.DIVISION.CODE>
    Y.STOP.IJARAH		= Y.ACR.CURR : R.FIN<FIN.STOP.IJARAH> : "0001" : R.COMP<EB.COM.SUB.DIVISION.CODE>
    Y.DEF.MRG.CATEG		= Y.ACR.CURR : R.FIN<FIN.DEF.MRG.CATEG> : "0001" : R.COMP<EB.COM.SUB.DIVISION.CODE>
    Y.MRG.PFS.UJR.CTG   = Y.ACR.CURR : R.FIN<FIN.MRG.PFS.UJR.CTG> : "0001" : R.COMP<EB.COM.SUB.DIVISION.CODE>
    
    LOCATE Y.NEXT.POST.DT IN Y.TERMIN.DATE<1, 1> SETTING Y.TERM.POS THEN
        Y.TERM.POS += 1
    END
    Y.PERC 				= R.LD<LD.LOCAL.REF, Y.TERM.PERC.POS, Y.TERM.POS>
    Y.MARGIN.CASH = R.LD<LD.LOCAL.REF, Y.UJROH.AMT.POS>
    Y.TERMIN.CASH = Y.PERC / 100 * (R.LD<LD.LOCAL.REF, Y.ORIG.AMT.POS> + R.LD<LD.LOCAL.REF, Y.UJROH.AMT.POS>)
    Y.MARGIN			= Y.PERC / 100 * R.LD<LD.LOCAL.REF, Y.MRG.AMT.POS>
    CALL EB.ROUND.AMOUNT(Y.ACR.CURR, Y.TERMIN.CASH, '', '')
    CALL EB.ROUND.AMOUNT(Y.ACR.CURR, Y.MARGIN, '', '')
    
    GOSUB JOURNAL.TERMIN
    IF Y.NEXT.POST.DT NE Y.MATURE.DATE THEN
        R.ATI.TL.IMB.ACCRUAL<ACR.NEXT.POST.DT> = Y.TERMIN.DATE<1, (Y.TERM.POS)>
        R.ATI.TL.IMB.ACCRUAL<ACR.SCHD.AMT> 		 = Y.TERMIN.AMT<1, (Y.TERM.POS)>
    END ELSE
*-----Journal End of Termin-----
        GOSUB JOURNAL.TERMIN.END
    END
    
    RETURN

*-----------------------------------------------------------------------------
JOURNAL.TERMIN:
*-----------------------------------------------------------------------------
    
    Y.AMT		  = Y.SCHD.AMT
    Y.DB.ACCT = R.LD<LD.DRAWDOWN.ACCOUNT>
    Y.CR.ACCT = Y.PR.IJR.IA
    GOSUB GEN.JOURNAL
    
    Y.AMT		  = Y.SCHD.AMT
    Y.DB.ACCT = Y.ACCRUE.PR.IJR
    Y.CR.ACCT = Y.ACCRUE.PL.PR
    GOSUB GEN.JOURNAL
    
    Y.AMT		  = Y.TERMIN.CASH
    Y.DB.ACCT = Y.INVTRY.CATEG
    Y.CR.ACCT = Y.STOP.IJARAH
    GOSUB GEN.JOURNAL
    
    Y.AMT		  = Y.SCHD.AMT
    Y.DB.ACCT = Y.STOP.IJARAH
    Y.CR.ACCT = Y.DISB.CATEG
    GOSUB GEN.JOURNAL
    
    Y.AMT		  = Y.TERMIN.CASH - Y.SCHD.AMT
    Y.DB.ACCT = Y.STOP.IJARAH
    Y.CR.ACCT = Y.DEF.MRG.CATEG
    GOSUB GEN.JOURNAL
    
    Y.AMT		  = Y.MARGIN
    Y.DB.ACCT = Y.MRG.PFS.UJR.CTG
    Y.CR.ACCT = Y.PR.IJR.IA
    GOSUB GEN.JOURNAL
    
    RETURN

*-----------------------------------------------------------------------------
JOURNAL.TERMIN.END:
*-----------------------------------------------------------------------------
    
    Y.AMT		  = R.LD<LD.LOCAL.REF, Y.ORIG.AMT.POS> - Y.MARGIN.CASH
    Y.DB.ACCT = Y.PR.IJR.IA
    Y.CR.ACCT = Y.INVTRY.CATEG
    GOSUB GEN.JOURNAL
    
    Y.AMT		  = R.LD<LD.LOCAL.REF, Y.MRG.AMT.POS> + Y.MARGIN.CASH
    Y.DB.ACCT = Y.PR.IJR.IA
    Y.CR.ACCT = Y.DEF.MRG.CATEG
    GOSUB GEN.JOURNAL
    
    RETURN
    
*-----------------------------------------------------------------------------
PROC.ELSE:
*-----------------------------------------------------------------------------
    
    LOCATE Y.MATURE.DATE IN Y.DATE.LIST<1,1> SETTING Y.POS THEN
        Y.AMT = R.ATI.TL.IMB.ACCRUAL<ACR.DEPR.OS>

        R.ATI.TL.IMB.ACCRUAL<ACR.ACCR.TO.DATE> = "0"
        R.ATI.TL.IMB.ACCRUAL<ACR.DEPR.OS>      = ""

        GOSUB GEN.JOURNAL
    END ELSE
        LOCATE Y.NEXT.POST.DT IN Y.DATE.LIST<1,1> SETTING Y.POS2 THEN
            Y.AMT  = Y.POS2 * Y.SCHD.AMT
            Y.AMT += R.ATI.TL.IMB.ACCRUAL<ACR.ACCR.TO.DATE>

            R.ATI.TL.IMB.ACCRUAL<ACR.DEPR.OS>      -= Y.AMT
            R.ATI.TL.IMB.ACCRUAL<ACR.ACCR.TO.DATE>  = (Y.DATE.CNT - Y.POS2) * Y.SCHD.AMT

            GOSUB GEN.NEXT.POST
			GOSUB GEN.JOURNAL
			
        END ELSE
            Y.AMT = Y.DATE.CNT * Y.SCHD.AMT

            R.ATI.TL.IMB.ACCRUAL<ACR.ACCR.TO.DATE> += Y.AMT
        END
    END

    RETURN

*-----------------------------------------------------------------------------
PROC.DORMANT:
*-----------------------------------------------------------------------------
    
    LOCATE Y.NEXT.POST.DT IN Y.DATE.LIST<1,1> SETTING Y.POS2 THEN
	    GOSUB GEN.NEXT.POST
		R.ATI.TL.IMB.ACCRUAL<ACR.MATURE.DATE> = Y.NEXT.DATE
		
	    CALL F.READ(FN.ACCOUNT, Y.DB.ACCT, R.ACCT.CHK.DB, F.ACCOUNT, ACCT.ERR)
		Y.WORKING.BAL = R.ACCT.CHK.DB<AC.WORKING.BALANCE>	
		
        CALL F.READ(FN.ATI.TH.ACCT.INACTIVE, Y.DB.ACCT, R.ATI.TH.ACCT.INACTIVE, F.ATI.TH.ACCT.INACTIVE, ATI.TH.ACCT.INACTIVE.ERR)
		Y.CNT.RETRY = DCOUNT(R.ATI.TH.ACCT.INACTIVE<ACCT.INACTIV.DATE>, VM)
		
*		Y.FLAG.RETRY = ""
*		FOR YLOOP.RETRY = 1 TO Y.CNT.RETRY
*		    Y.AMOUNT.RETRY += R.ATI.TH.ACCT.INACTIVE<ACCT.INACTIV.AMOUNT, YLOOP.RETRY>
*			IF Y.AMOUNT.RETRY GT Y.WORKING.BAL THEN
*			   Y.AMOUNT.RETRY -= R.ATI.TH.ACCT.INACTIVE<ACCT.INACTIV.AMOUNT, YLOOP.RETRY>
*			   Y.FLAG.RETRY    = 1
*			   BREAK
*			END
*	
*			DEL R.ATI.TH.ACCT.INACTIVE<ACCT.INACTIV.AMOUNT, YLOOP.RETRY>
*			Y.CNT.RETRY -= 1
*			YLOOP.RETRY -= 1	
*		NEXT YLOOP.RETRY

*		Y.WORKBAL.MIN.RETRY = Y.WORKING.BAL - Y.AMOUNT.RETRY
		
		BEGIN CASE
		CASE Y.CNT.RETRY EQ 0 AND Y.SCHD.AMT LE Y.WORKING.BAL ;*normal
		    Y.AMT = Y.SCHD.AMT
		    GOSUB GEN.JOURNAL			
*		CASE Y.SCHD.AMT LT Y.WORKBAL.MIN.RETRY AND Y.FLAG.RETRY EQ "" ;*cukup utk tunggakan dan bulan ini
*		    Y.AMT = Y.AMOUNT.RETRY + Y.SCHD.AMT
*		    GOSUB GEN.JOURNAL
*		CASE Y.FLAG.RETRY EQ "1" OR Y.SCHD.AMT GT Y.WORKBAL.MIN.RETRY ;*tdk cukup untuk bayar tunggakan/hanya untuk bayar tunggakan
*		    Y.AMT = Y.AMOUNT.RETRY
*		    GOSUB GEN.JOURNAL
*            GOSUB UPD.INACTIV.AMT
*		CASE Y.SCHD.AMT GT Y.WORKING.BAL ;*baru pernah ada tunggakan
*		    GOSUB UPD.INACTIV.AMT
	    END CASE
    END

    RETURN

*-----------------------------------------------------------------------------
GEN.JOURNAL:
*-----------------------------------------------------------------------------

    IF Y.SCHD.POST EQ "Y" THEN

        Y.AMOUNT         = Y.AMT
        Y.DEBIT.ACCOUNT  = Y.DB.ACCT
        Y.CREDIT.ACCOUNT = Y.CR.ACCT

        Y.AMT.LCY = Y.AMOUNT

        IF Y.ACR.CURR NE LCCY THEN
            Y.CURRENCY = Y.ACR.CURR
            GOSUB GET.AMOUNT.FCY.TO.LCY
        END

        GOSUB GEN.ENTRIES.DB
        GOSUB GEN.ENTRIES.CR
    END

    RETURN

*-----------------------------------------------------------------------------
GET.AMOUNT.FCY.TO.LCY:
*-----------------------------------------------------------------------------

    Y.AMT.FCY = Y.AMOUNT
    Y.AMT.LCY = ""
    Y.EXCH.RATE = ""

    CALL EXCHRATE(1,Y.CURRENCY,Y.AMT.FCY,LCCY,Y.AMT.LCY,"",Y.EXCH.RATE,"","","")

    CALL EB.ROUND.AMOUNT(Y.CURRENCY,Y.AMT.LCY,"","")
    CALL EB.ROUND.AMOUNT(Y.CURRENCY,Y.EXCH.RATE,"","")

    RETURN

*-----------------------------------------------------------------------------
GET.AMOUNT.LCY.TO.FCY:
*-----------------------------------------------------------------------------

    Y.AMT.LCY = Y.AMOUNT
    Y.AMT.FCY = ""
    Y.EXCH.RATE = ""

    CALL EXCHRATE(1,LCCY,Y.AMT.LCY,Y.CURRENCY,Y.AMT.FCY,"",Y.EXCH.RATE,"","","")

    CALL EB.ROUND.AMOUNT(Y.CURRENCY,Y.AMT.FCY,"","")
    CALL EB.ROUND.AMOUNT(Y.CURRENCY,Y.EXCH.RATE,"","")

    RETURN

*-----------------------------------------------------------------------------
GEN.ENTRIES.DB:
*-----------------------------------------------------------------------------

    Y.ENTRY.NO += 1
    Y.NUM       = Y.ENTRY.NO

    Y.ACCT.CHECK    = Y.DEBIT.ACCOUNT
    Y.ACCT.PL.CHECK = Y.CREDIT.ACCOUNT
    GOSUB CHECK.ACCOUNT

    IF Y.AC.CCY THEN
        Y.CURRENCY = Y.AC.CCY
    END

    IF Y.CURRENCY = LCCY THEN
        Y.ENTRIES<Y.NUM, AC.STE.AMOUNT.LCY> = NEG(Y.AMT.LCY)
    END ELSE
        Y.SAVE.AMT.FCY	 = Y.AMT.FCY
        Y.SAVE.EXCH.RATE = Y.EXCH.RATE
        IF Y.ACR.CURR NE Y.CURRENCY AND Y.AC.CCY THEN
            Y.AMOUNT = Y.AMT.LCY
            GOSUB GET.AMOUNT.LCY.TO.FCY
        END

        Y.ENTRIES<Y.NUM, AC.STE.AMOUNT.FCY>    = NEG(Y.AMT.FCY)
        Y.ENTRIES<Y.NUM, AC.STE.EXCHANGE.RATE> = Y.EXCH.RATE
        Y.ENTRIES<Y.NUM, AC.STE.AMOUNT.LCY>    = NEG(Y.AMT.LCY)
        Y.AMT.FCY 	= Y.SAVE.AMT.FCY
        Y.EXCH.RATE = Y.SAVE.EXCH.RATE
    END

    Y.ENTRIES<Y.NUM, AC.STE.TRANSACTION.CODE> = Y.DB.TXN.CODE

    GOSUB GEN.COMMON.ENTRIES

    RETURN

*-----------------------------------------------------------------------------
GEN.ENTRIES.CR:
*-----------------------------------------------------------------------------

    Y.ENTRY.NO += 1
    Y.NUM       = Y.ENTRY.NO

    Y.ACCT.CHECK    = Y.CREDIT.ACCOUNT
    Y.ACCT.PL.CHECK = Y.DEBIT.ACCOUNT
    GOSUB CHECK.ACCOUNT

    IF Y.AC.CCY THEN
        Y.CURRENCY = Y.AC.CCY
    END

    IF Y.CURRENCY = LCCY THEN
        Y.ENTRIES<Y.NUM, AC.STE.AMOUNT.LCY> = Y.AMT.LCY

    END ELSE
        Y.SAVE.AMT.FCY	 = Y.AMT.FCY
        Y.SAVE.EXCH.RATE = Y.EXCH.RATE
        IF Y.ACR.CURR NE Y.CURRENCY AND Y.AC.CCY THEN
            Y.AMOUNT = Y.AMT.LCY
            GOSUB GET.AMOUNT.LCY.TO.FCY
        END

        Y.ENTRIES<Y.NUM, AC.STE.AMOUNT.FCY>    = Y.AMT.FCY
        Y.ENTRIES<Y.NUM, AC.STE.EXCHANGE.RATE> = Y.EXCH.RATE
        Y.ENTRIES<Y.NUM, AC.STE.AMOUNT.LCY>    = Y.AMT.LCY
        Y.AMT.FCY 	= Y.SAVE.AMT.FCY
        Y.EXCH.RATE = Y.SAVE.EXCH.RATE
    END

    Y.ENTRIES<Y.NUM, AC.STE.TRANSACTION.CODE> = Y.CR.TXN.CODE

    GOSUB GEN.COMMON.ENTRIES

    RETURN

*-----------------------------------------------------------------------------
GEN.COMMON.ENTRIES:
*-----------------------------------------------------------------------------

    Y.ENTRIES<Y.NUM, AC.STE.TRANS.REFERENCE> = Y.ID
    Y.ENTRIES<Y.NUM, AC.STE.OUR.REFERENCE>   = Y.ID
    Y.ENTRIES<Y.NUM, AC.STE.ACCOUNT.OFFICER> = Y.DEPT.CODE
    Y.ENTRIES<Y.NUM, AC.STE.CUSTOMER.ID>     = Y.CUSTOMER.ID
    Y.ENTRIES<Y.NUM, AC.STE.POSITION.TYPE>   = "TR"
    Y.ENTRIES<Y.NUM, AC.STE.DEPARTMENT.CODE> = Y.DEPT.CODE
    Y.ENTRIES<Y.NUM, AC.STE.CURRENCY>        = Y.ACR.CURR
    Y.ENTRIES<Y.NUM, AC.STE.COMPANY.CODE>    = Y.CO.CODE
    Y.ENTRIES<Y.NUM, AC.STE.VALUE.DATE>      = TODAY
    Y.ENTRIES<Y.NUM, AC.STE.BOOKING.DATE>    = TODAY
    Y.ENTRIES<Y.NUM, AC.STE.CURRENCY.MARKET> = 1
    Y.ENTRIES<Y.NUM, AC.STE.SYSTEM.ID>       = "AC"

    RETURN

*-----------------------------------------------------------------------------
CHECK.ACCOUNT:
*-----------------------------------------------------------------------------

    Y.CURRENCY = Y.AC.CURR
    R.ACCOUNT  = ""
    CALL F.READ(FN.ACCOUNT,Y.ACCT.CHECK,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ERR)
    Y.AC.CCY = R.ACCOUNT<AC.CURRENCY>

    IF LEN(Y.ACCT.CHECK) EQ "5" AND NOT(R.ACCOUNT) THEN
        IF Y.ACCT.CHECK GE "50000" THEN
            Y.ENTRIES<Y.NUM, AC.STE.PL.CATEGORY>      = Y.ACCT.CHECK
            Y.ENTRIES<Y.NUM, AC.STE.PRODUCT.CATEGORY> = Y.LD.CATEGORY
            CALL F.READ(FN.ACCOUNT,Y.ACCT.PL.CHECK,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ERR)
            Y.AC.CCY = R.ACCOUNT<AC.CURRENCY>
        END ELSE
            Y.ENTRIES<Y.NUM, AC.STE.ACCOUNT.NUMBER>   = Y.ACR.CURR : Y.ACCT.CHECK : "0001" :R.COMPANY(EB.COM.SUB.DIVISION.CODE)
            Y.ENTRIES<Y.NUM, AC.STE.PRODUCT.CATEGORY> = Y.ACCT.CHECK
        END

    END ELSE
        Y.ENTRIES<Y.NUM, AC.STE.ACCOUNT.NUMBER>   = Y.ACCT.CHECK
        Y.ENTRIES<Y.NUM, AC.STE.PRODUCT.CATEGORY> = R.ACCOUNT<AC.CATEGORY>
    END

    RETURN
*-----------------------------------------------------------------------------
GEN.NEXT.POST:
*-----------------------------------------------------------------------------

    BEGIN CASE

    CASE Y.FREQ.POST[1,1] EQ "D"
        Y.NEXT.DATE = TODAY
        Y.DAY       = "+1W"
        CALL CDT("",Y.NEXT.DATE,Y.DAY)

    CASE Y.FREQ.POST[1,1] EQ "M"
        SAVE.COMI = COMI

        COMI = TODAY:Y.FREQ.POST
        CALL CFQ

        Y.NEXT.DATE = COMI[1,8]
        COMI        = SAVE.COMI

    END CASE

    R.ATI.TL.IMB.ACCRUAL<ACR.NEXT.POST.DT> = Y.NEXT.DATE

    RETURN
*-----------------------------------------------------------------------------
UPD.INACTIV.AMT:
*-----------------------------------------------------------------------------
    
	R.ATI.TH.ACCT.INACTIVE<ACCT.INACTIV.DATE,-1>   = TODAY
	R.ATI.TH.ACCT.INACTIVE<ACCT.INACTIV.AMOUNT,-1> = Y.SCHD.AMT
	CALL F.WRITE(FN.ATI.TH.ACCT.INACTIVE, Y.DB.ACCT, R.ATI.TH.ACCT.INACTIVE)

    RETURN
*-----------------------------------------------------------------------------
END

