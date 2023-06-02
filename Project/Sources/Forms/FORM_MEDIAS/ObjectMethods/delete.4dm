
CONFIRM:C162("Are you sure you want to delete this media?"; "Delete"; "Keep")

If (Bool:C1537(OK))
	
	var $o : Object
	$o:=Form:C1466.current
	
	If ($o.page=-1)  // Unused
		
		$o.media.delete()
		$o.dark.delete()
		$o.HD.delete()
		$o.HDDark.delete()
		
	Else 
		
		var $helper : cs:C1710._formMedias
		$helper:=Form:C1466.helper
		
		Case of 
				
				//______________________________________________________
			: ($o.type="button")
				
				OB REMOVE:C1226($helper.editor.currentPage.objects[$o.name]; "icon")
				OB REMOVE:C1226($helper.editor.currentPage.objects[$o.name]; "iconFrames")
				Form:C1466.helper.RESULT.currentPage:=Form:C1466.helper._currentPage
				
				$o.icon:=Null:C1517
				
				//______________________________________________________
			: ($o.type="picture")
				
				OB REMOVE:C1226($helper.editor.currentPage.objects[$o.name]; "picture")
				Form:C1466.helper.RESULT.currentPage:=Form:C1466.helper._currentPage
				
				$o.picture:=Null:C1517
				
				//______________________________________________________
			: ($o.type="header")
				
				OB REMOVE:C1226($helper.editor.currentPage.objects[$o.name]; "icon")
				OB REMOVE:C1226($helper.editor.currentPage.objects[$o.name]; "iconFrames")
				Form:C1466.helper.RESULT.currentPage:=Form:C1466.helper._currentPage
				
				$o.icon:=Null:C1517
				
				//______________________________________________________
			Else 
				
				ASSERT:C1129(Structure file:C489#Structure file:C489(*))
				
				//______________________________________________________
		End case 
	End if 
End if 