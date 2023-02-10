
//If (Form event code=On Delete Action)
//var $ind : Integer
//$ind:=Size of array(listBoxSel)
//While ($ind>0)
//If (listBoxSel{$ind}=True)
//If (path{$ind}.emptyForAdd=False)
//DELETE FROM ARRAY(listBoxSel; $ind)
//DELETE FROM ARRAY(path; $ind)
//DELETE FROM ARRAY(media; $ind)
//End if 
//End if 
//$ind:=$ind-1
//End while 
//End if 
//If (Form event code=On Double Clicked)
//var $x; $y; $col; $row : Integer
//LISTBOX GET CELL POSITION(*; "listBoxSel"; $x; $y; $col; $row)
//If ($row=0)
//$newRow:=Size of array(listBoxSel)+1
//LISTBOX INSERT ROWS(*; "listbox"; $newRow)
//path{$newRow}:=New object(\
"valueType"; "text"; \
"value"; ""; \
"alternateButton"; True)
//media{$newRow}:="none"
//EDIT ITEM(path; $newRow)
//End if 
//End if 

//OBJECT SET ENABLED(*; "minus"; Find in array(listBoxSel; True)>0)

