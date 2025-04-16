Class OSEX.Json.Merge
{

/// <p>Merge two JSON objects. The second object will override the first one.</p>
/// <p>Arrays might not behave intuitively, check the tests for the behavior.</p>
ClassMethod Merge(
	json1 As %DynamicAbstractObject,
	json2 As %DynamicAbstractObject,
	debug As %Boolean = 0) As %DynamicAbstractObject
{
	write:(debug) "---",!

	return:('$isobject(json1)) json2
	return:('( ..IsJsonObject(json1) || ..IsJsonArray(json1) )) ..Clone(json2)
	return:('( ..IsJsonObject(json2) || ..IsJsonArray(json2) )) ..Clone(json1)

	#dim result as %DynamicAbstractObject = ..Clone(json1)

	#dim iter as %Iterator.AbstractIterator = json2.%GetIterator()

	#dim key as %String = ""
	#dim value // any
	#dim type as %String = ""
	while (iter.%GetNext(.key, .value, .type)) {
		write:(debug) "(key "_key_")(value "_value_")(type "_type_")",!
		if ((type = "array")||(type = "object")) {
			set value = ..Merge(result.%Get(key), value, debug)
			do result.%Set(key, value)
		} else {
			do result.%Set(key, value, type)
		}
	}

	return result
}

ClassMethod IsJsonObject(json As %DynamicAbstractObject) As %Boolean [ CodeMode = expression ]
{
json.%IsA({}.%ClassName(1))
}

ClassMethod IsJsonArray(json As %DynamicAbstractObject) As %Boolean [ CodeMode = expression ]
{
json.%IsA([].%ClassName(1))
}

ClassMethod Clone(json As %DynamicAbstractObject) As %DynamicAbstractObject
{
	return:(..IsJsonObject(json)) {}.%FromJSON(json.%ToJSON())
	return:(..IsJsonArray(json)) [].%FromJSON(json.%ToJSON())
	return ""
}

ClassMethod Test()
{
	set cases = [
		{
			"name": "Values: strings",
			"json1": {
				"key1": "value1", 
				"key2": "value2"
			},
			"json2": {
				"key2": "newValue2",
				"key3": "value3",
				"key4": ""
			},
			"expected": {
				"key1": "value1",
				"key2": "newValue2",
				"key3": "value3",
				"key4": ""
			}
		},
		{
			"name": "Values: numbers",
			"json1": {
				"key1": 1, 
				"key2": 1.0,
				"key3": 1.0,
				"key4": 1.1
			},
			"json2": {
				"key3": 2.0,
				"key5": 2.1
			},
			"expected": {
				"key1": 1,
				"key2": 1.0,
				"key3": 2,
				"key4": 1.1,
				"key5": 2.1
			}
		},
		{
			"name": "Values: boolean",
			"json1": {
				"key1": true, 
				"key2": true,
				"key3": false
			},
			"json2": {
				"key2": false,
				"key4": true
			},
			"expected": {
				"key1": true,
				"key2": false,
				"key3": false,
				"key4": true
			}
		},
		{
			"name": "Values: null",
			"json1": {
				"key1": 1,
				"key2": null,
				"key3": 3
			},
			"json2": {
				"key2": 2,
				"key3": null,
				"key4": null
			},
			"expected": {
				"key1": 1,
				"key2": 2,
				"key3": null,
				"key4": null
			}
		},
		{
			"name": "Nested objects",
			"json1": {
				"obj1": {
					"key1": 1,
					"key2": 2,
					"obj12": {
						"key1": 11,
						"key2": 22
					}
				}
			},
			"json2": {
				"obj1": {
					"key2": 22,
					"key3": 33,
					"obj12": {
						"key2": 222,
						"key3": 333
					}
				}
			},
			"expected": {
				"obj1": {
					"key1": 1,
					"key2": 22,
					"obj12": {
						"key1": 11,
						"key2": 222,
						"key3": 333
					},
					"key3": 33
				}
			}
		},
		{
			"name": "Arrays 1",
			"json1": {
				"arr1": [1,2,3],
				"arr2": [1,2,3],
				"arr3": [1,2,3]
			},
			"json2": {
				"arr2": [null,5],
				"arr3": [1,2,3,4,5],
				"arr4": [1,2,3]
			},
			"expected": {
				"arr1": [1,2,3],
				"arr2": [null,5,3],
				"arr3": [1,2,3,4,5],
				"arr4": [1,2,3]
			}
		},
		{
			"name": "Arrays 2",
			"json1": {
				"arr1": [
					{"item1": {"key1": 1, "key2": 2}},
					{"item2": {"key3": 3, "key4": 4}},
					{"item3": {"key5": 5, "key6": 6}}
				]
			},
			"json2": {
				"arr1": [
					{},
					{"item2": {"key4": 44, "key5": 55}},
					{},
					{"item4": {"key7": 77}}
				]
			},
			"expected": {
				"arr1": [
					{"item1": {"key1": 1, "key2": 2}},
					{"item2": {"key3": 3, "key4": 44, "key5": 55}},
					{"item3": {"key5": 5, "key6": 6}},
					{"item4": {"key7": 77}}
				]
			}
		}
	]

	set iter = cases.%GetIterator()
	while (iter.%GetNext(.key, .value)){
		set description = "Test #"_(key+1)_" "_value.name
		write description,!
		#dim debug as %Boolean = 0
		do ..AssertEqualJson(..Merge(value.json1, value.json2, debug), value.expected, description)
	}
}

ClassMethod AssertEqualJson(
	actual As %DynamicAbstractObject,
	expected As %DynamicAbstractObject,
	message As %String = "")
{
	set actualStr = actual.%ToJSON()
	set expectedStr = expected.%ToJSON()

	if (actualStr '= expectedStr) {
		throw ##class(%Exception.General).%New("ASSERTION FAILURE", 5001,,message_" Expected: ["_expectedStr_"] but got: ["_actualStr_"]")
	}
}

}
