*-----------------------------------------------------------------------------
    SUBROUTINE ATI.AGENT.ACTIVITY.LIST(Y.RESULT)
*-----------------------------------------------------------------------------
* Developer Name     : Fatkhur Rohman
* Development Date   : 20180719
* Description        : Rountine agent activity list
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date            Modified by                Description
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
	$INSERT I_F.ATI.TT.AGENT.MONTHLY.TXN.ACT
	$INSERT I_F.ATI.TH.AGENT.GLOBAL.PARAM
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
	FN.ATI.TT.AGENT.MONTHLY.TXN.ACT = 'F.ATI.TT.AGENT.MONTHLY.TXN.ACT'
	CALL OPF(FN.ATI.TT.AGENT.MONTHLY.TXN.ACT, F.ATI.TT.AGENT.MONTHLY.TXN.ACT)
	
    FN.ATI.TH.AGENT.GLOBAL.PARAM = 'F.ATI.TH.AGENT.GLOBAL.PARAM'
	CALL OPF(FN.ATI.TH.AGENT.GLOBAL.PARAM, F.ATI.TH.AGENT.GLOBAL.PARAM)
	
	FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER'
	CALL OPF(FN.FUNDS.TRANSFER, F.FUNDS.TRANSFER)
	
	FN.FUNDS.TRANSFER.HIS = 'F.FUNDS.TRANSFER$HIS'
	CALL OPF(FN.FUNDS.TRANSFER.HIS, F.FUNDS.TRANSFER.HIS)
	
	CALL F.READ(FN.ATI.TH.AGENT.GLOBAL.PARAM, "SYSTEM", R.ATI.TH.AGENT.GLOBAL.PARAM, F.ATI.TH.AGENT.GLOBAL.PARAM, ATI.TH.AGENT.GLOBAL.PARAM.ERR)
	Y.TRANS.CODE.CR = R.ATI.TH.AGENT.GLOBAL.PARAM<AGENT.PARAM.TRANS.CODE.DB>
	Y.TRANS.CODE.DB = R.ATI.TH.AGENT.GLOBAL.PARAM<AGENT.PARAM.TRANS.CODE.CR>
	
	Y.HTML.OUT = ""

    RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
	Y.DATE.FULL  = FIELD(Y.RESULT, "*", 1)
	Y.AGENT.ACCT = FIELD(Y.RESULT, "*", 2)
	Y.AGEN.MONTHLY.TXN.ACT.ID = Y.DATE.FULL[1,6] : "*" : Y.AGENT.ACCT
	Y.DATE = Y.DATE.FULL[7,2]
	
	CALL F.READ(FN.ATI.TT.AGENT.MONTHLY.TXN.ACT, Y.AGEN.MONTHLY.TXN.ACT.ID, R.ATI.TT.AGENT.MONTHLY.TXN.ACT, F.ATI.TT.AGENT.MONTHLY.TXN.ACT, ERR.ATI.TT.AGENT.MONTHLY.TXN.ACT)
	Y.DATE.LIST = R.ATI.TT.AGENT.MONTHLY.TXN.ACT<TXN.ACT.DATE>
	
	FIND Y.DATE IN Y.DATE.LIST SETTING POSF.DT, POSV.DT THEN
		GOSUB PROCESS.DO.DB.TXN
		GOSUB PROCESS.DO.CR.TXN
	END ELSE
		GOSUB PROCESS.NA.TRANSACTION
	END
	
	Y.RESULT = Y.HTML.OUT

    RETURN

