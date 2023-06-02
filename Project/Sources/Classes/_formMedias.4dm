Class extends _formMacroHelper

Class constructor($macro : Object)
	
	Super:C1705($macro)
	
	This:C1470.FORM:="FORM_MEDIAS"
	This:C1470.RESULT:={}
	
	This:C1470.darkSuffix:="_dark"
	This:C1470.hdSuffix:="@2x"
	
	// === === === === === === === === === === === === === === === === === === === === === === ===
Function onInvoke($editor : Object) : Object
	
	Super:C1706.onInvoke($editor)
	
	If (Not:C34(OB Is empty:C1297(This:C1470.RESULT)))
		
		return This:C1470.RESULT
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === ===
Function LoadMedias() : Collection
	
	var $c : Collection
	$c:=[]
	
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
			
			Case of 
					
					//______________________________________________________
				: ($o.path="/RESOURCES/@")
					
					$o.source:="Resources"
					$o.media:=This:C1470.resourcesFolder.file(Delete string:C232($o.path; 1; 11))
					
					//______________________________________________________
				: ($o.path="#@")
					
					$o.source:="Resources"
					$o.media:=This:C1470.resourcesFolder.file(Delete string:C232($o.path; 1; 1))
					
					//______________________________________________________
				: ($o.path="/.PRODUCT_RESOURCES/@")
					
					$o.source:="Exe"
					$o.media:=This:C1470.appResources.file(Delete string:C232($o.path; 1; 20))
					
					//______________________________________________________
				: ($o.path="|@")
					
					$o.source:="Exe"
					$o.media:=This:C1470.appResources.file(Delete string:C232($o.path; 1; 1))
					
					//______________________________________________________
				Else 
					
					$o.source:="Form"
					$o.media:=This:C1470.folder.file($o.path)
					
					//______________________________________________________
			End case 
			
			$o.dark:=This:C1470.DarkMedia($o.media)
			$o.HD:=This:C1470.HDMedia($o.media)
			$o.HDDark:=This:C1470.HDMedia($o.HD)
			
			$c.push($o)
			
		End if 
	End for each 
	
	// Append the unused local pictures
	var $file : 4D:C1709.File
	For each ($file; This:C1470.folder.folder("Images").files(fk ignore invisible:K87:22))
		
		If ($c.indexOf($file)=-1)
			
			$o:={\
				name: "⚠️ "+$file.name; \
				page: -1; \
				media: $file; \
				source: "Form"; \
				path: "Images/"+$file.fullName\
				}
			
			$o.dark:=This:C1470.DarkMedia($o.media)
			$o.HD:=This:C1470.HDMedia($o.media)
			$o.HDDark:=This:C1470.HDMedia($o.HD)
			
			$c.push($o)
			
		End if 
	End for each 
	
	return $c
	
	// === === === === === === === === === === === === === === === === === === === === === === ===
Function DarkMedia($media : 4D:C1709.File) : 4D:C1709.File
	
	return $media.parent.file($media.name+This:C1470.darkSuffix+$media.extension)
	
	// === === === === === === === === === === === === === === === === === === === === === === ===
Function HDMedia($media : 4D:C1709.File) : 4D:C1709.File
	
	return $media.parent.file($media.name+This:C1470.hdSuffix+$media.extension)
	