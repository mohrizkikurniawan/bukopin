*-----------------------------------------------------------------------------
* <Rating>-181</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE ATI.VIN.ADD.FAVORITE
*-----------------------------------------------------------------------------
* Developer Name     : Dhio Faizar Wahyudi
* Development Date   : 20180314
* Description        : Routine for add favorite
*-----------------------------------------------------------------------------
* Modification History:-
*-----------------------------------------------------------------------------
* Date            Modified by                Description
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ATI.TH.FAVOURITE.CONTACT

*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------
    GOSUB INIT
    GOSUB PROCESS

    RETURN

*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------
	
	Y.ATI.TH.FAVOURITE.CONTACT.ID.NO.SAVE = R.OLD(FAV.CONTACT.ID.NO)
	Y.ATI.TH.FAVOURITE.CONTACT.NAME.SAVE  = R.OLD(FAV.CONTACT.NAME)
	
	Y.ATI.TH.FAVOURITE.CONTACT.ID.NO = R.NEW(FAV.CONTACT.ID.NO)<1,1>
	Y.ATI.TH.FAVOURITE.CONTACT.NAME  = R.NEW(FAV.CONTACT.NAME)<1,1>

    RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
	
	FIND Y.ATI.TH.FAVOURITE.CONTACT.ID.NO IN Y.ATI.TH.FAVOURITE.CONTACT.ID.NO.SAVE SETTING Y.POSF, Y.POSV, Y.POSS THEN
		Y.ATI.TH.FAVOURITE.CONTACT.NAME.SAVE<1, Y.POSV> = Y.ATI.TH.FAVOURITE.CONTACT.NAME
	END ELSE
		Y.ATI.TH.FAVOURITE.CONTACT.ID.NO.SAVE<1, -1> = Y.ATI.TH.FAVOURITE.CONTACT.ID.NO
		Y.ATI.TH.FAVOURITE.CONTACT.NAME.SAVE<1, -1> = Y.ATI.TH.FAVOURITE.CONTACT.NAME
	END
	
	R.NEW(FAV.CONTACT.ID.NO) = Y.ATI.TH.FAVOURITE.CONTACT.ID.NO.SAVE
	R.NEW(FAV.CONTACT.NAME)  = Y.ATI.TH.FAVOURITE.CONTACT.NAME.SAVE
	
    RETURN
*-----------------------------------------------------------------------------
END




