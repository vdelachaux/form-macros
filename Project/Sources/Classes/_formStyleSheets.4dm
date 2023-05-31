Class extends _formMacroHelper

Class constructor($macro : Object)
	
	Super:C1705($macro)
	
	// === === === === === === === === === === === === === === === === === === === === === === ===
Function onInvoke($editor : Object) : Object
	
	var $data : Object
	var $result : Object
	
	Super:C1706.onInvoke($editor)
	
	$data:=New object:C1471(\
		"result"; False:C215; \
		"helper"; This:C1470; \
		"winRef"; This:C1470.OpenWindow("FORM_STYLE_SHEETS"; Movable form dialog box:K39:8))
	
	DIALOG:C40("FORM_STYLE_SHEETS"; $data)
	CLOSE WINDOW:C154($data.winRef)
	
	$result:=New object:C1471
	
	If ($data.result=True:C214)
		
		$result.formProperties:=$editor.editor.formProperties
		
		If ($data.css=Null:C1517)
			
			OB REMOVE:C1226($result.formProperties; "css")
			
		Else 
			
			$result.formProperties.css:=$data.css
			
		End if 
	End if 
	
	return $result