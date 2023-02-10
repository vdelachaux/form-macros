//%attributes = {}
#DECLARE($pathname : Text)

If (False:C215)
	C_TEXT:C284(addRow; $1)
End if 

var $path : Text
var $c : Collection
var $css : 4D:C1709.File

$c:=New collection:C1472
ARRAY TO COLLECTION:C1563($c; path)

$css:=File:C1566($pathname; fk platform path:K87:2)

$path:=Form:C1466.validatepath($css.path; Form:C1466.form.parent.path)

If (Length:C16($path)>0)
	
	If ($c.query("value =:1"; $path).pop()=Null:C1517)
		
		//APPEND TO ARRAY(path; New object(\
			"valueType"; "text"; \
			"value"; $path; \
			"alternateButton"; True))
		
		//APPEND TO ARRAY(media; "none")
		
		//For ($i; 1; Size of array(listBoxSel); 1)
		
		//listBoxSel{$i}:=False
		
		//End for 
		
		//APPEND TO ARRAY(listBoxSel; True)
		
	Else 
		
		ALERT:C41("This path is already registered")
		
	End if 
	
Else 
	
	If (Not:C34(Form:C1466.isInsidePackage($css.path)))
		
		// Outside of database package, not allowed
		ALERT:C41("CSS file must be inside the database folder")
		
	Else 
		
		ALERT:C41("Bad Path")
		
	End if 
End if 