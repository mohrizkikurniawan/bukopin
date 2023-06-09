*-----------------------------------------------------------------------------
* <Rating>-181</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.VIN.CLOSURE.ACT.MAIN
*-----------------------------------------------------------------------------
* Developer Name     : Dwi K
* Development Date   : 20180110
* Description        : Routine for validating when sub account still open
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date            Modified by                Description
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
	$INSERT I_F.AA.ARRANGEMENT
	$INSERT I_F.CUSTOMER
    $INSERT I_F.ATI.TH.EC.USERNAME

*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------

    GOSUB INIT
    GOSUB PROCESS

    RETURN

*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
    FN.ATI.TH.EC.USERNAME = 'F.ATI.TH.EC.USERNAME'
    F.ATI.TH.EC.USERNAME = ''
    CALL OPF(FN.ATI.TH.EC.USERNAME,F.ATI.TH.EC.USERNAME)

	FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT  = ''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)
	
    RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------

    Y.ARR.ID   = R.NEW(1)
	CALL F.READ(FN.AA.ARRANGEMENT, Y.ARR.ID, R.AA.ARRANGEMENT, F.AA.ARRANGEMENT, AA.ARR.ERR)
	Y.CUST.ID  = R.AA.ARRANGEMENT<AA.ARR.CUSTOMER>
	Y.PRODUCT  = R.AA.ARRANGEMENT<AA.ARR.PRODUCT>
	
	FIND "BUKO.TSS.ACT.MAIN" IN Y.PRODUCT SETTING YPOSF, YPOSV ELSE
	   RETURN
	END
	
    CALL DBR("CUSTOMER":FM:EB.CUS.EMAIL.1,Y.CUST.ID,Y.EMAIL) 

    CALL F.READ(FN.ATI.TH.EC.USERNAME, Y.EMAIL, R.ATI.TH.EC.USERNAME, F.ATI.TH.EC.USERNAME, EC.USR.ERR)
	Y.SUB.AC = R.ATI.TH.EC.USERNAME<EC.USER.SUB.AC>

	IF Y.SUB.AC THEN
	   ETEXT = 'Lakukan Penutupan Rekening Sub Terlebih Dahulu'
	   AF    = 1
	   CALL STORE.END.ERROR
	END
	
    RETURN
*-----------------------------------------------------------------------------
END




