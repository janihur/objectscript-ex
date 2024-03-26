Class OSEX.Ex.Eval Extends %RegisteredObject
{

ClassMethod Ex1()
{
	#dim json as %DynamicArray = [
		{
			"name": "string value",
			"value": "foo is bar",
			"type": "string"
		},
		{
			"name": "number value",
			"value": 42,
			"type": "number"
		},
		{
			"name": "unknown type",
			"value": 0,
			"type": "xxx"
		},
		{
			"name": "code value",
			"value": "$ztimeh(\"03:00:00\")",
			"type": "code"
		},
		{
			"name": "invalid code value",
			"value": "$ztimeh(03:00:00)",
			"type": "code"
		}
	]
	
	#dim index as %Integer
	#dim object as %DynamicObject
	#dim arrIter as %Iterator.Array = json.%GetIterator()
	while (arrIter.%GetNext(.index,.object)) {
		write "---",!
		#dim code as %String
		if (object.type = "string") {
			set code = """"_object.value_""""
		} elseif (object.type = "number") {
			set code = object.value
		} elseif (object.type = "code") {
			set code = object.value
			/*
			write code,!
			#dim status = ##class(%Routine).CheckSyntax(code)
			if ($$$ISERR(status)) {
				do $system.Status.DisplayError(status)
				write !,"skipping invalid code: "_object.value,!
				continue
			}
			*/
		} else {
			write "skipping unknown type: "_object.type,!
			continue
		}

		write "code: ",code,!
		
		#dim value as %String = ""
		#dim status = ..Eval1(code,.value)
		if ($$$ISERR(status)) {
			do $system.Status.DisplayError(status)
			write !
		}

		zw value

		//#dim a as %String = "DEFAULT"
		//xecute ("(out)"_code, .a)
		//zw a
	}
}

ClassMethod Eval1(code As %String, ByRef out) As %Status
{
	#dim status = ##class(%Routine).CheckSyntax(" set out = "_code)
	if ($$$ISERR(status)) {
		return status
	}
	
	xecute ("(out) set out = "_code, .out)
	
	return $$$OK
}

ClassMethod Ex2()
{
	#dim task = ##class(%SYS.Task).%New()
	zw task.Description
	set task.Description = "ONE"
	zw task.Description
	// works in terminal but not here
	// xecute "set task.Description = ""TWO"""
	// works:
	#dim value as %String = "TWO"
	xecute ("(obj,value) set obj.Description = value",task,value)
	zw task.Description
}

ClassMethod Ex3()
{
	#dim json as %DynamicObject = {
		"Description": "Lorem ipsum dolor sit amet.",
		"TaskClass": "OSEX.Ex",
		"TimePeriod": 0,
		"DailyFrequency": 0,
		"DailyStartTime": "code:$ztimeh(\"03:00:00\")"
	}
	
	#dim task = ##class(%SYS.Task).%New()
	
	#dim key as %String
	#dim value as %String
	#dim iter as %Iterator.Object = json.%GetIterator()
	while (iter.%GetNext(.key,.value)) {
		write "---",!
		write "key: "_key_" value: "_value,!

		#dim code as %String = ""
		if ($extract(value,1,5) = "code:") {
			write "REAL CODE!",!
			set code = $replace(value,"code:","") // no quotes
		} else {
			set code = """"_value_"""" // quotes
		}
		write "code: "_code,!

		//xecute ("(obj) set obj.Description = ""foo is bar""", task)
		#dim status = ..Eval3(task,key,code)
		if ($$$ISERR(status)) {
			write "compilation error of """_value_""":",!
			do $system.Status.DisplayError(status)
			write !
		}
	}
	
	zw task
}

ClassMethod Eval3(task, property As %String, value) As %Status
{
	#dim code = "set obj."_property_" = "_value	
	#dim status = ##class(%Routine).CheckSyntax(" "_code)
	if ($$$ISERR(status)) {
		return status
	}

	xecute ("(obj) "_code,task)
	
	return $$$OK
}

}

