//%attributes = {}

data:=New object:C1471
data.embedded_css:=New collection:C1472

data.embedded_css.push(New object:C1471("path"; "form.css"))
data.embedded_css.push(New object:C1471("path"; "form_mac.css"; "media"; "mac"))
data.embedded_css.push(New object:C1471("path"; "form_windows.css"; "media"; "windows"))

$w:=Open form window:C675("EMBEDDED_CSS"; Movable form dialog box:K39:8)
DIALOG:C40("EMBEDDED_CSS"; data)
CLOSE WINDOW:C154($w)