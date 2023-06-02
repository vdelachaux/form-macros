property editor; form; macro : Object

Class constructor($macro : Object)
/*
	
Parameters     Type          Description
---------      ---------     ----------
$macro         Object        Macro declaration object (in the formMacros.json file)
	
*/
	
	This:C1470.macro:=$macro
	
	This:C1470.resourcesFolder:=Folder:C1567(Folder:C1567(fk resources folder:K87:11; *).platformPath; fk platform path:K87:2)  // Un-sandboxed
	
	This:C1470.appResources:=Is macOS:C1572\
		 ? Folder:C1567(Application file:C491; fk platform path:K87:2).folder("Contents/Resources")\
		 : File:C1566(Application file:C491; fk platform path:K87:2).parent.folder("Resources")
	
	This:C1470.FORM:=Null:C1517
	This:C1470.DATA:=Null:C1517
	This:C1470.RESULT:=Null:C1517
	
	// Page number
	// >=0 look in editor.form[page number]
	This:C1470.CURRENT_PAGE:=-1  // -1 look in editor.currentPage
	This:C1470.CURRENT_PAGE_MORE:=-2  // -2 look in editor.currentPage for current page , and editor.form for other
	This:C1470.ALL_PAGES:=-3  // -3 look in editor.form
	
	// === === === === === === === === === === === === === === === === === === === === === === ===
