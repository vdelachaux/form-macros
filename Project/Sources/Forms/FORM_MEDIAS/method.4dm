var $e : Object
$e:=FORM Event:C1606

var $helper : cs:C1710._formMacroHelper
$helper:=Form:C1466.helper

Case of 
		
		//______________________________________________________
	: ($e.code=On Load:K2:1)
		
		var $name; $path : Text
		var $indx : Integer
		var $o : Object
		
		Form:C1466.missingMedia:=$helper.appResources.file("Images/Common/UnsupportedPict_64.png")
		Form:C1466.list:=[]
		
		For each ($name; $helper.GetFormObjectNames($helper.ALL_PAGES))
			
			$o:=$helper.GetFormObject($name; $helper.ALL_PAGES)
			
			If ($o=Null:C1517)
				
				continue
				
			End if 
			
			$o.path:=$o.picture || $o.icon || $o.header.icon
			
			If ($o.path && (Length:C16($o.path)>0))
				
				$o.name:=$o.header#Null:C1517 ? $o.header.name : $name
				
				Case of 
						
						//______________________________________________________
					: ($o.path="/RESOURCES/@")
						
						$o.source:="Resources"
						$path:=Delete string:C232($o.path; 1; 11)
						$o.media:=$helper.resourcesFolder.file($path)
						
						//______________________________________________________
					: ($o.path="#@")
						
						$o.source:="Resources"
						$path:=Delete string:C232($o.path; 1; 1)
						$o.media:=$helper.resourcesFolder.file($path)
						
						//______________________________________________________
					: ($o.path="/.PRODUCT_RESOURCES/@")
						
						$o.source:="Exe"
						$path:=Delete string:C232($o.path; 1; 20)
						$o.media:=$helper.appResources.file($path)
						
						//______________________________________________________
					: ($o.path="|@")
						
						$o.source:="Exe"
						$path:=Delete string:C232($o.path; 1; 1)
						$o.media:=$helper.appResources.file($path)
						
						//______________________________________________________
					Else 
						
						$o.source:="Form"
						$o.media:=$helper.folder.file($o.path)
						
						//______________________________________________________
				End case 
				
				Form:C1466.list.push($o)
				
			End if 
		End for each 
		
		If (Form:C1466.list.length>0)
			
			Form:C1466.list:=Form:C1466.list.orderBy("pageNumber asc, name asc")
			
			If ($helper.selection.length>0)
				
				$indx:=Form:C1466.list.indices("name = :1 OR header.name = :1"; $helper.selection[0]).shift()  // First one
				
			End if 
			
			LISTBOX SELECT ROW:C912(*; "list"; $indx+1; lk replace selection:K53:1)
			Form:C1466.current:=Form:C1466.list[$indx]
			SET TIMER:C645(-1)
			
		End if 
		
		//______________________________________________________
	: ($e.code=On Timer:K2:25)
		
		SET TIMER:C645(0)
		
		var $media : Picture
		var $file : 4D:C1709.File
		
		$file:=Form:C1466.current ? Form:C1466.current.media : Null:C1517
		
		If ($file#Null:C1517)
			
			OBJECT SET VISIBLE:C603(*; "view"; True:C214)
			OBJECT SET TITLE:C194(*; "view"; Form:C1466.current.path)
			
			If ($file.exists)
				
				OBJECT SET ENABLED:C1123(*; "view"; True:C214)
				READ PICTURE FILE:C678($file.platformPath; $media)
				
				//TODO: Test if "@X2" & "_dark" declinations are present
				
			Else 
				
				OBJECT SET ENABLED:C1123(*; "view"; False:C215)
				READ PICTURE FILE:C678(Form:C1466.missingMedia.platformPath; $media)
				
			End if 
			
		Else 
			
			OBJECT SET VISIBLE:C603(*; "view"; False:C215)
			
		End if 
		
		Form:C1466.picture:=$media
		
		//______________________________________________________
	: ($e.code=On Selection Change:K2:29)
		
		SET TIMER:C645(-1)
		
		//______________________________________________________
	: ($e.code=On Data Change:K2:15)
		
		LISTBOX SELECT ROW:C912(*; "list"; Num:C11(Form:C1466.position); lk replace selection:K53:1)
		
		// TODO:Move or make a copy & update the object
		
		SET TIMER:C645(-1)
		
		//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
End case 