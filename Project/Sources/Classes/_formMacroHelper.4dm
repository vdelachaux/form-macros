// https://developer.4d.com/docs/FormEditor/macros
property macro : cs:C1710._formMacroDeclaration  // Macro declaration object (in the formMacros.json file)
property form : Object  // Form Editor Macro Proxy object containing the form properties
property editor : cs:C1710._formMacroEditor  // A copy of all the elements of the form with their current values
property UI_FORM : Text  // Form name to display
property UI_DATA : Object  // Form data
property RESULT : cs:C1710._formMacroResult  // Form Editor Macro Proxy object returning properties modified by the macro

Class constructor($macro : Object)
	
	This:C1470.macro:=$macro
	
	This:C1470.resourcesFolder:=Folder:C1567(Folder:C1567(fk resources folder:K87:11; *).platformPath; fk platform path:K87:2)  // Un-sandboxed
	
	This:C1470.appResources:=Is macOS:C1572\
		 ? Folder:C1567(Application file:C491; fk platform path:K87:2).folder("Contents/Resources")\
		 : File:C1566(Application file:C491; fk platform path:K87:2).parent.folder("Resources")
	
	// Page number for search
	// >=0 look in editor.form[page number]
	This:C1470.K_PAGE_CURRENT:=-1  // -1 look in editor.currentPage
	This:C1470.K_PAGE_MORE:=-2  // -2 look in editor.currentPage for current page , and editor.form for other
	This:C1470.K_PAGE_ALL:=-3  // -3 look in editor.form
	
	//Method type
	This:C1470.K_METHOD_NO:=0  // No method
	This:C1470.K_METHOD_FILE:=1  // Method name match object name, file is the ObjectMethods folder
	This:C1470.K_METHOD_PROJECT:=2  // Project method
	This:C1470.K_METHOD_CUSTOM:=3  // Custom
	
	// === === === === === === === === === === === === === === === === === === === === === === ===
