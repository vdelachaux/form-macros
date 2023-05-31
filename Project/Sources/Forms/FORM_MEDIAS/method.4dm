var $name; $path; $type : Text
var $media : Picture
var $ptr : Pointer
var $e; $o : Object
var $file : 4D:C1709.File
var $folder : 4D:C1709.Folder
var $helper : cs:C1710._formMacroHelper

$helper:=Form:C1466.helper
$e:=FORM Event:C1606

Case of 
		
		//______________________________________________________
	: ($e.code=On Load:K2:1)
		
		Form:C1466.missingMedia:=$helper.appResources.file("Images/Common/UnsupportedPict_64.png")
		Form:C1466.list:=[]
		
		$ptr:=->$type
		
		For each ($name; $helper.GetFormObjectNames(-3))
			
			$o:=$helper.GetFormObject($name; -3; $ptr)
			
			$o.path:=$o.picture || $o.icon
			
			If (Length:C16($o.path)>0)
				
				$o.name:=$name
				
				Case of 
						
						//______________________________________________________
					: ($o.path="/RESOURCES/@")
						
						$o.source:="Global"
						$path:=Delete string:C232($o.path; 1; 11)
						$o.media:=Folder:C1567(Folder:C1567(fk resources folder:K87:11; *).platformPath; fk platform path:K87:2).file($path)
						
						//______________________________________________________
					: ($o.path="#@")
						
						$o.source:="Global"
						$path:=Delete string:C232($o.path; 1; 1)
						$o.media:=Folder:C1567(Folder:C1567(fk resources folder:K87:11; *).platformPath; fk platform path:K87:2).file($path)
						
						//______________________________________________________
					: ($o.path="/.PRODUCT_RESOURCES/@")
						
						$o.source:="Exe"
						$path:=Delete string:C232($o.path; 1; 20)
						$o.media:=$helper.appResources.file($path)
						
						//______________________________________________________
					Else 
						
						$o.source:="Local"
						$o.media:=$helper.folder.file($o.path)
						
						//______________________________________________________
				End case 
				
				Form:C1466.list.push($o)
				
			End if 
		End for each 
		
		//______________________________________________________
	: ($e.code=On Selection Change:K2:29)
		
		SET TIMER:C645(-1)
		
		//______________________________________________________
	: ($e.code=On Data Change:K2:15)
		
		LISTBOX SELECT ROW:C912(*; "list"; Num:C11(Form:C1466.position); lk replace selection:K53:1)
		
		// TODO:Move or make a copy & update the object
		
		SET TIMER:C645(-1)
		
		//______________________________________________________
	: ($e.code=On Timer:K2:25)
		
		SET TIMER:C645(0)
		
		$file:=Form:C1466.current#Null:C1517 ? Form:C1466.current.media : Null:C1517
		
		If ($file#Null:C1517)
			
			If ($file.exists)
				
				READ PICTURE FILE:C678($file.platformPath; $media)
				
			Else 
				
				READ PICTURE FILE:C678(Form:C1466.missingMedia.platformPath; $media)
				
			End if 
		End if 
		
		Form:C1466.picture:=$media
		
		//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
End case 