*-----------------------------------------------------------------------------
PROCESS.DO.DB.TXN:
*-----------------------------------------------------------------------------
	Y.DB.TXN.TYP.LIST = R.ATI.TT.AGENT.MONTHLY.TXN.ACT<TXN.ACT.TRANS.DB, POSV.DT>
	Y.DB.TXN.REF.LIST = R.ATI.TT.AGENT.MONTHLY.TXN.ACT<TXN.ACT.REF.ID.DB, POSV.DT>
	
	Y.HTML.OUT := "<div class='dv2'><table class='tg'>"
	Y.HTML.OUT := "<tr><th class='tg-th' colspan='4'>Aktifitas Transaksi Debit</th></tr>"
	Y.HTML.OUT := "<tr><td class='tg-td1' width='20px'>No.</td><td class='tg-td1' width='100px'>Kode Referensi</td><td class='tg-td1' width='60px'>Waktu</td><td class='tg-td1' width='420px'>Keterangan</td></tr>"
	
	Y.CNT.DB = DCOUNT(Y.DB.TXN.REF.LIST, SM)
	IF Y.CNT.DB THEN
		Y.NO.DB  = 0
		FOR Y.A=1 TO Y.CNT.DB
			Y.DB.TXN.TYPE = Y.DB.TXN.TYP.LIST<1,1,Y.A>
			
			FIND Y.DB.TXN.TYPE IN Y.TRANS.CODE.DB SETTING POSF.DB, POSV.DB ELSE
				CONTINUE
			END
			
			Y.NO.DB += 1
			Y.DB.TXN.REF.ID      = Y.DB.TXN.REF.LIST<1,1,Y.A>
			Y.SAVE.DB.TXN.REF.ID = Y.DB.TXN.REF.ID
			CALL F.READ(FN.FUNDS.TRANSFER, Y.DB.TXN.REF.ID, R.FUNDS.TRANSFER, F.FUNDS.TRANSFER, ERR.FUNDS.TRANSFER)
			
			IF (R.FUNDS.TRANSFER) THEN
				Y.FT.TXN.TIME = R.FUNDS.TRANSFER<FT.DATE.TIME>[4]
				Y.DB.TXN.TIME = Y.FT.TXN.TIME[1,2] : ':' : Y.FT.TXN.TIME[3,2]
				
				Y.ACTIVITY.ID = 'BSA.CASHDEPOSIT.FT'
				Y.APP         = 'FUNDS.TRANSFER'
				Y.APP.ID      = Y.DB.TXN.REF.ID
				R.APP         = R.FUNDS.TRANSFER
			END ELSE
				CALL F.READ.HISTORY(FN.FUNDS.TRANSFER.HIS, Y.DB.TXN.REF.ID, R.FUNDS.TRANSFER.HIS, F.FUNDS.TRANSFER.HIS, FUNDS.TRANSFER.HIS.ERR)
				
				Y.FT.TXN.TIME = R.FUNDS.TRANSFER.HIS<FT.DATE.TIME>[4]
				Y.DB.TXN.TIME = Y.FT.TXN.TIME[1,2] : ':' : Y.FT.TXN.TIME[3,2]
				
				Y.ACTIVITY.ID = 'BSA.CASHDEPOSIT.FT'
				Y.APP         = 'FUNDS.TRANSFER'
				Y.APP.ID      = Y.DB.TXN.REF.ID
				R.APP         = R.FUNDS.TRANSFER.HIS
			END
			
			CALL ATI.GET.AGENT.ACTIVITY.DESC(Y.ACTIVITY.ID, Y.APP, Y.APP.ID, R.APP, Y.ACTIVITY.DESC, Y.ERROR)
			
			Y.HTML.OUT := "<tr>"
			Y.HTML.OUT := "<td class='tg-td21'>" :Y.NO.DB: "</td>"
			Y.HTML.OUT := "<td class='tg-td21'>" :Y.SAVE.DB.TXN.REF.ID: "</td>"
			Y.HTML.OUT := "<td class='tg-td21'>" :Y.DB.TXN.TIME: "</td>"
			Y.HTML.OUT := "<td class='tg-td22'>" :Y.ACTIVITY.DESC: "</td>"
			Y.HTML.OUT := "</tr>"
		NEXT Y.CNT.DB
	END ELSE
		Y.HTML.OUT := "<tr><td class='tg-td22' colspan='4' style='color:#990000'><i>Tidak ada aktifitas transaksi.</i></td></tr>"
	END
	
	Y.HTML.OUT := "</table></div>"
	
	RETURN

