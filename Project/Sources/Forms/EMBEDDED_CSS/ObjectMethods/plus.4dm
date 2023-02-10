var $name : Text

$name:=Select document:C905(Form:C1466.form.parent.platformPath; ".css"; "Select CSS File"; 16)

If (Bool:C1537(OK))
	
	Form:C1466.addRow(DOCUMENT; FORM Event:C1606)
	
End if 