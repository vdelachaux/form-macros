//%attributes = {"preemptive":"capable"}
//C_TEXT($0)
//C_OBJECT($1)
//C_BOOLEAN($2)

//C_TEXT($result)
//C_OBJECT($object)
//C_BOOLEAN($isFormat)

//$result:=""
//$object:=$1
//$isFormat:=$2

//For each ($selector; $object)
//If (Value type($object[$selector])=Is object)
//$result:=$result+$selector
//If ($isFormat)
//$result:=$result+" {\r"
//Else 
//$result:=$result+"{"
//End if 
//For each ($attr; $object[$selector])
//If (Value type($object[$selector][$attr])=Is text)
//If ($isFormat)
//$result:=$result+"  "+$attr+": "+$object[$selector][$attr]+";\r"
//Else 
//$result:=$result+$attr+":"+$object[$selector][$attr]+";"
//End if 
//End if 
//End for each 
//$result:=$result+"}"
//If ($isFormat)
//$result:=$result+"\r\r"
//End if 
//End if 
//End for each 

//$0:=$result
