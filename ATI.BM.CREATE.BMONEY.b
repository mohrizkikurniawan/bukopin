*-----------------------------------------------------------------------------
* <Rating>-181</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.BM.CREATE.BMONEY(Y.EC.USERNAME.ID)
*-----------------------------------------------------------------------------
* Developer Name     : Dwi K
* Development Date   : 2018
* Description        : Routine for create bmoney account
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date            Modified by                Description
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ATI.BM.CREATE.BMONEY.COMMON
	$INSERT I_F.ATI.TH.EC.USERNAME
	$INSERT I_F.AA.ARRANGEMENT.ACTIVITY
	$INSERT I_F.EB.EXTERNAL.USER
	
*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------
    GOSUB INIT
    GOSUB PROCESS

    RETURN

*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------

    RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    CALL F.READ(FN.ATI.TH.EC.USERNAME, Y.EC.USERNAME.ID,  R.ATI.TH.EC.USERNAME, F.ATI.TH.EC.USERNAME, ATI.TH.EC.USERNAME.ERR)
	Y.CUSTOMER            = R.ATI.TH.EC.USERNAME<EC.USER.CUSTOMER>
	Y.MOBILE.NO           = R.ATI.TH.EC.USERNAME<EC.USER.MOBILE.NO>
	Y.CO.CODE             = R.ATI.TH.EC.USERNAME<EC.USER.CO.CODE>
	Y.CUST.ONBOARD.STATUS = R.ATI.TH.EC.USERNAME<EC.USER.CUST.ONBOARD.STATUS>
	Y.NAME                = R.ATI.TH.EC.USERNAME<EC.USER.NAME>
	Y.EB.EXTERNAL.USER    = R.ATI.TH.EC.USERNAME<EC.USER.EB.EXTERNAL.USER>
	
	CALL F.READ(FN.EB.EXTERNAL.USER, Y.EB.EXTERNAL.USER, R.EB.EXTERNAL.USER, F.EB.EXTERNAL.USER, EB.EXTERNAL.USER.ERR)
	Y.TIME.LAST.USE = R.EB.EXTERNAL.USER<EB.XU.TIME.LAST.USE>

	Y.OFS.MESSAGE = ''
    Y.APP.NAME       = "AA.ARRANGEMENT.ACTIVITY"
    Y.OFS.FUNCT      = "I"
    Y.PROCESS        = "PROCESS"
    Y.GTS.MODE       = 1
    Y.NO.OF.AUTH     = 0
    Y.TRANSACTION.ID = ""
	
*    IF Y.CUST.ONBOARD.STATUS EQ "" THEN

*	IF Y.CUST.ONBOARD.STATUS EQ "DONE" THEN
*	   GOSUB WALLET.REGISTER
*	END ELSE
	   IF Y.TIME.LAST.USE NE "" THEN
	       GOSUB WALLET.UNREGISTER
	   END
*	END
	
	GOSUB GEN.OFS
	
	RETURN
*-----------------------------------------------------------------------------
WALLET.REGISTER:
*-----------------------------------------------------------------------------
	Y.OFS.VERSION   = "AA.ARRANGEMENT.ACTIVITY,ATI.WALLET.REG"
    CHANGE "+62" TO "" IN Y.MOBILE.NO
    Y.WALLET.AC     = "89" : Y.MOBILE.NO
	
    R.AAA.OFS<AA.ARR.ACT.ARRANGEMENT> = "NEW"
    R.AAA.OFS<AA.ARR.ACT.CUSTOMER>    = Y.CUSTOMER
    R.AAA.OFS<AA.ARR.ACT.CURRENCY>    = LCCY
    R.AAA.OFS<AA.ARR.ACT.ACTIVITY>    = "ACCOUNTS-NEW-ARRANGEMENT"
	R.AAA.OFS<AA.ARR.ACT.PROPERTY>    = "BALANCE"
    R.AAA.OFS<AA.ARR.ACT.PRODUCT>     = Y.WALLET.REGISTER
	R.AAA.OFS<AA.ARR.ACT.FIELD.NAME>  = "SHORT.TITLE" : @SM : "ACCOUNT.REFERENCE"
    R.AAA.OFS<AA.ARR.ACT.FIELD.VALUE> = Y.NAME : @SM : Y.WALLET.AC

    CALL OFS.BUILD.RECORD(Y.APP.NAME, Y.OFS.FUNCT, Y.PROCESS, Y.OFS.VERSION, Y.GTS.MODE, Y.NO.OF.AUTH, Y.TRANSACTION.ID, R.AAA.OFS, Y.OFS.MESSAGE)
		
    RETURN
*-----------------------------------------------------------------------------
WALLET.UNREGISTER:
*-----------------------------------------------------------------------------
	Y.OFS.VERSION = "AA.ARRANGEMENT.ACTIVITY,ATI.WALLET.UNREG"

    R.AAA.OFS<AA.ARR.ACT.FIELD.VALUE> = Y.EC.USERNAME.ID

    CALL OFS.BUILD.RECORD(Y.APP.NAME, Y.OFS.FUNCT, Y.PROCESS, Y.OFS.VERSION, Y.GTS.MODE, Y.NO.OF.AUTH, Y.TRANSACTION.ID, R.AAA.OFS, Y.OFS.MESSAGE) 

    RETURN
*-----------------------------------------------------------------------------
GEN.OFS:
*-----------------------------------------------------------------------------
    Y.OFS.SOURCE = "AA.COB"
	CALL OFS.INITIALISE.SOURCE(Y.OFS.SOURCE,"","LOG.ERROR")
*    CALL OFS.BULK.MANAGER(Y.OFS.MESSAGE, Y.PROCESS.FLAG, "")
	CALL OFS.CALL.BULK.MANAGER(Y.OFS.SOURCE, Y.OFS.MESSAGE, Y.OFS.RESPONSE, Y.TXN.RESULT)
		
    RETURN
*-----------------------------------------------------------------------------
END




