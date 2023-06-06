var $e : Object
$e:=FORM Event:C1606

var $helper : cs:C1710._formMedias
$helper:=Form:C1466.helper

Case of 
		
		//______________________________________________________
	: ($e.code=On Load:K2:1)
		
		SET WINDOW TITLE:C213("Medias : "+$helper.editor.name)
		
		//______________________________________________________
	: ($e.code=On Activate:K2:9)
		
		Form:C1466.list:=$helper.LoadMedias()
		
		var $indx : Integer
		
		If (Form:C1466.list.length>0)
			
			Form:C1466.list:=Form:C1466.list.orderBy("pageNumber asc, name asc")
			
			If ($helper.selection.length>0)
				
				$indx:=Form:C1466.list.indices("name = :1 OR header.name = :1"; $helper.selection[0]).shift()  // First one
				
			End if 
			
			LISTBOX SELECT ROW:C912(*; "list"; $indx+1; lk replace selection:K53:1)
			Form:C1466.current:=Form:C1466.list[$indx]
			SET TIMER:C645(-1)
			
		End if 
		
		//______________________________________________________
	: ($e.code=On Selection Change:K2:29)
		
		SET TIMER:C645(-1)
		
		//______________________________________________________
	: ($e.code=On Timer:K2:25)
		
		SET TIMER:C645(0)
		
		var $file : 4D:C1709.File
		$file:=Form:C1466.current ? Form:C1466.current.media : Null:C1517
		
		var $media : Picture
		
		If ($file#Null:C1517)
			
			OBJECT SET VISIBLE:C603(*; "view"; True:C214)
			
			If ($file.exists)
				
				If (FORM Get color scheme:C1761="dark") && (Form:C1466.current.dark.exists)
					
					READ PICTURE FILE:C678(Form:C1466.current.dark.platformPath; $media)
					
				Else 
					
					READ PICTURE FILE:C678($file.platformPath; $media)
					
				End if 
				
				OBJECT SET ENABLED:C1123(*; "view"; True:C214)
				OBJECT SET VISIBLE:C603(*; "alert"; False:C215)
				OBJECT SET RGB COLORS:C628(*; "name"; -1)
				
				
			Else 
				
				OBJECT SET ENABLED:C1123(*; "view"; False:C215)
				OBJECT SET VISIBLE:C603(*; "alert"; True:C214)
				OBJECT SET RGB COLORS:C628(*; "name"; "red")
				
			End if 
			
			OBJECT SET VISIBLE:C603(*; "delete"; True:C214)
			OBJECT SET VISIBLE:C603(*; "move"; True:C214)
			
			ASSERT:C1129(Not:C34(Shift down:C543))
			OBJECT SET ENABLED:C1123(*; "delete"; (Form:C1466.current.page<0) | (Form:C1466.current.pageNumber=$helper.editor.currentPageNumber))
			
		Else 
			
			OBJECT SET ENABLED:C1123(*; "view"; False:C215)
			OBJECT SET ENABLED:C1123(*; "delete"; False:C215)
			OBJECT SET ENABLED:C1123(*; "move"; False:C215)
			
			OBJECT SET VISIBLE:C603(*; "alert"; False:C215)
			
		End if 
		
		Form:C1466.picture:=$media
		
		//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
End case 