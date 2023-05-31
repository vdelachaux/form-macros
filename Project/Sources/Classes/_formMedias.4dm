Class extends _formMacroHelper

Class constructor($macro : Object)
	
	Super:C1705($macro)
	
	This:C1470.macroForm:="FORM_MEDIAS"
	
	// === === === === === === === === === === === === === === === === === === === === === === ===
Function onInvoke($editor : Object) : Object
	
	var $data : Object
	var $result : Object
	
	Super:C1706.onInvoke($editor)
	
	$data:=New object:C1471(\
		"result"; False:C215; \
		"helper"; This:C1470; \
		"winRef"; This:C1470.OpenWindow(This:C1470.macroForm; Movable form dialog box:K39:8))
	
	DIALOG:C40(This:C1470.macroForm; $data)
	CLOSE WINDOW:C154($data.winRef)
	