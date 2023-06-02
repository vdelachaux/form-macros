Class constructor
	
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