//%attributes = {}
#DECLARE($path : Text; $formPath : Text; $pathPtr : Pointer) : Boolean

If (False:C215)
	C_TEXT:C284(isSubOf; $1)
	C_TEXT:C284(isSubOf; $2)
	C_POINTER:C301(isSubOf; $3)
	C_BOOLEAN:C305(isSubOf; $0)
End if 

var $destFolder : Text
var $success : Boolean

If (Count parameters:C259=3)
	
	$pathPtr->:=""
	
End if 

If ($formPath="/PACKAGE/")\
 || ($formPath="/RESOURCES/")\
 || ($formPath="/SOURCES/")\
 || ($formPath="/PROJECT/")
	
	$destFolder:=Folder:C1567(Folder:C1567($formPath; fk posix path:K87:1; *).platformPath; fk platform path:K87:2).path
	
Else 
	
	$destFolder:=$formPath
	
End if 

If (Length:C16($path)>Length:C16($destFolder))
	
	$success:=(Substring:C12($path; 1; Length:C16($destFolder))=$destFolder)
	
	If (($success=True:C214)\
		 & (Not:C34(Is nil pointer:C315($pathPtr))))
		
		$pathPtr->:=$formPath
		$pathPtr->+=Substring:C12($path; Length:C16($destFolder)+1; Length:C16($path)-Length:C16($destFolder))
		
	End if 
End if 

return $success