Class extends _formMacroHelper

Class constructor($macro : Object)
	
	Super:C1705($macro)
	
	This:C1470.UI_FORM:="FORM_STYLE_SHEETS"
	//This.RESULT:=cs._formMacroResult.new()
	
	// === === === === === === === === === === === === === === === === === === === === === === ===
Function onInvoke($editor : Object) : Object
	
	Super:C1706.onInvoke($editor)
	
	var $data : Object
	$data:=This:C1470.UI_DATA
	
	If (Bool:C1537($data.result))
		
		var $result : Object
		$result:={\
			formProperties: $editor.editor.formProperties\
			}
		
		If ($data.css=Null:C1517)
			
			OB REMOVE:C1226($result.formProperties; "css")
			
		Else 
			
			$result.formProperties.css:=$data.css
			
		End if 
		
		return $result
		
	End if 