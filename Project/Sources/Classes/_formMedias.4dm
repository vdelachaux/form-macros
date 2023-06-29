property RESULT : cs:C1710._formMacroResult

Class extends _formMacroHelper

Class constructor($macro : Object)
	
	Super:C1705($macro)
	
	This:C1470.UI_FORM:="FORM_MEDIAS"
	This:C1470.RESULT_CONFIRMATION_REQUEST:=True:C214
	
	// === === === === === === === === === === === === === === === === === === === === === === ===
Function LoadMedias() : Collection
	
	var $c : Collection
	$c:=[]
	
	var $icons : Object
	$icons:=This:C1470.ObjectIcons()
	
	var $name : Text
	var $o : Object
	For each ($name; This:C1470.GetObjectNames())
		
		$o:=This:C1470.GetObject($name)
		
		If ($o=Null:C1517)
			
			ASSERT:C1129(This:C1470.RELEASE)  // Trace in dev mode
			continue
			
		End if 
		
		$o.path:=$o.picture || $o.icon || $o.header.icon
		
		If (Length:C16(String:C10($o.path))>0)  // Widget with a media
			
			$o.name:=$o.header#Null:C1517 ? $o.header.name : $name
			
			If ($c.query("name = :1"; $o.name).length>0)
				
				continue
				
			End if 
			
			$o.fullName:=Split string:C1554($o.path; "/").last()
			$o.source:=This:C1470._source($o.path)
			
			$o.media:=This:C1470._resolveProxy($o.path)
			
			$o.dark:=This:C1470.DarkMedia($o.media)
			$o.darkOK:="✅"*Num:C11(Bool:C1537($o.dark && $o.dark.exists))
			
			$o.HD:=This:C1470.HDMedia($o.media)
			$o.hdOK:="✅"*Num:C11(Bool:C1537($o.HD && $o.HD.exists))
			
			$o.HDDark:=This:C1470.DarkMedia($o.HD)
			$o.hdDarkOK:="✅"*Num:C11(Bool:C1537($o.HDDark && $o.HDDark.exists))
			
			If ($o.customBackgroundPicture#Null:C1517)
				
				$o.fullName+=" / "+Split string:C1554($o.customBackgroundPicture; "/").last()
				
				$o.bkgSource:=This:C1470._source($o.customBackgroundPicture)
				$o.source:=$o.source+"/"+This:C1470._source($o.customBackgroundPicture)
				
				$o.bkgMedia:=This:C1470._resolveProxy($o.customBackgroundPicture)
				
				$o.bkgDark:=This:C1470.DarkMedia($o.bkgMedia)
				$o.darkOK+="/✅"*Num:C11(Bool:C1537($o.bkgDark && $o.bkgDark.exists))
				
				$o.bkgHD:=This:C1470.HDMedia($o.bkgMedia)
				$o.hdOK+="/✅"*Num:C11(Bool:C1537($o.bkgHD && $o.bkgHD.exists))
				
				$o.bkgHDDark:=This:C1470.DarkMedia($o.bkgHD)
				$o.hdDarkOK+="/✅"*Num:C11(Bool:C1537($o.bkgHDDark && $o.bkgHDDark.exists))
				
			End if 
			
			$o.typeIcon:=$o.type#Null:C1517\
				 ? $icons[$o.type]\
				 : $o.header#Null:C1517 ? $icons["listbox"] : Null:C1517
			
			$c.push($o)
			
		End if 
	End for each 
	
	// Append the unused local pictures
	var $file : 4D:C1709.File
	For each ($file; This:C1470.folder.folder("Images").files(fk ignore invisible:K87:22))
		
		If ($c.query("media.path = :1 OR dark.path = :1 OR HD.path = :1 OR HDDark.path = :1"; $file.path).pop()=Null:C1517)\
			 & ($c.query("bkgMedia.path = :1 OR bkgDark.path = :1 OR bkgHD.path = :1 OR bkgHDDark.path = :1"; $file.path).pop()=Null:C1517)
			
			$o:={\
				name: $file.name; \
				page: -1; \
				media: $file; \
				source: "Form"; \
				path: "Images/"+$file.fullName; \
				typeIcon: "⚠️"\
				}
			
			$o.fullName:=Split string:C1554($file.path; "/").last()
			
			$o.dark:=This:C1470.DarkMedia($o.media)
			$o.HD:=This:C1470.HDMedia($o.media)
			$o.HDDark:=This:C1470.DarkMedia($o.HD)
			
			$c.push($o)
			
		End if 
	End for each 
	
	return $c.orderBy("pageNumber asc, name asc")
	
	// === === === === === === === === === === === === === === === === === === === === === === ===
Function view($current : Object) : Collection
	
	var $choice; $menu : Text
	
	If ($current.customBackgroundPicture#Null:C1517)
		
		$menu:=Create menu:C408
		APPEND MENU ITEM:C411($menu; This:C1470.INTL ? "Foreground picture" : "Image d'avant-plan")
		SET MENU ITEM PARAMETER:C1004($menu; -1; "main")
		APPEND MENU ITEM:C411($menu; This:C1470.INTL ? "Background picture" : "Image de fond")
		SET MENU ITEM PARAMETER:C1004($menu; -1; "back")
		$choice:=Dynamic pop up menu:C1006($menu)
		RELEASE MENU:C978($menu)
		
		If (Length:C16($choice)=0)
			
			return 
			
		End if 
	End if 
	
	If ($choice="back")
		
		SHOW ON DISK:C922($current.bkgMedia.platformPath)
		
	Else 
		
		SHOW ON DISK:C922($current.media.platformPath)
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === ===
Function delete($current : Object) : Collection
	
	var $widget : Object
	var $choice; $menu : Text
	
	If ($current=Null:C1517)
		
		return 
		
	End if 
	
	If ($current.page=-1)  // Unused local picture
		
		If (This:C1470.INTL)
			
			CONFIRM:C162("Are you sure?\r\rThis file will be deleted immediatly.\rYou can't undo this action."; "Delete"; "Keep")
			
		Else 
			
			CONFIRM:C162("Êtes-vous certain ?\r\rCe fichier sera supprimé immédiatement.\rVous ne pouvez pas annuler cette action."; "Supprimer"; "Garder")
			
		End if 
		
		If (OK=0)
			
			return 
			
		End if 
		
		$current.media.delete()
		
		If ($current.dark#Null:C1517)
			$current.dark.delete()
			
		End if 
		
		If ($current.HD#Null:C1517)
			
			$current.HD.delete()
			
		End if 
		
		If ($current.HDDark#Null:C1517)
			
			$current.HDDark.delete()
			
		End if 
		
	Else 
		
		If ($current.customBackgroundPicture#Null:C1517)
			
			$menu:=Create menu:C408
			APPEND MENU ITEM:C411($menu; This:C1470.INTL ? "Foreground picture" : "Image d'avant-plan")
			SET MENU ITEM PARAMETER:C1004($menu; -1; "main")
			APPEND MENU ITEM:C411($menu; This:C1470.INTL ? "Background picture" : "Image de fond")
			SET MENU ITEM PARAMETER:C1004($menu; -1; "back")
			$choice:=Dynamic pop up menu:C1006($menu)
			RELEASE MENU:C978($menu)
			
			If (Length:C16($choice)=0)
				
				return 
				
			End if 
		End if 
		
		This:C1470.RESULT_FORM:=This:C1470.RESULT_FORM || This:C1470._form
		
		Case of 
				
				//______________________________________________________
			: ($current.type="button")
				
				$widget:=This:C1470.RESULT_FORM.pages[$current.pageNumber].objects[$current.name]
				
				If ($choice="back")
					
					OB REMOVE:C1226($widget; "customBackgroundPicture")
					
					OB REMOVE:C1226($current; "customBackgroundPicture")
					OB REMOVE:C1226($current; "bkgMedia")
					
				Else 
					
					OB REMOVE:C1226($widget; "icon")
					OB REMOVE:C1226($widget; "iconFrames")
					
					OB REMOVE:C1226($current; "icon")
					
					If ($current.customBackgroundPicture#Null:C1517)
						
						OB REMOVE:C1226($widget; "customBackgroundPicture")
						
						OB REMOVE:C1226($current; "customBackgroundPicture")
						OB REMOVE:C1226($current; "bkgMedia")
						
					End if 
				End if 
				
				//______________________________________________________
			: ($current.type="picture")
				
				$widget:=This:C1470.RESULT_FORM.pages[$current.pageNumber].objects[$current.name]
				OB REMOVE:C1226($widget; "picture")
				
				OB REMOVE:C1226($current; "picture")
				
				//______________________________________________________
			: ($current.header#Null:C1517)
				
				var $widgets : Object
				$widgets:=This:C1470.RESULT_FORM.pages[$current.pageNumber].objects
				
				var $key : Text
				var $column : Object
				For each ($key; $widgets) While ($widget=Null:C1517)
					
					If ($widgets[$key].columns=Null:C1517)
						
						continue  // Not a listbox
						
					End if 
					
					For each ($column; $widgets[$key].columns)
						
						If ($column.header.name=$current.name)
							
							$widget:=$column.header
							break
							
						End if 
					End for each 
				End for each 
				
				If ($widget#Null:C1517)
					
					OB REMOVE:C1226($widget; "icon")
					
					OB REMOVE:C1226($current.header; "icon")
					
				End if 
				
				//______________________________________________________
			Else 
				
				ASSERT:C1129(This:C1470.RELEASE)
				
				//______________________________________________________
		End case 
	End if 
	
	return This:C1470.LoadMedias()
	
	// === === === === === === === === === === === === === === === === === === === === === === ===
Function move($current : Object) : Collection
	
	var $old : Text
	var $widget : Object
	var $c : Collection
	var $file : 4D:C1709.File
	var $target : 4D:C1709.Folder
	
	This:C1470.RESULT_FORM:=This:C1470.RESULT_FORM || This:C1470._form
	
	If ($current.source="Form")
		
		// Mark:To RESOURCES/Images
		$target:=Folder:C1567("/RESOURCES/Images"; *)
		$target.create()
		
		$file:=$current.media
		$old:=$current.path
		
		Case of 
				
				//______________________________________________________
			: ($current.type="picture")
				
				$current.path:=$file.copyTo($target).path
				$current.picture:=$current.path
				$current.source:=This:C1470._source($current.path)
				$current.media:=This:C1470._resolveProxy($current.path)
				
				$widget:=This:C1470.RESULT_FORM.pages[$current.pageNumber].objects[$current.name]
				$widget.picture:=$current.path
				
				//______________________________________________________
			: ($current.type="button")
				
				// TODO:icon
				ASSERT:C1129(This:C1470.RELEASE)
				return 
				
				//______________________________________________________
			: ($current.header#Null:C1517)
				
				// TODO:header
				ASSERT:C1129(This:C1470.RELEASE)
				return 
				
				//______________________________________________________
		End case 
		
		$file.delete()
		
	Else 
		
		// Mark:To FORM/Images
		$target:=This:C1470.editor.file.parent.folder("Images")
		$target.create()
		
		$file:=$current.media
		
		Case of 
				
				//______________________________________________________
			: ($current.type="picture")
				
				$current.path:=Replace string:C233($file.copyTo($target).path; This:C1470.editor.file.parent.path; "")
				$current.picture:=$current.path
				$current.source:=This:C1470._source($current.path)
				$current.media:=This:C1470._resolveProxy($current.path)
				
				$widget:=This:C1470.RESULT_FORM.pages[$current.pageNumber].objects[$current.name]
				$widget.picture:=$current.path
				
				//______________________________________________________
			: ($current.type="button")
				
				// TODO:icon
				ASSERT:C1129(This:C1470.RELEASE)
				return 
				
				//______________________________________________________
			: ($current.header#Null:C1517)
				
				// TODO:header
				ASSERT:C1129(This:C1470.RELEASE)
				return 
				
				//______________________________________________________
		End case 
		
		$file.delete()
		
	End if 
	
	// Mark:Dark & HD
	If ($current.dark#Null:C1517)
		
		$current.dark:=$current.dark.copyTo($target)
		
	End if 
	
	If ($current.HD#Null:C1517)
		
		$current.HD:=$current.HD.copyTo($target)
		
	End if 
	
	If ($current.HDDark#Null:C1517)
		
		$current.HDDark:=$current.HDDark.copyTo($target)
		
	End if 
	
	$c:=This:C1470.LoadMedias()
	
	// Mark:Other widgets using the same media
	For each ($widget; $c)
		
		If ($widget.path#$old)
			
			continue
			
		End if 
		
		$widget.path:=$current.path
		
		Case of 
				
				//______________________________________________________
			: ($widget.type="picture")
				
				$widget.picture:=$current.picture
				
				//______________________________________________________
			: ($widget.type="button")
				
				$widget.icon:=$current.icon
				
				//______________________________________________________
			: ($widget.header#Null:C1517)
				
				// TODO:header
				ASSERT:C1129(This:C1470.RELEASE)
				
				//______________________________________________________
		End case 
		
		$widget.source:=$current.source
		$widget.media:=$current.media
		$widget.dark:=$current.dark
		$widget.HD:=$current.HD
		$widget.HDDark:=$current.HDDark
		
	End for each 
	
	return $c
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _source($path : Text) : Text
	
	Case of 
			
			//______________________________________________________
		: ($path="#@")\
			 | ($path="/RESOURCES/@")
			
			return "Resources"
			
			//______________________________________________________
		: ($path="|@")\
			 | ($path="/.PRODUCT_RESOURCES/@")
			
			return "App"
			
			//______________________________________________________
		Else 
			
			return "Form"
			
			//______________________________________________________
	End case 
	
	// === === === === === === === === === === === === === === === === === === === === === === ===
Function DarkMedia($media : 4D:C1709.File) : 4D:C1709.File
	
	If ($media=Null:C1517)
		
		return 
		
	End if 
	
	var $file : 4D:C1709.File
	$file:=$media.parent.file($media.name+This:C1470.darkSuffix+$media.extension)
	return $file.exists ? $file : Null:C1517
	
	// === === === === === === === === === === === === === === === === === === === === === === ===
Function HDMedia($media : 4D:C1709.File) : 4D:C1709.File
	
	If ($media=Null:C1517)
		
		return 
		
	End if 
	
	var $file : 4D:C1709.File
	$file:=$media.parent.file($media.name+This:C1470.hdSuffix+$media.extension)
	return $file.exists ? $file : Null:C1517
	