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
			
			ASSERT:C1129(Structure file:C489#Structure file:C489(*))  // Trace in dev mode
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
	
	return $c
	
	// === === === === === === === === === === === === === === === === === === === === === === ===
Function view($current : Object) : Collection
	
	SHOW ON DISK:C922($current.media.platformPath)
	
	// === === === === === === === === === === === === === === === === === === === === === === ===
Function delete($current : Object) : Collection
	
	var $widget : Object
	
	If ($current.page=-1)  // Unused
		
		If (This:C1470.INTL)
			
			CONFIRM:C162("Are you sure you want to remove this media?"; "Delete"; "Keep")
			
		Else 
			
			CONFIRM:C162("Êtes-vous certain de vouloir supprimer ce média ?"; "Supprimer"; "Garder")
			
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
		
		This:C1470.RESULT_FORM:=This:C1470.RESULT_FORM || This:C1470._form
		
		Case of 
				
				//______________________________________________________
			: ($current.type="button")
				
				$widget:=This:C1470.RESULT_FORM.pages[$current.pageNumber].objects[$current.name]
				OB REMOVE:C1226($widget; "icon")
				OB REMOVE:C1226($widget; "iconFrames")
				
				$current.icon:=Null:C1517
				
				//______________________________________________________
			: ($current.type="picture")
				
				$widget:=This:C1470.RESULT_FORM.pages[$current.pageNumber].objects[$current.name]
				OB REMOVE:C1226($widget; "picture")
				
				$current.picture:=Null:C1517
				
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
				
				ASSERT:C1129(Structure file:C489#Structure file:C489(*))
				
				//______________________________________________________
		End case 
	End if 
	
	return This:C1470.LoadMedias()
	
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
	