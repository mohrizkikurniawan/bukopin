*-----------------------------------------------------------------------------
* <Rating>-30</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.BM.IMB.ACCRUAL.LOAD
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
    $INSERT I_F.DATES

*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------

    GOSUB INIT
    GOSUB PROCESS

    RETURN

*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------

    FN.ATI.TL.IMB.ACCRUAL = "F.ATI.TL.IMB.ACCRUAL"
    F.ATI.TL.IMB.ACCRUAL  = ""
    CALL OPF(FN.ATI.TL.IMB.ACCRUAL, F.ATI.TL.IMB.ACCRUAL)

    FN.CUSTOMER = "F.CUSTOMER"
    F.CUSTOMER  = ""
    CALL OPF(FN.CUSTOMER, F.CUSTOMER)

    FN.ACCOUNT = "F.ACCOUNT"
    F.ACCOUNT  = ""
    CALL OPF(FN.ACCOUNT, F.ACCOUNT)
	
    FN.ATI.TH.ACCT.INACTIVE = "F.ATI.TH.ACCT.INACTIVE"
    F.ATI.TH.ACCT.INACTIVE  = ""
    CALL OPF(FN.ATI.TH.ACCT.INACTIVE, F.ATI.TH.ACCT.INACTIVE)
    
*    FN.LD = "F.LD.LOANS.AND.DEPOSITS" ; F.LD = ""
*    CALL OPF(FN.LD, F.LD)
    
*    FN.FIN.PROD.TYPE = "F.IDIH.FIN.PROD.TYPE" ; F.FIN.PROD.TYPE = ""
*    CALL OPF(FN.FIN.PROD.TYPE, F.FIN.PROD.TYPE)
    
    FN.COMP = "F.COMPANY" ; F.COMP = ""
    CALL OPF(FN.COMP, F.COMP)
    
*    Y.APPLICATION.NAME = "LD.LOANS.AND.DEPOSITS"
*    Y.FIELD.NAME       = "SCHEME" :VM: "PROD.TYPE" :VM: "ORIG.AMOUNT" :VM: "MRG.AMT" :VM: "UJROH.AMT" :VM: "ATI.TERMIN.PERC"
*    LREF.POS           = ""
*    CALL MULTI.GET.LOC.REF (Y.APPLICATION.NAME, Y.FIELD.NAME, LREF.POS)
*    
*    Y.SCHEME.POS  	= LREF.POS<1, 1>
*    Y.PROD.TYPE.POS = LREF.POS<1, 2>
*    Y.ORIG.AMT.POS  = LREF.POS<1, 3>
*    Y.MRG.AMT.POS 	= LREF.POS<1, 4>
*    Y.UJROH.AMT.POS	= LREF.POS<1, 5>
*    Y.TERM.PERC.POS = LREF.POS<1, 6>

    RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------

    Y.LAST.WORK.DAY = R.DATES(EB.DAT.LAST.WORKING.DAY)
    Y.DAYS          = "+1C"
    Y.DATE.LIST     = ""
    Y.DATE.CNT      = 0

    LOOP
        CALL CDT("",Y.LAST.WORK.DAY,Y.DAYS)
    WHILE Y.LAST.WORK.DAY LE TODAY
        Y.DATE.LIST<1, -1> = Y.LAST.WORK.DAY
        Y.DATE.CNT += 1
    REPEAT

    RETURN
*-----------------------------------------------------------------------------
END

