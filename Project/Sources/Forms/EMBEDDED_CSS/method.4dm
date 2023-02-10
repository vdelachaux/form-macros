var $css; $e : Object

$e:=FORM Event:C1606

Case of 
		
		//______________________________________________________
	: ($e.code=On Load:K2:1)
		
		Form:C1466.embedded_css:=Form:C1466.helper.css
		
		Form:C1466.list:=New collection:C1472
		
		For each ($css; Form:C1466.embedded_css)
			
			Form:C1466.list.push(New object:C1471(\
				"path"; $css.path; \
				"media"; (($css.media="mac") | ($css.media="windows")) ? $css.media : "none"))
			
		End for each 
		
		//______________________________________________________
	: ($e.code=On Validate:K2:3)
		
		Form:C1466.result:=True:C214
		
		If (Size of array:C274(path)=0)
			
			Form:C1466.embedded_css:=Null:C1517
			return 
			
		End if 
		
		If (Form:C1466.list.length=1)\
			 && (Form:C1466.list[0].media="none")
			
			Form:C1466.embedded_css:=New collection:C1472(Form:C1466.list[0].path)
			
		Else 
			
			For each ($css; Form:C1466.list)
				
				If ($css.media="none")
					
					OB REMOVE:C1226($css; "media")
					
				End if 
				
			End for each 
			
			Form:C1466.embedded_css:=Form:C1466.list
			
		End if 
		
		//______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215)
		
		//______________________________________________________
End case 