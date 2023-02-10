var $name; $pathname : Text
var $e : Object
var $c : Collection
var $css; $file : 4D:C1709.File

$e:=FORM Event:C1606

$c:=New collection:C1472
ARRAY TO COLLECTION:C1563($c; path)

Case of 
		
		//______________________________________________________
	: ($e.code=On Before Data Entry:K2:39)
		
		//Form.oldValue:=path{$e.row}.value
		
		//______________________________________________________
	: ($e.code=On Data Change:K2:15)
		
		//If (path{$e.row}.value="")
		
		//path{$e.row}.value:=Form.oldValue
		
		//Else 
		
		//If ($c.query("value =:1"; path{$e.row}.value).pop()#Null)
		
		//path{$e.row}.value:=Form.oldValue
		
		//ALERT("This path is already registered")
		
		//End if 
		//End if 
		
		//______________________________________________________
	: ($e.code=On Alternative Click:K2:36)
		
		//$pathname:=path{$e.row}.value
		
		//If (Length($pathname)=0)
		
		//$file:=File(Form.form.path)
		
		//Else 
		
		//If (($pathname[[1]]="/")\
			 || (Is Windows && ($pathname[[2]]=":") && (($pathname[[3]]="/"))))
		
		//// A filesystem path or a full path
		//$file:=File(path{$e.row}.value)
		
		//Else 
		
		//// No "/" = path relative to form
		//$file:=File(Form.form.parent.path+path{$e.row}.value)
		
		//End if 
		//End if 
		
		$name:=Select document:C905($file.parent.platformPath; ".css"; "Select CSS File"; 16)
		
		If (Bool:C1537(OK))
			
			$css:=File:C1566(DOCUMENT; fk platform path:K87:2)
			
			$pathname:=Form:C1466.validatepath($css.path; Form:C1466.form.parent.path)
			
			If (Length:C16($pathname)>0)
				
				If ($c.query("value =:1"; $pathname).pop()=Null:C1517)
					
					//path{$e.row}.value:=$pathname
					
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
		End if 
		
		//______________________________________________________
	Else 
		
		ASSERT:C1129(False:C215)
		
		//______________________________________________________
End case 