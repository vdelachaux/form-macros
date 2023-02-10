property macro : Object

Class constructor($macro : Object)
	
/*
	
Parameters     Type          Description
---------      ---------     ----------
$macro         Object        Macro declaration object (in the formMacros.json file)
	
*/
	
	This:C1470.macro:=$macro
	
	//=== === === === === === === === === === === === === === === === === === === === === === ===
Function onInvoke($editor : Object)->$result : Object
	
	var $windowRef : Integer
	var $data : Object
	
/*
	
Property                           Type          Description
---------                          ---------     ---------
$result.currentPage                Object        currentPage including objects modified by the macro, if any
$result.currentSelection           Collection    currentSelection if modified by the macro
$result.formProperties             Object        formProperties if modified by the macro
$result.eeditor.groups             Object        Group info, if groups are modified by the macro
$result.editor.views               Object        View info, if views are modified by the macro
$result.editor.activeView          Text          Active view name
	
*/
	
	$data:=New object:C1471
	$data.result:=False:C215
	$data.helper:=cs:C1710._MacroHelper.new($editor)
	
	//fixme:To remove if into the helper
	$data.form:=File:C1566($data.helper.file.platformPath; fk platform path:K87:2; *)  //unsandboxing
	//$data.embedded_css:=$data.helper.css
	$data.validatepath:=Formula:C1597(validatePath)
	$data.isInsidePackage:=Formula:C1597(isInsidePackage)
	$data.addRow:=Formula:C1597(addRow)
	
	// TODO:Center to the current form window
	$windowRef:=Open form window:C675("EMBEDDED_CSS"; Movable form dialog box:K39:8)
	DIALOG:C40("EMBEDDED_CSS"; $data)
	CLOSE WINDOW:C154($windowRef)
	
	$result:=New object:C1471
	
	If ($data.result=True:C214)
		
		$result.formProperties:=$editor.editor.formProperties
		
		If ($data.embedded_css=Null:C1517)
			
			OB REMOVE:C1226($result.formProperties; "css")
			
		Else 
			
			$result.formProperties.css:=$data.embedded_css
			
		End if 
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === ===
Function onError($editor : Object; $result : Object; $errors : Collection)
/* <- IN
	
Property                      Type          Description
---------                     ---------     ---------
$editor                       Object        Object send to onInvoke
$resultMacro                  Object        Object returned by onInvoke
$error                        Collection    Error stack
$error.errCode                Number        Error code
$error.message                Text          Description of the error
$error.componentSignature     Text          Internal component signature
	
*/
	
	ALERT:C41($errors.extract("message").join("\n"))