Function onInvoke($editor : Object)
/*
	
Property                           Type          Description
---------                          ---------     ---------
$editor.editor.form                Object        The entire form - All modification in this object are ignored.
$editor.editor.file                File          The .4dform File object
$editor.editor.name                Text          The form name
$editor.editor.table               number        Table number of the form, 0 for project form
$editor.editor.currentPageNumber   number        The number of the current page
$editor.editor.currentPage         Object        The current page, containing all the form widgets and the entry order of the page
$editor.editor.currentSelection    Collection    Collection of names of selected objects
$editor.editor.formProperties      Object        The properties of the current form
$editor.editor.target              Text          Name of the object under the mouse when clicked on a macro
	
*/
	
	This:C1470.form:=$editor
	This:C1470.editor:=$editor.editor
	
	var $key : Text
	For each ($key; This:C1470.editor)
		
		This:C1470["_"+$key]:=This:C1470.editor[$key]
		
	End for each 
	
	// MARK:Display UI
	If (This:C1470.FORM#Null:C1517)
		
		This:C1470.DATA:=New object:C1471(\
			"result"; False:C215; \
			"helper"; This:C1470; \
			"winRef"; This:C1470.OpenWindow(This:C1470.FORM; Movable form dialog box:K39:8))
		
		DIALOG:C40(This:C1470.FORM; This:C1470.DATA)
		CLOSE WINDOW:C154(This:C1470.DATA.winRef)
		
	End if 
	
	//=== === === === === === === === === === === === === === === === === === === === === === ===
Function onError($editor : Object; $result : Object; $errors : Collection)
/* 
	
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
	
	// Mark:-Tools
	// === === === === === === === === === === === === === === === === === === === === === === ===
Function isInsidePackage($path : Text) : Boolean
	
	return This:C1470._isSubOf($path; "/PACKAGE/")
	
	// === === === === === === === === === === === === === === === === === === === === === === ===
Function ValidatePath($path : Text; $formPath : Text) : Text
	
	var $resultPath; $packagePath : Text
	
/*
Returns a posix path according to the file location
	
Parameters         Type          Description
---------          ---------     ---------
$path              Text          Posix path to test
$formPath          Text          The .4dform posix full path
	
*/
	
	If (This:C1470._isSubOf($path; $formPath; ->$resultPath))\
		 | (This:C1470._isSubOf($path; "/LOGS/"; ->$resultPath))
		
		// Relative to form or Logs folder of the database
		return $resultPath
		
	Else 
		
		If (This:C1470._isSubOf($path; "/PACKAGE/"; ->$resultPath))
			
			$packagePath:=$resultPath
			$resultPath:=""
			
			Case of 
					
					//======================================
				: (This:C1470._isSubOf($path; "/RESOURCES/"; ->$resultPath))
					
					//======================================
				: (This:C1470._isSubOf($path; "/SOURCES/"; ->$resultPath))
					
					//======================================
				: (This:C1470._isSubOf($path; "/PROJECT/"; ->$resultPath))
					
					//======================================
			End case 
			
			return $resultPath="" ? $packagePath : $resultPath
			
		End if 
	End if 
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Function _isSubOf($path : Text; $parentPath : Text; $pathPtr : Pointer) : Boolean
	
	var $destFolder : Text
	var $success : Boolean
	
/*
Returns True if the posix path is in the given parent path
	
Parameters         Type          Description
---------          ---------     ---------
$path              Text          Posix path to test
$parentPath        Text          The posix path whose path must be a child
$pathPtr           Pointer       The result posix path
	
*/
	
	If (Count parameters:C259=3)
		
		$pathPtr->:=""
		
	End if 
	
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
		
		If (($success=True:C214)\
			 & (Not:C34(Is nil pointer:C315($pathPtr))))
			
			$pathPtr->:=$parentPath+Substring:C12($path; Length:C16($destFolder)+1; Length:C16($path)-Length:C16($destFolder))
			
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
	
	$pageNumber:=Count parameters:C259<1 ? This:C1470.ALL_PAGES : $pageNumber
	$pages:=This:C1470.editor.form.pages
	$c:=[]
	
	Case of 
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		: ($pageNumber=This:C1470.CURRENT_PAGE)
			
			$c:=$c.concat(This:C1470.GetObjectNamesInPage(This:C1470.editor.currentPage))
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		: ($pages=Null:C1517)
			
			// <NOTHING MORE TO DO>
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		: ($pageNumber=This:C1470.ALL_PAGES)
			
			For each ($page; $pages)  //While ($0=Null)
				
				$c:=$c.concat(This:C1470.GetObjectNamesInPage($page))
				
			End for each 
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		: ($pageNumber=This:C1470.CURRENT_PAGE_MORE)
			
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
	
	$pageNumber:=Count parameters:C259<2 ? This:C1470.ALL_PAGES : $pageNumber
	$pages:=This:C1470.editor.form.pages
	
	Case of 
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		: ($pageNumber=This:C1470.CURRENT_PAGE)
			
			$o:=This:C1470.GetObjectInPage(This:C1470.editor.currentPage; $name; $typeCollector)
			
			If ($o#Null:C1517)
				
				$o.pageNumber:=This:C1470.currentPageNumber
				
			End if 
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		: ($pages=Null:C1517)
			
			// <NOTHING MORE TO DO>
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		: ($pageNumber=This:C1470.CURRENT_PAGE_MORE)
			
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
		: ($pageNumber=This:C1470.ALL_PAGES)
			
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
			$indx:=This:C1470.CURRENT_PAGE
			
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
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
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
	
Function _buildObjectGroups
	var $0 : Object
	var $1 : Integer
	
	var $pageNumber : Integer
	
	$pageNumber:=$1
	
	var $pageGroup; $page; $allGroups : Object
	var $objects : Collection
	var $groupName; $objName; $objectType : Text
	var $done : Boolean
	var $foundInPage : Integer
	
	$done:=False:C215
	$allGroups:=Null:C1517
	$pageGroup:=Null:C1517
	$page:=This:C1470._getPage($pageNumber)
	
	If ($page#Null:C1517)
		
		If (This:C1470.editor.form.editor#Null:C1517)
			$allGroups:=This:C1470.editor.form.editor.groups
		End if 
		
		If ($allGroups#Null:C1517)
			
			$pageGroup:=New object:C1471
			
			For each ($groupName; $allGroups)
				$objects:=$allGroups[$groupName]
				If ($objects.length>0)
					$done:=False:C215
					For each ($objName; $objects) Until ($done=True:C214)
						If ($objName#"")
							If (This:C1470.Exists($objName; True:C214; ->$foundInPage))
								If ($foundInPage=$pageNumber)
									OB SET:C1220($pageGroup; $groupName; $objects.copy())
								End if 
								$done:=True:C214
							End if 
						End if 
					End for each 
				End if 
			End for each 
		End if 
	End if 
	
	If ($pageGroup#Null:C1517)
		If (OB Is empty:C1297($pageGroup))
			CLEAR VARIABLE:C89($pageGroup)
		End if 
	End if 
	
	$0:=$pageGroup
	
	
	
	
Function MakeUniqueObjectName
	var $0; $1 : Text
	var $2 : Collection
	var $3 : Boolean
	
	var $in_wantedName : Text
	var $in_exclusions : Collection
	var $in_withFreeMethodFile : Boolean
	
	$in_wantedName:=$1
	$in_exclusions:=$2
	$in_withFreeMethodFile:=$3
	$0:=""
	
	var $tmpName; $name; $tmpScriptName; $methodfolderpath : Text
	var $names; $groups : Collection
	var $found : Boolean
	var $counter : Integer
	
	// important
	// this code don't use strict string compare (This.Strcmp) 
	// because 4D object name is not case sensitive 
	
	
	If ($in_wantedName#"")
		
		$names:=This:C1470.GetObjectNames(-2)
		$groups:=This:C1470.groupNames
		
		If ($names.length>0)
			
			$counter:=0
			$tmpName:=$in_wantedName
			
			If ($in_withFreeMethodFile)
				$methodfolderpath:=This:C1470.objectMethodFolder.platformPath
			End if 
			
			Repeat 
				$found:=False:C215
				
				For each ($name; $names) While ($found=False:C215)
					$found:=($tmpName=$name)
				End for each 
				
				// groups
				If (($groups.length>0) & ($found=False:C215))
					For each ($name; $groups) While ($found=False:C215)
						$found:=($tmpName=$name)
					End for each 
				End if 
				
				// look in exclusion list
				If (($in_exclusions#Null:C1517) & ($found=False:C215))
					For each ($name; $in_exclusions) While ($found=False:C215)
						$found:=($tmpName=$name)
					End for each 
				End if 
				
				// test method file name
				If (($in_withFreeMethodFile) & ($found=False:C215))
					$tmpScriptName:=This:C1470.EncodeReservedFileCharacters($tmpName)
					$found:=(Test path name:C476($methodfolderpath+$tmpScriptName+".4dm")=Is a document:K24:1)
				End if 
				
				If ($found)
					$counter:=$counter+1
					$tmpName:=$in_wantedName+String:C10($counter)
				Else 
					$0:=$tmpName
				End if 
				
			Until ($0#"")
			
		Else 
			$0:=$in_wantedName
		End if 
		
	End if 
	
Function InsertFormObjectAfter
	var $2 : Object
	var $1; $3 : Text
	var $0 : Boolean
	
	var $in_newObjectName; $in_afterObjectName : Text
	var $in_newObject : Object
	
	$in_newObjectName:=$1
	$in_afterObjectName:=$3
	$in_newObject:=$2
	
	var $objects; $newObjects : Object
	var $property : Text
	
	$0:=False:C215
	$objects:=This:C1470.editor.currentPage.objects
	
	If ($in_newObjectName#"")
		If (Not:C34(OB Is defined:C1231($objects; $in_newObjectName)))
			If ($in_afterObjectName="")
				$objects[$in_newObjectName]:=$in_newObject
				$0:=True:C214
			Else 
				$newObjects:=New object:C1471
				For each ($property; $objects)
					$newObjects[$property]:=$objects[$property]
					If (This:C1470.Strcmp($property; $in_afterObjectName))
						$newObjects[$in_newObjectName]:=$in_newObject
					End if 
				End for each 
				This:C1470.editor.currentPage.objects:=$newObjects
				$0:=True:C214
			End if 
		End if 
	End if 
	
Function InsertFormObjectBefore
	var $2 : Object
	var $1; $3 : Text
	var $0 : Boolean
	
	var $in_newObjectName; $in_beforeObjectName : Text
	var $in_newObject : Object
	
	$in_newObjectName:=$1
	$in_beforeObjectName:=$3
	$in_newObject:=$2
	
	var $objects; $newObjects : Object
	var $newObjectName; $property : Text
	
	$0:=False:C215
	$objects:=This:C1470.editor.currentPage.objects
	
	If ($newObjectName#"")
		If (Not:C34(OB Is defined:C1231($objects; $in_beforeObjectName)))
			
			$newObjects:=New object:C1471
			
			If ($in_beforeObjectName="")
				$newObjects[$in_newObjectName]:=$in_newObject
			End if 
			
			For each ($property; $objects)
				If ($in_beforeObjectName#"")
					If (This:C1470.Strcmp($property; $in_beforeObjectName))
						$newObjects[$in_newObjectName]:=$in_newObject
					End if 
				End if 
				$newObjects[$property]:=$objects[$property]
			End for each 
			This:C1470.editor.currentPage.objects:=$newObjects
			$0:=True:C214
		End if 
	End if 
	
Function RenameObject
	var $1; $2 : Text
	var $0 : Boolean
	
	var $in_OldName; $in_NewName : Text
	
	$in_OldName:=$1
	$in_NewName:=$2
	
	var $objects; $newObjects : Object
	var $property : Text
	var $indx : Integer
	
	$0:=False:C215
	
	If (This:C1470.Exists($in_OldName; True:C214))
		If (Not:C34(This:C1470.Exists($in_NewName; True:C214)))
			$objects:=This:C1470.editor.currentPage.objects
			$newObjects:=New object:C1471
			For each ($property; $objects)
				//If (This.Strcmp($property;$in_OldName))
				If ($property=$in_OldName)
					$newObjects[$in_NewName]:=$objects[$property]
				Else 
					$newObjects[$property]:=$objects[$property]
				End if 
			End for each 
			
			This:C1470.editor.currentPage.objects:=$newObjects
			
			If (This:C1470.isSelected($in_OldName))
				This:C1470.Deselect($in_OldName)
				This:C1470.Select($in_NewName)
			End if 
			
			$indx:=This:C1470.FindInEntryOrder($in_OldName)
			If ($indx#-1)
				This:C1470.entryOrder[$indx]:=$in_NewName
			End if 
			$0:=True:C214
			
		End if 
	End if 
	
Function ObjectGetX
	var $1 : Object
	var $0 : Integer
	$0:=$1.left
	
Function ObjectGetY
	var $1 : Object
	var $0 : Integer
	$0:=$1.top
	
Function ObjectGetRight
	var $1 : Object
	var $0 : Integer
	$0:=$1.left+This:C1470.ObjectGetWidth($1)
	
Function ObjectGetBottom
	var $1 : Object
	var $0 : Integer
	$0:=$1.top+This:C1470.ObjectGetHeight($1)
	
Function ObjectGetWidth
	var $1 : Object
	var $0 : Integer
	If (OB Is defined:C1231($1; "right"))
		$0:=$1.right-$1.left
	Else 
		$0:=$1.width
	End if 
	
Function ObjectSetWidth
	var $1 : Object
	var $2 : Integer
	var $w; $r : Boolean
	
	$r:=OB Is defined:C1231($1; "right")
	$w:=OB Is defined:C1231($1; "width")
	If (($r=True:C214) | (($r=False:C215) & ($w=False:C215)))
		$1.right:=$1.left+$2
	End if 
	If ($w)
		$1.width:=$2
	End if 
	
Function ObjectGetHeight
	var $1 : Object
	var $0 : Integer
	
	If (OB Is defined:C1231($1; "bottom"))
		$0:=$1.bottom-$1.top
	Else 
		$0:=$1.height
	End if 
	
Function ObjectSetHeight
	var $1 : Object
	var $2 : Integer
	var $b; $h : Boolean
	
	$b:=OB Is defined:C1231($1; "bottom")
	$h:=OB Is defined:C1231($1; "height")
	If (($b=True:C214) | (($b=False:C215) & ($h=False:C215)))
		$1.bottom:=$1.top+$2
	End if 
	If ($h)
		$1.height:=$2
	End if 
	
	
Function ObjectSetX
	var $1 : Object
	var $2 : Integer
	var $r; $w : Boolean
	
	$r:=OB Is defined:C1231($1; "right")
	$w:=OB Is defined:C1231($1; "width")
	If ($w | $r)
		If ($r)
			$1.right:=$2+($1.right-$1.left)
			$1.left:=$2
		End if 
		If ($w)
			$1.left:=$2
		End if 
	Else 
		ASSERT:C1129(False:C215)
	End if 
	
Function ObjectSetY
	var $1 : Object
	var $2 : Integer
	var $b; $h : Boolean
	
	$b:=OB Is defined:C1231($1; "bottom")
	$h:=OB Is defined:C1231($1; "height")
	If ($b | $h)
		If ($b)
			$1.bottom:=$2+($1.bottom-$1.top)
			$1.top:=$2
		End if 
		If ($h)
			$1.top:=$2
		End if 
	Else 
		ASSERT:C1129(False:C215)
	End if 
	
Function ObjectSetPos
	var $1 : Object
	var $2; $3 : Integer
	
	This:C1470.ObjectSetX($1; $2)
	This:C1470.ObjectSetY($1; $3)
	
Function GetWidgetMethodInfo($widget : Object; $name : Text) : Integer
	
	// $1 object
	// $2 object name
	
	// 0 none
	// 1 std method : methode name match object name, object method file is the ObjectMethods folder
	// 2 project method
	// 3 custom
	
	var $method; $pathname : Text
	
	
	If ($widget=Null:C1517)\
		 || ($widget.method=Null:C1517)
		
		return   // 0 none
		
	End if 
	
	$method:=$widget.method
	
	If (Length:C16($method)=0)\
		 || (Length:C16($method)>5)\
		 || ($method#"@.4dm")
		
		return 2  // 2 project method
		
	End if 
	
	If ($method#"ObjectMethods/@")
		
		return 3  // 3 custom
		
	End if 
	var $objmethod : Text
	$objmethod:=Substring:C12($method; 0; Length:C16($method)-4)
	var $l : Integer
	$l:=Length:C16("ObjectMethods/")
	$objmethod:=Substring:C12($method; $l+1; Length:C16($objmethod)-$l)
	
	$pathname:=This:C1470.EncodeReservedFileCharacters($name)
	
	If (This:C1470.Strcmp($objmethod; $pathname))
		
		return 1  // 1 std method : methode name match object name, object method file is the ObjectMethods folder
		
	Else 
		
		return 3  // 3 custom
		
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
Function get groupNames : Collection
	
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
		
		If ($pageNumber=This:C1470.CURRENT_PAGE)
			
			return This:C1470.editor.currentPage
			
		End if 
	End if 
	
	// *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
	//returs the default values object
Function get _defaultValues : Object
	
	var $file : 4D:C1709.File
	$file:=This:C1470.appResources.file("DefaultJsonForm.json")
	return $file.exists ? JSON Parse:C1218($file.getText()) : {}
	
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