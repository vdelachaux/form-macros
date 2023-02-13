//%attributes = {"preemptive":"capable"}
C_TEXT:C284($0)
C_OBJECT:C1216($1)
C_BOOLEAN:C305($2)

C_TEXT:C284($result)
C_OBJECT:C1216($object)
C_BOOLEAN:C305($isFormat)

$result:=""
$object:=$1
$isFormat:=$2

For each ($selector; $object)
	If (Value type:C1509($object[$selector])=Is object:K8:27)
		$result:=$result+$selector
		If ($isFormat)
			$result:=$result+" {\r"
		Else 
			$result:=$result+"{"
		End if 
		For each ($attr; $object[$selector])
			If (Value type:C1509($object[$selector][$attr])=Is text:K8:3)
				If ($isFormat)
					$result:=$result+"  "+$attr+": "+$object[$selector][$attr]+";\r"
				Else 
					$result:=$result+$attr+":"+$object[$selector][$attr]+";"
				End if 
			End if 
		End for each 
		$result:=$result+"}"
		If ($isFormat)
			$result:=$result+"\r\r"
		End if 
	End if 
End for each 

$0:=$result
