*-----------------------------------------------------------------------------
* <Rating>-1</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.TT.JURNAL.TRANSACTION.FIELDS
*-----------------------------------------------------------------------------
* Developer Name     : Dhio Faizar Wahyudi
* Development Date   : 20171024
* Description        : Table to accomodate total of transaction based on GL.CODE that attach to TRANSACTION's Table
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date            Modified by                Description
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes

*-----------------------------------------------------------------------------
    ID.CHECKFILE = "" ; ID.CONCATFILE = ""
    ID.F = "@ID" ; ID.N ="25" ; ID.T = "A"

    RETURN
*-----------------------------------------------------------------------------
END