Function onInvoke($editor : Object)
	
	This:C1470.form:=$editor
	This:C1470.editor:=$editor.editor
	
	var $key : Text
	For each ($key; This:C1470.editor)
		
		This:C1470["_"+$key]:=This:C1470.editor[$key]
		
	End for each 
	
	// MARK:Display UI
	If (This:C1470.UI_FORM#Null:C1517)
		
		This:C1470.UI_DATA:=New object:C1471(\
			"result"; False:C215; \
			"helper"; This:C1470; \
			"winRef"; This:C1470.OpenWindow(This:C1470.UI_FORM; Movable form dialog box:K39:8))
		
		DIALOG:C40(This:C1470.UI_FORM; This:C1470.UI_DATA)
		CLOSE WINDOW:C154(This:C1470.UI_DATA.winRef)
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === ===
Function onError($editor : cs:C1710._formMacroEditor; $result : cs:C1710._formMacroResult; $errors : Collection)
	
	ALERT:C41($errors.extract("message").join("\n"))
	
	//=== === === === === === === === === === === === === === === === === === === === === === ===
Function OpenWindow($name : Text) : Integer
	
	// TODO: Center to the current form window
	return Open form window:C675($name; Movable form dialog box:K39:8; Horizontally centered:K39:1; Vertically centered:K39:4; *)
	
	// <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==>
Function get file() : 4D:C1709.File
	
	return File:C1566(This:C1470._file.platformPath; fk platform path:K87:2; *)  // Unsandboxing
	
	// <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==>
Function get name : Text
	
	return This:C1470.editor.name
	
	// <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==>
Function get pageCount : Integer
	
	return This:C1470.editor.form.pages.length
	
	// <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==>
Function get objectMethodFolder : 4D:C1709.Folder
	
	return This:C1470.editor.file.parent.folder("ObjectMethods")
	
	// <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==>
Function get folder : 4D:C1709.Folder
	
	return This:C1470.editor.file.parent
	
	// <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==>
Function get default : Object
	
	This:C1470.DefaultValues:=This:C1470.DefaultValues || This:C1470._defaultValues
	return This:C1470.DefaultValues
	
	// <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==>
Function get css() : Collection
	
	If (This:C1470.editor.formProperties.css=Null:C1517)
		
		return []
		
	End if 
	
	If (Value type:C1509(This:C1470.editor.formProperties.css)=Is text:K8:3)
		
		return [{path: This:C1470.editor.formProperties.css}]
		
	Else 
		
		return This:C1470.editor.formProperties.css.copy()
		
	End if 
	
	// <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==>
Function set css($css : Collection)
	
	Case of 
			//______________________________________________________
		: ($css.length=0)
			
			OB REMOVE:C1226(This:C1470.editor.formProperties; "css")
			
			//______________________________________________________
		: ($css.length=1)
			
			This:C1470.editor.formProperties.css:=$css[0].path
			
			//______________________________________________________
		Else 
			
			This:C1470.editor.formProperties.css:=$css.copy()
			
			//______________________________________________________
	End case 
	
	// Mark:-Selection
	// <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==>
Function get selection : Collection
	
	return This:C1470._currentSelection || []
	
	// <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==>
Function set selection($sel : Collection)
	
	// <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==>
Function get selectedObjectCount : Integer
	
	return This:C1470._currentSelection.length
	
	// === === === === === === === === === === === === === === === === === === === === === === ===
Function Select($name : Text)
	
	If (Length:C16($name)=0)
		
		return 
		
	End if 
	
	If (Not:C34(This:C1470.isSelected($name)))
		
		This:C1470.selection.push($name)
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === ===
Function Deselect($name : Text)
	
	If (Length:C16($name)=0)
		
		return 
		
	End if 
	
	If (This:C1470.isSelected($name))
		
		This:C1470.selection.remove(This:C1470.selection.indexOf($name))
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === ===
Function SelectAll() : Boolean
	
	var $name : Text
	var $sel : Collection
	
	$sel:=[]
	
	For each ($name; This:C1470.editor.currentPage.objects)
		
		$sel.push($name)
		
	End for each 
	
	This:C1470.selection:=$sel
	
	// === === === === === === === === === === === === === === === === === === === === === === ===
Function DeselectAll()
	
	This:C1470.selection:=[]
	
	// Mark:-Path management
	// === === === === === === === === === === === === === === === === === === === === === === ===
	/// Returns True if path posix belongs to package
Function isInsidePackage($path : Text) : Boolean
	
	return This:C1470.isSubPathOf($path; "/PACKAGE/")
	
	// === === === === === === === === === === === === === === === === === === === === === === ===
	/// Returns True if path posix belongs to the resources folder
Function isInsideResources($path : Text) : Boolean
	
	return This:C1470.isSubPathOf($path; "/RESOURCES/")
	
	// === === === === === === === === === === === === === === === === === === === === === === ===
	/// Returns a posix path according to the file location
/*
Parameters         Type          Description
---------          ---------     ---------
path               Text          Posix path to test
formPath           Text          The .4dform posix full path
*/
Function ValidatePath($path : Text; $formPath : Text) : Text
	
	var $posixPath; $packagePath : Text
	
	If (This:C1470.isSubPathOf($path; $formPath; ->$posixPath))\
		 | (This:C1470.isSubPathOf($path; "/LOGS/"; ->$posixPath))
		
		// Relative to form or Logs folder of the database
		return $posixPath
		
	Else 
		
		If (This:C1470.isSubPathOf($path; "/PACKAGE/"; ->$posixPath))
			
			$packagePath:=$posixPath
			$posixPath:=""
			
			Case of 
					
					//======================================
				: (This:C1470.isSubPathOf($path; "/RESOURCES/"; ->$posixPath))
					
					//======================================
				: (This:C1470.isSubPathOf($path; "/SOURCES/"; ->$posixPath))
					
					//======================================
				: (This:C1470.isSubPathOf($path; "/PROJECT/"; ->$posixPath))
					
					//======================================
			End case 
			
			return $posixPath="" ? $packagePath : $posixPath
			
		End if 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === ===
	/// Returns True if the posix path is in the given parent path
/*
Parameters         Type          Description
---------          ---------     ---------
path               Text          Posix path to test
parentPath         Text          The posix path whose path must be a child
pathPtr            Pointer       The result posix path
*/
Function isSubPathOf($path : Text; $parentPath : Text; $pathCollector : Pointer) : Boolean
	
	var $destFolder : Text
	var $success : Boolean
	
	This:C1470._setCollector($pathCollector; "")
	
	If ($parentPath="/PACKAGE/")\
		 || ($parentPath="/RESOURCES/")\
		 || ($parentPath="/SOURCES/")\
		 || ($parentPath="/PROJECT/")\
		 || ($parentPath="/LOGS/")
		
		$destFolder:=Folder:C1567(Folder:C1567($parentPath; fk posix path:K87:1; *).platformPath; fk platform path:K87:2).path
		
	Else 
		
		$destFolder:=$parentPath
		
	End if 
	
	If (Length:C16($path)>Length:C16($destFolder))
		
		$success:=(Substring:C12($path; 1; Length:C16($destFolder))=$destFolder)
		
		If ($success)
			
			This:C1470._setCollector($pathCollector; $parentPath+Substring:C12($path; Length:C16($destFolder)+1; Length:C16($path)-Length:C16($destFolder)))
			
		End if 
	End if 
	
	return $success
	
	// Mark:-Widgets
	// === === === === === === === === === === === === === === === === === === === === === === ===
	/// Returns a collection of widget names
/**
Optional pageNumber
>=0 look in editor.form[page number]
-1 look in editor.currentPage
-2 look in editor.currentPage for current page , and editor.form for other
-3 look in editor.form DEFAULT
**/
Function GetObjectNames($pageNumber : Integer) : Collection
	
	var $indx : Integer
	var $page : Object
	var $c; $pages : Collection
	
	$pageNumber:=Count parameters:C259<1 ? This:C1470.K_PAGE_ALL : $pageNumber
	$pages:=This:C1470.editor.form.pages
	$c:=[]
	
	Case of 
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		: ($pageNumber=This:C1470.K_PAGE_CURRENT)
			
			$c:=$c.concat(This:C1470.GetObjectNamesInPage(This:C1470.editor.currentPage))
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		: ($pages=Null:C1517)
			
			// <NOTHING MORE TO DO>
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		: ($pageNumber=This:C1470.K_PAGE_ALL)
			
			For each ($page; $pages)  //While ($0=Null)
				
				$c:=$c.concat(This:C1470.GetObjectNamesInPage($page))
				
			End for each 
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		: ($pageNumber=This:C1470.K_PAGE_MORE)
			
			For each ($page; $pages)
				
				If ($indx=This:C1470.currentPageNumber)
					
					$page:=This:C1470.editor.currentPage
					
				End if 
				
				If ($page#Null:C1517)
					
					$c:=$c.concat(This:C1470.GetObjectNamesInPage($page))
					
				End if 
				
				$indx+=1
				
			End for each 
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		: ($pageNumber<0)
			
			ASSERT:C1129(False:C215; "Unmanaged negative page number : "+String:C10($pageNumber))
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		Else 
			
			If ($pageNumber<$pages.length)
				
				$c:=$c.concat(This:C1470.GetObjectNamesInPage($pages))
				
			End if 
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	End case 
	
	return $c
	
	// === === === === === === === === === === === === === === === === === === === === === === ===
	/// Returns a collection of widget names in a given page
/**
Parameters           Type          Mandatory     Description
---------            ---------     ---------     ---------
page                 Object        Yes           Page object
**/
Function GetObjectNamesInPage($page : Object) : Collection
	
	var $name : Text
	var $column; $o : Object
	var $c : Collection
	
	If ($page=Null:C1517)\
		 | ($page.objects=Null:C1517)
		
		ASSERT:C1129(Structure file:C489#Structure file:C489(*))  // Trace in dev mode
		return   // Null
		
	End if 
	
	$c:=[]
	
	For each ($name; $page.objects)
		
		$o:=$page.objects[$name]
		
		$c.push($name)
		
		If ($o.type="listbox")
			
			// Not a good practice, but
			// Sub object can have empty or not defined name.
			// In this case, unique name will be generated when form will be loaded
			
			For each ($column; $o.columns)
				
				If ($column.name#"")
					
					$c.push($column.name)
					
				End if 
				
				If ($column.header#Null:C1517)\
					 && ($column.header.name#"")
					
					$c.push($column.header.name)
					
				End if 
				
				If ($column.footer#Null:C1517)\
					 && ($column.footer.name#"")
					
					$c.push($column.footer.name)
					
				End if 
			End for each 
		End if 
	End for each 
	
	return $c
	
	// === === === === === === === === === === === === === === === === === === === === === === ===
	/// Returns a widget object from this name
/**
Optional pageNumber
>=0 look in editor.form[page number]  The returned object is readonly
-1 look in editor.currentPage  The returned object is readonly
-2 look in editor.currentPage for current page , and editor.form for other.returned object can be r/o or r/w
-3 look in editor.form   The returned object is readonly DEFAULT
**/
Function GetObject($name : Text; $pageNumber : Integer; $typeCollector : Pointer) : Object
	
	var $indx : Integer
	var $o; $page : Object
	var $pages : Collection
	
	This:C1470._setCollector($typeCollector; "")
	
	If (Length:C16($name)=0)
		
		return   // Null
		
	End if 
	
	$pageNumber:=Count parameters:C259<2 ? This:C1470.K_PAGE_ALL : $pageNumber
	$pages:=This:C1470.editor.form.pages
	
	Case of 
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		: ($pageNumber=This:C1470.K_PAGE_CURRENT)
			
			$o:=This:C1470.GetObjectInPage(This:C1470.editor.currentPage; $name; $typeCollector)
			
			If ($o#Null:C1517)
				
				$o.pageNumber:=This:C1470.currentPageNumber
				
			End if 
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		: ($pages=Null:C1517)
			
			// <NOTHING MORE TO DO>
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		: ($pageNumber=This:C1470.K_PAGE_MORE)
			
			For each ($page; $pages)
				
				If ($indx=This:C1470.currentPageNumber)
					
					$page:=This:C1470.editor.currentPage
					
				End if 
				
				If ($page#Null:C1517)
					
					$o:=This:C1470.GetObjectInPage($page; $name; $typeCollector)
					
				End if 
				
				If ($o#Null:C1517)
					
					$o.pageNumber:=$indx
					break
					
				Else 
					
					$indx+=1
					
				End if 
			End for each 
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		: ($pageNumber=This:C1470.K_PAGE_ALL)
			
			For each ($page; $pages)
				
				$o:=This:C1470.GetObjectInPage($page; $name; $typeCollector)
				
				If ($o#Null:C1517)
					
					$o.pageNumber:=$indx
					break
					
				Else 
					
					$indx+=1
					
				End if 
			End for each 
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		: ($pageNumber<0)
			
			ASSERT:C1129(False:C215; "Unmanaged negative page number : "+String:C10($pageNumber))
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		Else 
			
			If ($pageNumber<$pages.length)
				
				$o:=This:C1470.GetObjectInPage($pages[$pageNumber]; $name; $typeCollector)
				
				If ($o#Null:C1517)
					
					$o.pageNumber:=$pageNumber
					
				End if 
			End if 
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	End case 
	
	return $o
	
	// === === === === === === === === === === === === === === === === === === === === === === ===
	/// Returns default values object of a widget from this type
/**
Parameters           Type          Mandatory     Description
---------            ---------     ---------     ---------
type                 Text          No            Widget type. All default values if ommitted
**/
Function GetObjectDefault($type : Text) : Object
	
	This:C1470.DefaultValues:=This:C1470.DefaultValues || This:C1470._defaultValues
	
	If (This:C1470.DefaultValues=Null:C1517)
		
		return 
		
	End if 
	
	return $type ? This:C1470.DefaultValues[$type] : This:C1470.DefaultValues
	
	// === === === === === === === === === === === === === === === === === === === === === === ===
	/// Returns True if the widget of this name exists
/**
Parameters           Type          Mandatory     Description
---------            ---------     ---------     ---------
name                 Text          Yes           Name of the widget to search
inCurrentPage        Boolean       No            Limit to current page
pageCollector        Pointer       No            Get the page number where the widget was found
**/
Function Exists($name : Text; $inCurrentPage : Boolean; $pageCollector : Pointer) : Boolean
	
	var $indx : Integer
	var $object; $page : Object
	
	If ($name="")\
		 | (This:C1470.editor.form.pages=Null:C1517)
		
		return 
		
	End if 
	
	For each ($page; This:C1470.editor.form.pages)
		
		If (($inCurrentPage=True:C214)\
			 & ($indx=This:C1470.currentPageNumber))
			
			$page:=This:C1470.editor.currentPage
			$indx:=This:C1470.K_PAGE_CURRENT
			
		End if 
		
		If ($page#Null:C1517)
			
			$object:=This:C1470.GetObjectInPage($page; $name; $pageCollector)
			
		End if 
		
		If ($object#Null:C1517)
			
			This:C1470._setCollector($pageCollector; $indx)
			return True:C214
			
		End if 
		
		$indx+=1
		
	End for each 
	
	This:C1470._setCollector($pageCollector; $indx)
	
	// === === === === === === === === === === === === === === === === === === === === === === ===
	/// Returns True if the widget of this name is selected
/**
Parameters           Type          Mandatory     Description
---------            ---------     ---------     ---------
name                 Text          Yes           Name of the widget to test
**/
Function isSelected($name : Text) : Boolean
	
	If (Length:C16($name)=0)
		
		return 
		
	End if 
	
	return This:C1470.selection.indexOf($name)#-1
	
	// === === === === === === === === === === === === === === === === === === === === === === ===
	/// Returns a widget object in a page from this name
Function GetObjectInPage($page : Object; $name : Text; $typeCollector : Pointer) : Object
	
	var $key : Text
	var $found : Boolean
	var $column; $o; $objects : Object
	
	If ($page=Null:C1517)\
		 | ($page.objects=Null:C1517)\
		 | (Length:C16($name)=0)
		
		ASSERT:C1129(Structure file:C489#Structure file:C489(*))  // Trace in dev mode
		return   // Null
		
	End if 
	
	$objects:=$page.objects
	
	For each ($key; $objects)
		
		$o:=$objects[$key]
		
		If ($key=$name)
			
			This:C1470._setCollector($typeCollector; $o.type)
			return $o
			
		Else 
			
			If (This:C1470.Strcmp($o.type; "listbox"))
				
				For each ($column; $o.columns)
					
					If ($column.name=$name)
						
						This:C1470._setCollector($typeCollector; "columns")
						return $column
						
					Else 
						
						If ($column.header.name=$name)
							
							This:C1470._setCollector($typeCollector; "header")
							return $column.header
							
						Else 
							
							If ($column.footer.name=$name)
								
								This:C1470._setCollector($typeCollector; "footer")
								return $column.footer
								
							End if 
						End if 
					End if 
				End for each 
			End if 
		End if 
	End for each 
	
	// === === === === === === === === === === === === === === === === === === === === === === ===
Function GetObjectX($widget : Object) : Integer
	
	return $widget.left
	
	// === === === === === === === === === === === === === === === === === === === === === === ===
Function SetObjectX($widget : Object; $x : Integer)
	
	ASSERT:C1129(($widget.right#Null:C1517) | ($widget.width#Null:C1517))
	
	If ($widget.right#Null:C1517)
		
		$widget.right:=$x+($widget.right-$widget.left)
		$widget.left:=$x
		
	End if 
	
	If ($widget.width#Null:C1517)
		
		$widget.left:=$x
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === ===
Function GetObjectY($widget : Object) : Integer
	
	return $widget.top
	
	// === === === === === === === === === === === === === === === === === === === === === === ===
Function SetObjectY($widget : Object; $y : Integer)
	
	ASSERT:C1129(($widget.bottom#Null:C1517) | ($widget.height#Null:C1517))
	
	If ($widget.bottom#Null:C1517)
		
		$widget.bottom:=$y+($widget.bottom-$widget.top)
		$widget.top:=$y
		
	End if 
	
	If ($widget.height#Null:C1517)
		
		$widget.top:=$y
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === ===
Function GetObjectRight($widget : Object) : Integer
	
	return $widget.left+This:C1470.ObjectGetWidth($widget)
	
	// === === === === === === === === === === === === === === === === === === === === === === ===
Function GetObjectBottom($widget : Object) : Integer
	
	return $widget.top+This:C1470.GetObjectHeight($widget)
	
	// === === === === === === === === === === === === === === === === === === === === === === ===
Function GetObjectWidth($widget : Object) : Integer
	
	return $widget.right ? $widget.right-$widget.left : $widget.width
	
	// === === === === === === === === === === === === === === === === === === === === === === ===
Function SetObjectWidth($widget : Object; $width : Integer)
	
	If ($widget.right#Null:C1517)\
		 || ($widget.width=Null:C1517)
		
		$widget.right:=$widget.left+$width
		
	End if 
	
	If ($widget.width#Null:C1517)
		
		$widget.width:=$width
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === ===
Function GetObjectHeight($widget : Object) : Integer
	
	return $widget.bottom ? $widget.right-$widget.top : $widget.height
	
	// === === === === === === === === === === === === === === === === === === === === === === ===
Function SetObjectHeight($widget : Object; $height : Integer)
	
	If ($widget.bottom#Null:C1517)\
		 || ($widget.height=Null:C1517)
		
		$widget.bottom:=$widget.top+$height
		
	End if 
	
	If ($widget.height#Null:C1517)
		
		$widget.height:=$height
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === ===
Function SetObjectPosition($widget : Object; $x : Integer; $y : Integer)
	
	This:C1470.SetObjectX($widget; $x)
	This:C1470.SetObjectY($widget; $y)
	
	// === === === === === === === === === === === === === === === === === === === === === === ===
	/// Returns object method status
/**
Parameters           Type          Mandatory     Description
---------            ---------     ---------     ---------
widget               Object        Yes           The widegt object
name                 Text          Yes           Widget name
	
Status code
--------- 
0 = No method
1 = Method name match object name, file is the ObjectMethods folder
2 = Project method
3 = Custom
**/
Function GetObjectMethodInfo($widget : Object; $name : Text) : Integer
	
	var $method; $pathname : Text
	
	If ($widget=Null:C1517)
		
		ASSERT:C1129(Structure file:C489#Structure file:C489(*))  // Trace in dev mode
		return 
		
	End if 
	
	If ($widget.method=Null:C1517)
		
		return This:C1470.K_METHOD_NO
		
	End if 
	
	$method:=$widget.method
	
	If (Length:C16($method)=0)\
		 || (Length:C16($method)>5)\
		 || ($method#"@.4dm")
		
		return This:C1470.K_METHOD_PROJECT
		
	End if 
	
	If ($method#"ObjectMethods/@")
		
		return This:C1470.K_METHOD_CUSTOM
		
	End if 
	
	
	$method:=Substring:C12($method; 0; Length:C16($method)-4)
	$pathname:=This:C1470.EncodeReservedFileCharacters($name)
	
	If (This:C1470.Strcmp($method; $pathname))
		
		return This:C1470.K_METHOD_FILE
		
	Else 
		
		return This:C1470.K_METHOD_CUSTOM
		
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === ===
Function MakeUniqueObjectName($wanted : Text; $exclusions : Collection; $withFreeMethodFile : Boolean) : Text
	
	var $methodFolderPath; $name; $tmpName; $tmpScriptName : Text
	var $found : Boolean
	var $counter : Integer
	var $names : Collection
	
	// ⚠️ Important
	// This code don't use strict string compare (This.Strcmp)
	// Because 4D object name is not case sensitive
	
	If ($wanted="")
		
		return 
		
	End if 
	
	$names:=This:C1470.GetObjectNames(This:C1470.K_PAGE_MORE)
	
	If ($names.length=0)
		
		return $wanted
		
	End if 
	
	$tmpName:=$wanted
	
	If ($withFreeMethodFile)
		
		$methodFolderPath:=This:C1470.objectMethodFolder.platformPath
		
	End if 
	
	Repeat 
		
		$found:=False:C215
		
		For each ($name; $names)
			
			If ($tmpName=$name)
				
				$found:=True:C214
				break
				
			End if 
		End for each 
		
		// Groups
		If (Not:C34($found))\
			 && (This:C1470.groupNames.length>0)
			
			For each ($name; This:C1470.groupNames)
				
				If ($tmpName=$name)
					
					$found:=True:C214
					break
					
				End if 
			End for each 
		End if 
		
		// Look in exclusion list
		If (Not:C34($found))\
			 && ($exclusions#Null:C1517)
			
			For each ($name; $exclusions)
				
				If ($tmpName=$name)
					
					$found:=True:C214
					break
					
				End if 
			End for each 
		End if 
		
		// Test method file name
		If (Not:C34($found)\
			 && $withFreeMethodFile)
			
			$tmpScriptName:=This:C1470.EncodeReservedFileCharacters($tmpName)
			$found:=(Test path name:C476($methodFolderPath+$tmpScriptName+".4dm")=Is a document:K24:1)
			
		End if 
		
		If ($found)
			
			$counter+=1
			$tmpName:=$wanted+String:C10($counter)
			
		Else 
			
			return $tmpName
			
		End if 
	Until (False:C215)
	
	// === === === === === === === === === === === === === === === === === === === === === === ===
Function InsertFormObjectAfter($newName : Text; $newObject : Object; $afterName : Text) : Boolean
	
	var $property : Text
	var $newObjects; $objects : Object
	
	$objects:=This:C1470.editor.currentPage.objects
	
	If ($newName="")\
		 | ($objects[$newName]#Null:C1517)
		
		return 
		
	End if 
	
	If ($afterName="")
		
		$objects[$newName]:=$newObject
		
	Else 
		
		$newObjects:={}
		
		For each ($property; $objects)
			
			$newObjects[$property]:=$objects[$property]
			
			If (This:C1470.Strcmp($property; $afterName))
				
				$newObjects[$newName]:=$newObject
				
			End if 
		End for each 
		
		This:C1470.editor.currentPage.objects:=$newObjects
		
	End if 
	
	return True:C214
	
	// === === === === === === === === === === === === === === === === === === === === === === ===
Function InsertFormObjectBefore($newName : Text; $newObject : Object; $beforeName : Text) : Boolean
	
	var $property : Text
	var $newObjects; $objects : Object
	
	$objects:=This:C1470.editor.currentPage.objects
	
	If ($newName="")\
		 | ($objects[$newName]#Null:C1517)
		
		return 
		
	End if 
	
	$newObjects:={}
	
	If ($beforeName="")
		
		$newObjects[$newName]:=$newObject
		
	Else 
		
		For each ($property; $objects)
			
			If (This:C1470.Strcmp($property; $beforeName))
				
				$newObjects[$newName]:=$newObject
				
			End if 
			
			$newObjects[$property]:=$objects[$property]
			
		End for each 
		
		This:C1470.editor.currentPage.objects:=$newObjects
		
	End if 
	
	return True:C214
	
	// === === === === === === === === === === === === === === === === === === === === === === ===
Function RenameObject($old : Text; $new : Text) : Boolean
	
	var $property : Text
	var $indx : Integer
	var $newObjects; $objects : Object
	
	If (This:C1470.Exists($old; True:C214))
		
		If (Not:C34(This:C1470.Exists($new; True:C214)))
			
			$objects:=This:C1470.editor.currentPage.objects
			
			$newObjects:={}
			
			For each ($property; $objects)
				
				If ($property=$old)
					
					$newObjects[$new]:=$objects[$property]
					
				Else 
					
					$newObjects[$property]:=$objects[$property]
					
				End if 
			End for each 
			
			This:C1470.editor.currentPage.objects:=$newObjects
			
			If (This:C1470.isSelected($old))
				
				This:C1470.Deselect($old)
				This:C1470.Select($new)
				
			End if 
			
			$indx:=This:C1470.FindInEntryOrder($old)
			
			If ($indx#-1)
				
				This:C1470.entryOrder[$indx]:=$new
				
			End if 
			
			return True:C214
			
		End if 
	End if 
	
	// Mark:-Entry Order
	// <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==>
Function get entryOrder : Collection
	
	//TODO:Return an empty collection if null?
	return This:C1470.editor.currentPage.entryOrder
	
	// <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==>
Function set entryOrder($entryOrder : Collection)
	
	//TODO:Remove property if null?
	This:C1470.editor.currentPage.entryOrder:=$entryOrder
	
	// === === === === === === === === === === === === === === === === === === === === === === ===
Function InsertInEntryOrderAfter($name : Text; $after : Text) : Boolean
	
	var $indx : Integer
	var $entryOrder : Collection
	
	If ($name="")
		
		return 
		
	End if 
	
	$entryOrder:=This:C1470.editor.currentPage.entryOrder | []
	
	If ($entryOrder.indexOf($name)=-1)
		
		$indx:=$after ? $entryOrder.indexOf($after) : $entryOrder.length
		
		If ($indx>=0)
			
			$entryOrder.insert($indx+1; $name)
			return True:C214
			
		End if 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === ===
Function InsertInEntryOrderBefore($name : Text; $after : Text) : Boolean
	
	var $indx : Integer
	var $entryOrder : Collection
	
	If ($name="")
		
		return 
		
	End if 
	
	$entryOrder:=This:C1470.editor.currentPage.entryOrder | []
	
	If ($entryOrder.indexOf($name)=-1)
		
		$indx:=$after ? $entryOrder.indexOf($after) : 0
		
		If ($indx>=0)
			
			$entryOrder.insert($indx; $name)
			return True:C214
			
		End if 
	End if 
	
	// === === === === === === === === === === === === === === === === === === === === === === ===
Function FindInEntryOrder($name : Text) : Integer
	
	return This:C1470.editor.currentPage.entryOrder#Null:C1517\
		 ? This:C1470.editor.currentPage.entryOrder.indexOf($name)\
		 : -1
	
	// === === === === === === === === === === === === === === === === === === === === === === ===
Function ClearEntryOrder($reset : Boolean)
	
	If ($reset)
		
		OB REMOVE:C1226(This:C1470.editor.currentPage; "entryOrder")
		
	Else 
		
		If (This:C1470.editor.currentPage.entryOrder#Null:C1517)
			
			This:C1470.editor.currentPage.entryOrder.clear()
			
		End if 
	End if 
	
	// Mark:-Groups
	// <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==> <==>
Function get groupNames() : Collection
	
	var $name : Text
	var $groups : Object
	var $result : Collection
	
	$result:=[]
	
	If (This:C1470.editor.editor#Null:C1517)
		
		$groups:=This:C1470.editor.form.editor.groups
		
	Else 
		
		If (This:C1470.editor.form.editor#Null:C1517)
			
			$groups:=This:C1470.editor.form.editor.groups
			
		End if 
	End if 
	
	If ($groups#Null:C1517)
		
		// Map to collection
		For each ($name; $groups)
			
			$result.push($name)
			
		End for each 
	End if 
	
	return $result
	
	// MARK:-Tools
	// === === === === === === === === === === === === === === === === === === === === === === ===
Function EncodeReservedFileCharacters($in : Text) : Text
	
	var $hexa; $out; $reserved : Text
	var $code; $i; $reservedLength : Integer
	
	$reserved:="1111111111"*3
	$reserved+="1100100100"
	$reserved+="0010000100"
	$reserved+="0000000010"
	$reserved+="1011000000"
	$reserved+=("0000000000"*2)
	$reserved+="0010000000"
	$reserved+=("0000000000"*2)
	$reserved+="000010000"
	
	$hexa:="0123456789ABCDEF"
	
	$reservedLength:=Length:C16($reserved)
	
	For ($i; 1; Length:C16($in); 1)
		
		$code:=Character code:C91($in[[$i]])
		
		If ($code<$reservedLength)\
			 & ($reserved[[$code+1]]#"0")
			
			$out+="%"
			$out+=$hexa[[($code\16)+1]]
			$out+=$hexa[[($code%16)+1]]
			
		Else 
			
			$out+=Char:C90($code)
			
		End if 
	End for 
	
	return $out
	
	// === === === === === === === === === === === === === === === === === === === === === === ===
Function DecodeReservedFileCharacters($in : Text) : Text
	
	var $out : Text
	var $code; $i; $j; $len; $v : Integer
	var $o : Object
	
	$o:={\
		zero: Character code:C91("0"); \
		nine: Character code:C91("9"); \
		A: Character code:C91("A"); \
		a: Character code:C91("a"); \
		F: Character code:C91("F"); \
		f: Character code:C91("f")\
		}
	
	$len:=Length:C16($in)
	
	For ($i; 1; $len; 1)
		
		If ($in[[$i]]="%")
			
			If (($i+2)<=$len)
				
				$v:=0
				
				For ($j; 1; 2; 1)
					
					$code:=Character code:C91($in[[$i+$j]])
					
					Case of 
							
							//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
						: (($code>=$o.zero)\
							 && ($code<$o.nine))
							
							$v*=16
							$v+=($code-$o.zero)
							
							//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
						: (($code>=$o.A)\
							 && ($code<$o.F))
							
							$v*=16
							$v+=($code-$o.A)+10
							
							//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
						: (($code>=$o.a)\
							 && ($code<$o.f))
							
							$v*=16
							$v+=($code-$o.a)+10
							
							//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
					End case 
				End for 
				
				$out:=$out+Char:C90($v)
				$i+=2
				
			Else 
				
				$out:=$out+$in[[$i]]
				
			End if 
			
		Else 
			
			$out:=$out+$in[[$i]]
			
		End if 
	End for 
	
	return $out
	
	// === === === === === === === === === === === === === === === === === === === === === === ===
	/// Diacritical comparison
Function Strcmp($src : Text; $tgt : Text) : Boolean
	
	If (Length:C16($src)=Length:C16($tgt))
		
		return Position:C15($src; $tgt; *)=1
		
	End if 
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
	/// Returns a page object from its number
Function _getPage($pageNumber : Integer) : Object
	
	If (($pageNumber>=0)\
		 & ($pageNumber<=This:C1470.pageCount))
		
		return This:C1470.editor.form.pages[$pageNumber]
		
	Else 
		
		If ($pageNumber=This:C1470.K_PAGE_CURRENT)
			
			return This:C1470.editor.currentPage
			
		End if 
	End if 
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
	// Returs the default values object
Function get _defaultValues : Object
	
	var $file : 4D:C1709.File
	$file:=This:C1470.appResources.file("DefaultJsonForm.json")
	return $file.exists ? JSON Parse:C1218($file.getText()) : {}
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _buildObjectGroups($pageNumber : Integer) : Object
	
	var $name; $objName : Text
	var $foundInPage : Integer
	var $groups; $page; $pageGroup : Object
	var $objects : Collection
	
	$page:=This:C1470._getPage($pageNumber)
	
	If ($page=Null:C1517)\
		 | (This:C1470.editor.form.editor=Null:C1517)\
		 | (This:C1470.editor.form.editor.groups=Null:C1517)
		
		return 
		
	End if 
	
	$pageGroup:={}
	$groups:=This:C1470.editor.form.editor.groups
	
	For each ($name; $groups)
		
		$objects:=$groups[$name]
		
		If ($objects.length>0)
			
			For each ($objName; $objects)
				
				If ($objName="")
					
					continue
					
				End if 
				
				If (This:C1470.Exists($objName; True:C214; ->$foundInPage))
					
					If ($foundInPage=$pageNumber)
						
						$pageGroup[$name]:=$objects.copy()
						
					End if 
					
					break
					
				End if 
			End for each 
		End if 
	End for each 
	
	If (Not:C34(OB Is empty:C1297($pageGroup)))
		
		return $pageGroup
		
	End if 
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _setCollector($ptr : Pointer; $value)
	
	If (Is nil pointer:C315($ptr))
		
		return 
		
	End if 
	
	$ptr->:=$value
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _meta($test; $target : Text) : Object
	
	var $style : Object
	
	$style:={\
		stroke: "Automatic"; \
		cell: New object:C1471($target; {})\
		}
	
	Case of 
			
			//______________________________________________________
		: (Value type:C1509($test)=Is object:K8:27)
			
			Case of 
					
					//…………………………………………………………………………………………………………………
				: ($target="path")  // Test if the file exists
					
					If (Not:C34(File:C1566($test[$target]).exists))
						
						$style.cell[$target].stroke:="red"
						
					End if 
					
					//…………………………………………………………………………………………………………………
				: ($target="media")  // Test if the media exists
					
					If (Not:C34($test[$target].exists))
						
						$style.cell[$target].stroke:="red"
						
					End if 
					//…………………………………………………………………………………………………………………
			End case 
			
			//______________________________________________________
	End case 
	
	return $style