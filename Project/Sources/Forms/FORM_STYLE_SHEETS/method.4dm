var $name; $path : Text
var $item
var $css; $e : Object
var $file : 4D:C1709.File

$e:=FORM Event:C1606

var $helper : cs:C1710._formMacroHelper
$helper:=Form:C1466.helper

Case of 
		
		//______________________________________________________
	: ($e.code=On Load:K2:1)
		
		Form:C1466.list:=[]
		
		For each ($item; $helper.css)
			
			If (Value type:C1509($item)=Is object:K8:27)
				
				Form:C1466.list.push(New object:C1471(\
					"path"; $item.path; \
					"media"; $item.media="mac" ? "macOS" : ($item.media="windows" ? "Windows" : "All")))
				
			Else 
				
				Form:C1466.list.push(New object:C1471(\
					"path"; $item; \
					"media"; "All"))
				
			End if 
			
		End for each 
		
		OBJECT SET ENABLED:C1123(*; "minus"; False:C215)
		
		SET TIMER:C645(-1)
		
		//______________________________________________________
	: ($e.code=On Timer:K2:25)
		
		SET TIMER:C645(0)
		
		OBJECT SET ENABLED:C1123(*; "minus"; Form:C1466.current#Null:C1517)
		
		//______________________________________________________
	: ($e.code=On Selection Change:K2:29)
		
		SET TIMER:C645(-1)
		
		//______________________________________________________
	: ($e.code=On Clicked:K2:4)
		
		Case of 
				
				//……………………………………………………………………………………………………………
			: ($e.objectName="list")
				
				If ($e.column=1) & (Contextual click:C713)
					
					//TODO: Menu Reveal in Desktop…
					
				End if 
				
				//……………………………………………………………………………………………………………
			: ($e.objectName="plus")
				
				$name:=Select document:C905(String:C10($helper.file.parent.platformPath); ".css"; "Select CSS File"; Package open:K24:8+Use sheet window:K24:11)
				
				If (Bool:C1537(OK))
					
					$file:=File:C1566(DOCUMENT; fk platform path:K87:2)
					
					$path:=$helper.ValidatePath($file.path; $helper.file.parent.path)
					
					If (Length:C16($path)>0)
						
						If (Form:C1466.list.query("value =:1"; $path).pop()=Null:C1517)
							
							Form:C1466.list.push(New object:C1471(\
								"path"; $path; \
								"media"; Position:C15("mac"; $name)>0 ? "macOS" : (Position:C15("win"; $name)>0 ? "Windows" : "All")))
							
						Else 
							
							ALERT:C41("This path is already registered")
							
						End if 
						
					Else 
						
						If ($helper.isInsidePackage($file.path))
							
							ALERT:C41("The pathname \""+$file.platformPath+"\" is not valid")
							
						Else 
							
							// Outside of database package, not allowed
							ALERT:C41("CSS file must be inside the database folder")
							
						End if 
					End if 
				End if 
				
				//……………………………………………………………………………………………………………
			: ($e.objectName="minus")
				
				Form:C1466.list.remove(Form:C1466.position-1)
				SET TIMER:C645(-1)
				
				//……………………………………………………………………………………………………………
		End case 
		
		//______________________________________________________
	: ($e.code=On Validate:K2:3)
		
		Form:C1466.result:=True:C214
		
		If (Form:C1466.list.length=0)
			
			Form:C1466.css:=Null:C1517
			return 
			
		End if 
		
		If (Form:C1466.list.length=1)\
			 && (Form:C1466.list[0].media="All")
			
			Form:C1466.css:=New collection:C1472(Form:C1466.list[0].path)
			
		Else 
			
			For each ($css; Form:C1466.list)
				
				If ($css.media="All")
					
					OB REMOVE:C1226($css; "media")
					
				Else 
					
					$css.media:=$css.media="macOS" ? "mac" : "windows"
					
				End if 
			End for each 
			
			Form:C1466.css:=Form:C1466.list
			
		End if 
		
		//______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215)
		
		//______________________________________________________
End case 