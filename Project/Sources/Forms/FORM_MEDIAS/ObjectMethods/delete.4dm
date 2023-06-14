
CONFIRM:C162("Are you sure you want to delete this media?"; "Delete"; "Keep")

If (Bool:C1537(OK))
	
	var $o; $widget : Object
	$o:=Form:C1466.current
	
	If ($o.page=-1)  // Unused
		
		$o.media.delete()
		$o.dark.delete()
		$o.HD.delete()
		$o.HDDark.delete()
		
	Else 
		
		var $helper : cs:C1710._formMedias
		$helper:=Form:C1466.helper
		
		$helper.FORM_RESULT:=$helper.FORM_RESULT || $helper._form
		
		Case of 
				
				//______________________________________________________
			: ($o.type="button")
				
				$widget:=$helper.FORM_RESULT.pages[$o.pageNumber].objects[$o.name]
				OB REMOVE:C1226($widget; "icon")
				OB REMOVE:C1226($widget; "iconFrames")
				
				$o.icon:=Null:C1517
				
				//______________________________________________________
			: ($o.type="picture")
				
				$widget:=$helper.FORM_RESULT.pages[$o.pageNumber].objects[$o.name]
				OB REMOVE:C1226($widget; "picture")
				
				$o.picture:=Null:C1517
				
				//______________________________________________________
			: ($o.type="header")
				
				OB REMOVE:C1226($helper.editor.currentPage.objects[$o.name]; "icon")
				OB REMOVE:C1226($helper.editor.currentPage.objects[$o.name]; "iconFrames")
				//Form.helper.RESULT.currentPage:=Form.helper._currentPage
				
				$o.icon:=Null:C1517
				
				//______________________________________________________
			Else 
				
				ASSERT:C1129(Structure file:C489#Structure file:C489(*))
				
				//______________________________________________________
		End case 
	End if 
End if 