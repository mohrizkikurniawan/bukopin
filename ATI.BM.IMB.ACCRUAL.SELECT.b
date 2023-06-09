*-----------------------------------------------------------------------------
* <Rating>-30</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.BM.IMB.ACCRUAL.SELECT
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
    $INSERT I_F.DATES
    $INSERT I_ATI.BM.IMB.ACCRUAL.COMMON

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

    SEL.CMD = "SELECT " : FN.ATI.TL.IMB.ACCRUAL : " WITH MATURE.DATE GT " : R.DATES(EB.DAT.LAST.WORKING.DAY) 
    SEL.LIST = ''
    CALL EB.READLIST(SEL.CMD, SEL.LIST, '', SEL.CNT, SEL.ERR)

    CALL BATCH.BUILD.LIST('',SEL.LIST)

    RETURN

*-----------------------------------------------------------------------------
END

