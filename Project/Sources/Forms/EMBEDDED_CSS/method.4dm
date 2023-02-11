var $name; $path : Text
var $item
var $css; $e : Object
var $file : 4D:C1709.File

$e:=FORM Event:C1606

Case of 
		
		//______________________________________________________
	: ($e.code=On Load:K2:1)
		
		Form:C1466.embedded_css:=Form:C1466.helper.css
		
		Form:C1466.list:=New collection:C1472
		
		For each ($item; Form:C1466.embedded_css)
			
			If (Value type:C1509($item)=Is object:K8:27)
				
				Form:C1466.list.push(New object:C1471(\
					"path"; $css.path; \
					"media"; $css.media="mac" ? "macOS" : ($css.media="windows" ? "Windows" : "All")))
				
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
			: ($e.objectName="plus")
				
				$name:=Select document:C905(String:C10(Form:C1466.form.parent.platformPath); ".css"; "Select CSS File"; Package open:K24:8+Use sheet window:K24:11)
				
				If (Bool:C1537(OK))
					
					$file:=File:C1566(DOCUMENT; fk platform path:K87:2)
					
					$path:=Form:C1466.validatepath($file.path; Form:C1466.form.parent.path)
					
					If (Length:C16($path)>0)
						
						If (Form:C1466.list.query("value =:1"; $path).pop()=Null:C1517)
							
							Form:C1466.list.push(New object:C1471(\
								"path"; $path; \
								"media"; Position:C15("mac"; $name)>0 ? "macOS" : (Position:C15("win"; $name)>0 ? "Windows" : "All")))
							
						Else 
							
							ALERT:C41("This path is already registered")
							
						End if 
						
					Else 
						
						If (Not:C34(Form:C1466.isInsidePackage($file.path)))
							
							// Outside of database package, not allowed
							ALERT:C41("CSS file must be inside the database folder")
							
						Else 
							
							ALERT:C41("The pathname \""+$file.platformPath+"\" is not valid")
							
						End if 
					End if 
					
				End if 
				
				//……………………………………………………………………………………………………………
			: ($e.objectName="minus")
				
				Form:C1466.list.remove(Form:C1466.position-1)
				SET TIMER:C645(-1)
				
				//……………………………………………………………………………………………………………
			Else 
				
				// A "Case of" statement should never omit "Else"
				
				//……………………………………………………………………………………………………………
		End case 
		
		//______________________________________________________
	: ($e.code=On Validate:K2:3)
		
		Form:C1466.result:=True:C214
		
		If (Form:C1466.list.length=0)
			
			Form:C1466.embedded_css:=Null:C1517
			return 
			
		End if 
		
		If (Form:C1466.list.length=1)\
			 && (Form:C1466.list[0].media="All")
			
			Form:C1466.embedded_css:=New collection:C1472(Form:C1466.list[0].path)
			
		Else 
			
			For each ($css; Form:C1466.list)
				
				If ($css.media="All")
					
					OB REMOVE:C1226($css; "media")
					
				Else 
					
					$css.media:=$css.media="macOS" ? "mac" : "windows"
					
				End if 
			End for each 
			
			Form:C1466.embedded_css:=Form:C1466.list
			
		End if 
		
		//______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215)
		
		//______________________________________________________
End case 