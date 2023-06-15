If (Not:C34(Is compiled mode:C492))
	
	ARRAY TEXT:C222($componentsArray; 0)
	COMPONENT LIST:C1001($componentsArray)
	
	If (Find in array:C230($componentsArray; "4DPop QuickOpen")>0)
		
		// Installing quickOpen
		EXECUTE METHOD:C1007("quickOpenInit"; *; Formula:C1597(MODIFIERS); Formula:C1597(KEYCODE))
		ON EVENT CALL:C190("quickOpenEventHandler"; "$quickOpenListener")
		
		var $icon : Picture
		READ PICTURE FILE:C678(File:C1566("/RESOURCES/Images/Avatar 32x32.jpg").platformPath; $icon)
		
		EXECUTE METHOD:C1007("quickOpenPushAction"; *; {\
			name: "RESET FORM MACRO"; \
			icon: $icon; \
			formula: Formula from string:C1601("reloadFormMacros")\
			})
		
	End if 
End if 
