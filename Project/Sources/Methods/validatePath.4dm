//%attributes = {}
#DECLARE($path : Text; $formPath : Text) : Text

var $buffer; $packagePath : Text
var $folder : 4D:C1709.Folder

/*
Returns a posix path according to the file location

Parameters         Type          Description
---------          ---------     ---------
$path              Text          Posix path to test
$formPath          Text          The .4dform posix full path

*/

If (isSubOf($path; $formPath; ->$buffer))
	
	// Relative to form folder
	return $buffer
	
Else 
	
	If (isSubOf($path; "/PACKAGE/"; ->$buffer))
		
		$packagePath:=$buffer
		$buffer:=""
		
		If (Not:C34(isSubOf($path; "/RESOURCES/"; ->$buffer)))
			
			If (Not:C34(isSubOf($path; "/SOURCES/"; ->$buffer)))
				
				If (Not:C34(isSubOf($path; "/PROJECT/"; ->$buffer)))
					
				End if 
			End if 
		End if 
		
		return $buffer="" ? $packagePath : $buffer
		
	End if 
End if 