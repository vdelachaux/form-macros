//%attributes = {"preemptive":"capable"}
// Method parameters
C_OBJECT:C1216($0)
C_TEXT:C284($1)

// Local variables
C_TEXT:C284($css)
C_TEXT:C284($value)
C_LONGINT:C283($state)
C_TEXT:C284($selector)
C_OBJECT:C1216($result)
C_OBJECT:C1216($object)
C_OBJECT:C1216($states)
C_TEXT:C284($attribute)

// Initialize states enumeration
$states:=New object:C1471
$states.IN_SELECTOR:=0
$states.IN_BODY:=1
$states.IN_ATTR_NAME:=2
$states.IN_ATTR_VALUE:=3
$states.IN_MEDIA:=4
$states.IN_COMMENT:=5

// Initialize local variables
$css:=$1

$result:=New object:C1471
$object:=New object:C1471
$state:=$states.IN_SELECTOR

$length:=Length:C16($css)

For ($char; 1; $length; 1)
	
	Case of 
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		: ($char<$length) && (Position:C15("@"; $css[[$char+1]]; *)=1)
			
			$inMedia:=0
			$char:=$char+1
			$state:=$states.IN_MEDIA
			
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		: ($css[[$char]]="/") && ($char<$length) && ($css[[$char+1]]="*")
			
			$char:=Position:C15("*/"; $css; $char+1)+2
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		: ($state=$states.IN_COMMENT)
			
			If ($css[[$char]]="*") && ($char<$length) && ($css[[$char+1]]="/")
				
				$char:=$char+1
				$state:=$states.IN_SELECTOR
				
			End if 
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		: ($state=$states.IN_MEDIA)
			
			Case of 
					
					//__________________________
				: ($css[[$char]]="{")
					
					$inMedia+=1
					
					//_________________________
				: ($css[[$char]]="}")
					
					$inMedia-=1
					
					If ($inMedia=0)
						
						$state:=$states.IN_SELECTOR
						
					End if 
					
					//_________________________
			End case 
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		: ($css[[$char]]="{")
			
			// Check that we are in the step of selector definition
			ASSERT:C1129($state=$states.IN_SELECTOR; "Unexpected opening bracket")
			
			$selector:=(Split string:C1554($selector; " "; sk ignore empty strings:K86:1+sk trim spaces:K86:2)).join(" ")
			$attribute:=""
			$value:=""
			$object:=New object:C1471
			
			$state:=$states.IN_BODY
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		: ($css[[$char]]="}")
			
			
			// Check that we are inside the definition of a selector
			ASSERT:C1129($state=$states.IN_BODY; "Unexpected closing bracket")
			
			$result[$selector]:=$object
			
			$selector:=""
			$attribute:=""
			$value:=""
			
			$state:=$states.IN_SELECTOR
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		: ($css[[$char]]=";")
			
			// Check that we was assigning an attribute value
			ASSERT:C1129($state=$states.IN_ATTR_VALUE; "Unexpected character ';'")
			
			// Check that the attribute name is not empty
			ASSERT:C1129($attribute#""; "Attribute name can not be empty")
			
			// Check that the attribute value is not empty
			ASSERT:C1129($value#""; "Attribute value can not be empty")
			
			$attribute:=(Split string:C1554($attribute; " "; sk ignore empty strings:K86:1+sk trim spaces:K86:2)).join(" ")
			$value:=(Split string:C1554($value; " "; sk ignore empty strings:K86:1+sk trim spaces:K86:2)).join(" ")
			
			OB SET:C1220($object; \
				$attribute; $value)
			
			$attribute:=""
			$value:=""
			$state:=$states.IN_BODY
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		: ($css[[$char]]=":")
			
			// ':' is allowed only in selectors and to separate an attribute name with its value
			ASSERT:C1129(($state=$states.IN_ATTR_NAME) | ($state=$states.IN_SELECTOR); "Unexpected character ':'")
			
			Case of 
					
					//======================================
				: ($state=$states.IN_ATTR_NAME)
					
					$state:=$states.IN_ATTR_VALUE
					
					//======================================
				: ($state=$states.IN_SELECTOR)
					
					$selector:=$selector+$css[[$char]]
					
					//======================================
			End case 
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		: ($css[[$char]]="\r")\
			 | ($css[[$char]]="\n")\
			 | ($css[[$char]]="\t")\
			 | ($css[[$char]]="\\s")
			
			// Ignore
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
		Else 
			
			Case of 
					
					//======================================
				: ($state=$states.IN_SELECTOR)
					
					$selector:=$selector+$css[[$char]]
					
					//======================================
				: ($state=$states.IN_ATTR_NAME)
					
					$attribute:=$attribute+$css[[$char]]
					
					//======================================
				: ($state=$states.IN_ATTR_VALUE)
					
					$value:=$value+$css[[$char]]
					
					//======================================
				: ($state=$states.IN_BODY)
					
					If ($css[[$char]]#" ")
						
						$attribute:=$css[[$char]]
						$state:=$states.IN_ATTR_NAME
						
					End if 
					
					//======================================
			End case 
			
			//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
	End case 
End for 

$0:=$result