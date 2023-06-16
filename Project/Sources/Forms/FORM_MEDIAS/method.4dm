var $e : Object
$e:=FORM Event:C1606

var $helper : cs:C1710._formMedias
$helper:=Form:C1466.helper

Case of 
		
		//______________________________________________________
	: ($e.code=On Load:K2:1)
		
		SET WINDOW TITLE:C213("Medias: "+$helper.editor.name)
		OBJECT SET SCROLLBAR:C843(*; "list"; 0; 2)
		
		//______________________________________________________
	: ($e.code=On Activate:K2:9)
		
		Form:C1466.list:=$helper.LoadMedias()
		
		var $indx : Integer
		
		If (Form:C1466.list.length>0)
			
			$indx:=Form:C1466.position-1
			
			If ($indx=-1)
				
				$indx:=$helper.selection.length>0\
					 ? Form:C1466.list.indices("name = :1 OR header.name = :1"; $helper.selection[0]).shift()\
					 : 0
				
			End if 
			
			LISTBOX SELECT ROW:C912(*; "list"; $indx+1; lk replace selection:K53:1)
			Form:C1466.current:=Form:C1466.list[$indx]
			SET TIMER:C645(-1)
			
		End if 
		
		//______________________________________________________
	: ($e.code=On Clicked:K2:4)
		
		If (OB Instance of:C1731($helper[$e.objectName]; 4D:C1709.Function))
			
			Form:C1466.list:=$helper[$e.objectName](Form:C1466.current) || Form:C1466.list
			SET TIMER:C645(-1)
			
		End if 
		
		//______________________________________________________
	: ($e.code=On Selection Change:K2:29)
		
		SET TIMER:C645(-1)
		
		//______________________________________________________
	: ($e.code=On Timer:K2:25)
		
		SET TIMER:C645(0)
		
		OBJECT SET VISIBLE:C603(*; "alert"; False:C215)
		OBJECT SET HELP TIP:C1181(*; "move"; "")
		OBJECT SET HELP TIP:C1181(*; "delete"; "")
		
		var $bkg; $media : Picture
		var $height; $width : Integer
		var $current : Object
		var $file : 4D:C1709.File
		
		$current:=Form:C1466.current
		$file:=$current ? $current.media : Null:C1517
		
		Form:C1466.picture:=$media
		
		If ($file=Null:C1517)
			
			OBJECT SET VISIBLE:C603(*; "view"; False:C215)
			OBJECT SET VISIBLE:C603(*; "delete"; False:C215)
			OBJECT SET VISIBLE:C603(*; "move"; False:C215)
			OBJECT SET RGB COLORS:C628(*; "name"; "red")
			return 
			
		End if 
		
		OBJECT SET VISIBLE:C603(*; "view"; True:C214)
		OBJECT SET VISIBLE:C603(*; "delete"; True:C214)
		OBJECT SET VISIBLE:C603(*; "move"; True:C214)
		
		If (Not:C34($file.exists))
			
			OBJECT SET ENABLED:C1123(*; "view"; False:C215)
			OBJECT SET ENABLED:C1123(*; "move"; False:C215)
			OBJECT SET RGB COLORS:C628(*; "name"; "red")
			OBJECT SET HELP TIP:C1181(*; "delete"; "Remove this reference")
			
			return 
			
		End if 
		
		OBJECT SET ENABLED:C1123(*; "view"; True:C214)
		OBJECT SET ENABLED:C1123(*; "move"; ($current.source#"App") & ($current.pageNumber>=0))
		OBJECT SET RGB COLORS:C628(*; "name"; Foreground color:K23:1)
		
		OBJECT SET HELP TIP:C1181(*; "delete"; $current.pageNumber=Null:C1517 ? "Delete this file" : "")
		
		If (FORM Get color scheme:C1761="dark")\
			 && ($current.dark.exists)
			
			READ PICTURE FILE:C678($current.dark.platformPath; $media)
			
		Else 
			
			READ PICTURE FILE:C678($file.platformPath; $media)
			
		End if 
		
		If ($current.bkgMedia#Null:C1517)
			
			If (FORM Get color scheme:C1761="dark")\
				 && ($current.bkgDark.exists)
				
				READ PICTURE FILE:C678($current.bkgDark.platformPath; $bkg)
				
			Else 
				
				READ PICTURE FILE:C678($current.bkgMedia.platformPath; $bkg)
				
			End if 
			
			PICTURE PROPERTIES:C457($media; $width; $height)
			CREATE THUMBNAIL:C679($bkg; $bkg; $width; $height; Scaled to fit:K6:2)
			$media:=$bkg & $media
			
		End if 
		
		If (OBJECT Get enabled:C1079(*; "move"))
			
			If ($current.source="Form")
				
				OBJECT SET HELP TIP:C1181(*; "move"; "Move picture to ~/Resources/Images")
				
			Else 
				
				OBJECT SET HELP TIP:C1181(*; "move"; "Move picture to Form/Images")
				
			End if 
		End if 
		
		Form:C1466.picture:=$media
		
		//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
End case 