*-----------------------------------------------------------------------------
PROCESS.DO.CR.TXN:
*-----------------------------------------------------------------------------
	Y.CR.TXN.TYP.LIST = R.ATI.TT.AGENT.MONTHLY.TXN.ACT<TXN.ACT.TRANS.CR, POSV.DT>
	Y.CR.TXN.REF.LIST = R.ATI.TT.AGENT.MONTHLY.TXN.ACT<TXN.ACT.REF.ID.CR, POSV.DT>
	
	Y.HTML.OUT := "<div class='dv2'><table class='tg'>"
	Y.HTML.OUT := "<tr><th class='tg-th' colspan='4'>Aktifitas Transaksi Kredit</th></tr>"
	Y.HTML.OUT := "<tr><td class='tg-td1' width='20px'>No.</td><td class='tg-td1' width='100px'>Kode Referensi</td><td class='tg-td1' width='60px'>Waktu</td><td class='tg-td1' width='420px'>Keterangan</td></tr>"
	
	Y.CNT.CR = DCOUNT(Y.CR.TXN.REF.LIST, SM)
	IF Y.CNT.CR THEN
		Y.NO.CR  = 0
		FOR Y.B=1 TO Y.CNT.CR
			Y.CR.TXN.TYPE = Y.CR.TXN.TYP.LIST<1,1,Y.B>
			
			IF Y.CR.TXN.TYPE EQ "ACFA" THEN
				Y.ACTIVITY.ID = 'BSA.FEE.AGENT.FT'		
			END ELSE
				FIND Y.CR.TXN.TYPE IN Y.TRANS.CODE.CR SETTING POSF.CR, POSV.CR ELSE
					CONTINUE
				END
		
				Y.ACTIVITY.ID = 'BSA.CASHWITHDRAW.FT'
			END
			
			Y.NO.CR += 1
			Y.CR.TXN.REF.ID      = Y.CR.TXN.REF.LIST<1,1,Y.B>
			Y.SAVE.CR.TXN.REF.ID = Y.CR.TXN.REF.ID 
			CALL F.READ(FN.FUNDS.TRANSFER, Y.CR.TXN.REF.ID, R.FUNDS.TRANSFER, F.FUNDS.TRANSFER, ERR.FUNDS.TRANSFER)
			
			IF (R.FUNDS.TRANSFER) THEN
				Y.FT.TXN.TIME = R.FUNDS.TRANSFER<FT.DATE.TIME>[4]
				Y.CR.TXN.TIME = Y.FT.TXN.TIME[1,2] : ':' : Y.FT.TXN.TIME[3,2]
				
				Y.APP         = 'FUNDS.TRANSFER'
				Y.APP.ID      = Y.CR.TXN.REF.ID
				R.APP         = R.FUNDS.TRANSFER
			END ELSE
				CALL F.READ.HISTORY(FN.FUNDS.TRANSFER.HIS, Y.CR.TXN.REF.ID, R.FUNDS.TRANSFER.HIS, F.FUNDS.TRANSFER.HIS, FUNDS.TRANSFER.HIS.ERR)
				
				Y.FT.TXN.TIME = R.FUNDS.TRANSFER.HIS<FT.DATE.TIME>[4]
				Y.CR.TXN.TIME = Y.FT.TXN.TIME[1,2] : ':' : Y.FT.TXN.TIME[3,2]
				
				Y.APP         = 'FUNDS.TRANSFER'
				Y.APP.ID      = Y.CR.TXN.REF.ID
				R.APP         = R.FUNDS.TRANSFER.HIS
			END
			
			CALL ATI.GET.AGENT.ACTIVITY.DESC(Y.ACTIVITY.ID, Y.APP, Y.APP.ID, R.APP, Y.ACTIVITY.DESC, Y.ERROR)
			
			Y.HTML.OUT := "<tr>"
			Y.HTML.OUT := "<td class='tg-td21'>" :Y.NO.CR: "</td>"
			Y.HTML.OUT := "<td class='tg-td21'>" :Y.SAVE.CR.TXN.REF.ID: "</td>"
			Y.HTML.OUT := "<td class='tg-td21'>" :Y.CR.TXN.TIME: "</td>"
			Y.HTML.OUT := "<td class='tg-td22'>" :Y.ACTIVITY.DESC: "</td>"
			Y.HTML.OUT := "</tr>"
		NEXT Y.CNT.CR
	END ELSE
		Y.HTML.OUT := "<tr><td class='tg-td22' colspan='4' style='color:#990000'><i>Tidak ada aktifitas transaksi.</i></td></tr>"
	END
	
	Y.HTML.OUT := "</table></div>"
	
	RETURN
	
*-----------------------------------------------------------------------------
PROCESS.NA.TRANSACTION:
*-----------------------------------------------------------------------------
	Y.HTML.OUT := "<div class='dv2'><table class='tg'>"
	Y.HTML.OUT := "<tr><th class='tg-th' colspan='4'>Aktifitas Transaksi Debit</th></tr>"
	Y.HTML.OUT := "<tr><td class='tg-td1' width='20px'>No.</td><td class='tg-td1' width='100px'>Kode Referensi</td><td class='tg-td1' width='60px'>Waktu</td><td class='tg-td1' width='420px'>Keterangan</td></tr>"
	Y.HTML.OUT := "<tr><td class='tg-td22' colspan='4' style='color:#990000'><i>Tidak ada aktifitas transaksi.</i></td></tr>"
	Y.HTML.OUT := "</table></div>"
	
	Y.HTML.OUT := "<div class='dv2'><table class='tg'>"
	Y.HTML.OUT := "<tr><th class='tg-th' colspan='4'>Aktifitas Transaksi Kredit</th></tr>"
	Y.HTML.OUT := "<tr><td class='tg-td1' width='20px'>No.</td><td class='tg-td1' width='100px'>Kode Referensi</td><td class='tg-td1' width='60px'>Waktu</td><td class='tg-td1' width='420px'>Keterangan</td></tr>"
	Y.HTML.OUT := "<tr><td class='tg-td22' colspan='4' style='color:#990000'><i>Tidak ada aktifitas transaksi.</i></td></tr>"
	Y.HTML.OUT := "</table></div>"
	
	RETURN
	
*-----------------------------------------------------------------------------	
END
