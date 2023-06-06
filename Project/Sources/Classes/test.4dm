Class constructor
	
	var $o : Object
	var $t : Text
	
	$t:="hello"
	$o:={in: This:C1470.f($t); out: "hello world"}  // OK
	
/* ACI0103930
var $test : Object
$test:={test: "hello"}
$o:={in: This.f($test.test); out : "hello world"}  // KO
	
*/
	
Function f($t : Text) : Text
	
	return $t+" world"
	
Function Obfuscate($key : Text; $value)
	
	This:C1470[""]:=This:C1470[""] || {}
	This:C1470[""][$key]:=$value
	
Function set pasword($pasword)
	
	This:C1470.Obfuscate("pwd"; $pasword)
	
	
Function pointer($ptr : Pointer)
	
	If (Is nil pointer:C315($ptr))
		
		return 
		
	End if 
	
	ALERT:C41("not nil pointer")