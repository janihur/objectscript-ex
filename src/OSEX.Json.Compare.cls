Class OSEX.Json.Compare
{

/// <p>Relaxed subset comparison. Returns:</p>
/// <ul>
/// <li><code>1</code> if <code>json2</code> is a subset of <code>json1</code></li>
/// <li><code>0</code> otherwise</li>
/// </ul>
/// <p>Subset rules:</p>
/// <ul>
/// <li>Each name in <code>json2</code> must exist in <code>json1</code>.</li>
/// <li>Each value (and it's type) in <code>json2</code> must be equal to the corresponding value (and it's type)in <code>json1</code>.</li>
/// <li>Each object in <code>json2</code> must be a subset of the corresponding object in <code>json1</code>.</li>
/// <li>For arrays the values in <code>json2</code> must be the first values in <code>json1</code> and the order have to be the same. It doesn't matter if <code>json1</code> has extra values. The types of the values have to be the same too.</li>
/// <li>The order of names doesn't matter, but the order of array values does matter.</li>
/// </ul>
ClassMethod IsSubset(
	json1 As %DynamicAbstractObject,
	json2 As %DynamicAbstractObject,
	debug As %Boolean = 0) As %Boolean
{
	// TODO add output parameter where the difference can be recorded

	write:(debug) "---",!

	// non-objects are not equal
	return:('$isobject(json1)) 0
	return:('$isobject(json2)) 0

	// random class types are not equal
	return:('( json1.%IsA({}.%ClassName(1)) || json1.%IsA([].%ClassName(1)) )) 0
	return:('( json2.%IsA({}.%ClassName(1)) || json2.%IsA([].%ClassName(1)) )) 0

	// different class types are not equal
	return:(json1.%IsA(json2.%ClassName(1)) = 0) 0

	#dim iter as %Iterator.AbstractIterator = json2.%GetIterator()
	
	#dim key as %String = ""
	#dim value // any
	#dim type as %String = ""
	while (iter.%GetNext(.key, .value, .type)) {
		write:(debug) "(key "_key_")(value "_value_")(type "_type_")",!
		if ((type = "array")||(type = "object")) {
			return:(..IsSubset(json1.%Get(key), value, debug) = 0) 0
		} else {
			if ((json1.%GetTypeOf(key) '= type)||(json1.%Get(key) '= value)) {
				// type or value differs
				return 0
			}
		}
	}

	return 1
}

/// <p>Strict equality comparison.</p>
/// <p>The order of all names and values has to be identical. The caller is
/// responsible to pass valid objects. Will throw system exceptions if the 
/// objects are not valid.</p>
ClassMethod IsEqual(
	json1 As %DynamicAbstractObject,
	json2 As %DynamicAbstractObject) As %Boolean [ CodeMode = expression ]
{
json1.%ToJSON() = json2.%ToJSON()
}

ClassMethod RunTests()
{
	do .."Test: Valid JSON"()
	do .."Test: Invalid JSON"()
}

ClassMethod "Test: Valid JSON"()
{
	write "--- Valid JSON",!

	set cases= [
		// conflicting types --------------------------------------------------
		{
			"name": "Array vs. object",
			"json1": [],
			"json2": {},
			"expected": {
				"IsSubset": 0,
				"IsEqual": 0
			}
		},
		// top level objects --------------------------------------------------
		{
			"name": "Empty objects",
			"json1": {},
			"json2": {},
			"expected": {
				"IsSubset": 1,
				"IsEqual": 1
			}
		},
		{
			"name": "Object subset: empty object",
			"json1": {"a":1},
			"json2": {     },
			"expected": {
				"IsSubset": 1,
				"IsEqual": 0
			}
		},
		{
			"name": "Object subset: valid subset",
			"json1": {"a":1, "b":1},
			"json2": {       "b":1},
			"expected": {
				"IsSubset": 1,
				"IsEqual": 0
			}
		},
		{
			"name": "Object subset: invalid subset",
			"json1": {       "b":1},
			"json2": {"a":1, "b":1},
			"expected": {
				"IsSubset": 0,
				"IsEqual": 0
			}
		},
		{
			"name": "Object with same keys different order",
			"json1": {"a":1, "b":1},
			"json2": {"b":1, "a":1},
			"expected": {
				"IsSubset": 1,
				"IsEqual": 0
			}
		},
		{
			"name": "Object with all possible value types",
			"json1": {"a":"foo", "b":1.23, "c":true, "d":null, "e":{}, "f":[]},
			"json2": {"a":"foo", "b":1.23, "c":true, "d":null, "e":{}, "f":[]},
			"expected": {
				"IsSubset": 1,
				"IsEqual": 1
			}
		},
		{
			"name": "Object with null missing key",
			"json1": {          "b":1},
			"json2": {"a":null, "b":1},
			"expected": {
				"IsSubset": 0,
				"IsEqual": 0
			}
		},
		{
			"name": "Object with empty string vs. null",
			"json1": {"a":"",   "b":1},
			"json2": {"a":null, "b":1},
			"expected": {
				"IsSubset": 0,
				"IsEqual": 0
			}
		},
		{
			"name": "Object with different values: number",
			"json1": {"a":1},
			"json2": {"a":2},
			"expected": {
				"IsSubset": 0,
				"IsEqual": 0
			}
		},
		{
			"name": "Object with different values: boolean",
			"json1": {"a":true},
			"json2": {"a":false},
			"expected": {
				"IsSubset": 0,
				"IsEqual": 0
			}
		},
		{
			"name": "Object with different values: string",
			"json1": {"a":"cats"},
			"json2": {"a":"dogs"},
			"expected": {
				"IsSubset": 0,
				"IsEqual": 0
			}
		},
		{
			"name": "Object with different values: array vs. object",
			"json1": {"a":1},
			"json2": {"a":{"b":1}},
			"expected": {
				"IsSubset": 0,
				"IsEqual": 0
			}
		},
		// top level array ----------------------------------------------------
		{
			"name": "Empty arrays",
			"json1": [],
			"json2": [],
			"expected": {
				"IsSubset": 1,
				"IsEqual": 1
			}
		},
		{
			"name": "Array subset: empty array",
			"json1": [1],
			"json2": [],
			"expected": {
				"IsSubset": 1,
				"IsEqual": 0
			}
		},
		{
			"name": "Array subset: valid subset",
			"json1": [1,2],
			"json2": [1],
			"expected": {
				"IsSubset": 1,
				"IsEqual": 0
			}
		},
		{
			"name": "Array subset: invalid subset #1",
			"json1": [1,2],
			"json2": [2],
			"expected": {
				"IsSubset": 0,
				"IsEqual": 0
			}
		},
		{
			"name": "Array subset: invalid subset #2",
			"json1": [1, 2],
			"json2": [2, 1],
			"expected": {
				"IsSubset": 0,
				"IsEqual": 0
			}
		},
		{
			"name": "Array with all possible value types",
			"json1": ["foo", 1.23, true, null, {}, []],
			"json2": ["foo", 1.23, true, null, {}, []],
			"expected": {
				"IsSubset": 1,
				"IsEqual": 1
			}
		},
		{
			"name": "Array with empty string vs. null",
			"json1": ["foo", ""],
			"json2": ["foo", null],
			"expected": {
				"IsSubset": 0,
				"IsEqual": 0
			}
		},
		// nested structures --------------------------------------------------
		{
			"name": "Array of objects: valid subset #1",
			"json1": [{"a":1,"b":1},{"a":2,"b":2}],
			"json2": [{"a":1,"b":1},{"a":2,"b":2}],
			"expected": {
				"IsSubset": 1,
				"IsEqual": 1
			}
		},
		{
			"name": "Array of objects: valid subset #2",
			"json1": [{"a":1,"b":1},{"a":2,"b":2}],
			"json2": [{      "b":1},{"a":2      }],
			"expected": {
				"IsSubset": 1,
				"IsEqual": 0
			}
		},
		{
			"name": "Array of objects: valid subset #3",
			"json1": [{"a":1,"b":1},{"a":2,"b":2}],
			"json2": [{      "b":1}              ],
			"expected": {
				"IsSubset": 1,
				"IsEqual": 0
			}
		},
		{
			"name": "Array of objects with array: valid subset",
			"json1": [{"a":1,"b":{"c": [2,3],"d":4}}],
			"json2": [{"a":1,"b":{"c": [2  ],"d":4}}],
			"expected": {
				"IsSubset": 1,
				"IsEqual": 0
			}
		}
	]

	set iter = cases.%GetIterator()
	while (iter.%GetNext(.key, .value)){
		set description = "Test #"_(key+1)_" "_value.name
		write description,!
		do ..AssertEqual(..IsSubset(value.json1, value.json2), value.expected.IsSubset, description_": IsSubset()")
		do ..AssertEqual(..IsEqual(value.json1, value.json2), value.expected.IsEqual, description_": IsEqual()")
	}
}

ClassMethod "Test: Invalid JSON"()
{
	write "--- Invalid JSON",!

	set description = "Test #1 Null OREF #1"
	write description,!
	set json1 = ""
	set json2 = {"a":1}

	do ..AssertEqual(..IsSubset(json1, json2), 0, description_": IsSubset()")

	set ex = $$$NULLOREF
	try {
		do ..IsEqual(json1, json2)
	} catch (ex) {}
	do ..AssertEqual($isobject(ex), 1, description_": IsEqual()")
	do ..AssertEqual(ex.Name, "<INVALID OREF>", description_": IsEqual()")

	// ------------------------------------------------------------------------

	set description = "Test #2 Null OREF #2"
	write description,!
	set json1 = {"a":1}
	set json2 = ""

	do ..AssertEqual(..IsSubset(json1, json2), 0, description_": IsSubset()")

	set ex = $$$NULLOREF
	try {
		do ..IsEqual(json1, json2)
	} catch (ex) {}
	do ..AssertEqual($isobject(ex), 1, description_": IsEqual()")
	do ..AssertEqual(ex.Name, "<INVALID OREF>", description_": IsEqual()")

	// ------------------------------------------------------------------------

	set description = "Test #3 Random object #1"
	write description,!
	set json1 = {"a":1}
	set json2 = ##class(%ListOfDataTypes).%New()

	do ..AssertEqual(..IsSubset(json1, json2), 0, description_": IsSubset()")

	set ex = $$$NULLOREF
	try {
		do ..IsEqual(json1, json2)
	} catch (ex) {}
	do ..AssertEqual($isobject(ex), 1, description_": IsEqual()")
	do ..AssertEqual(ex.Name, "<METHOD DOES NOT EXIST>", description_": IsEqual()")

	// ------------------------------------------------------------------------

	set description = "Test #4 Random object #2"
	write description,!
	set json1 = ##class(%ListOfDataTypes).%New()
	set json2 = {"a":1}

	do ..AssertEqual(..IsSubset(json1, json2), 0, description_": IsSubset()")

	set ex = $$$NULLOREF
	try {
		do ..IsEqual(json1, json2)
	} catch (ex) {}
	do ..AssertEqual($isobject(ex), 1, description_": IsEqual()")
	do ..AssertEqual(ex.Name, "<METHOD DOES NOT EXIST>", description_": IsEqual()")

	// ------------------------------------------------------------------------

	set description = "Test #5 Non-object value #1"
	write description,!
	set json1 = 1
	set json2 = {"a":1}

	do ..AssertEqual(..IsSubset(json1, json2), 0, description_": IsSubset()")

	set ex = $$$NULLOREF
	try {
		do ..IsEqual(json1, json2)
	} catch (ex) {}
	do ..AssertEqual($isobject(ex), 1, description_": IsEqual()")
	do ..AssertEqual(ex.Name, "<INVALID OREF>", description_": IsEqual()")

	// ------------------------------------------------------------------------

	set description = "Test #6 Non-object value #2"
	write description,!
	set json1 = {"a":1}
	set json2 = 1

	do ..AssertEqual(..IsSubset(json1, json2), 0, description_": IsSubset()")

	set ex = $$$NULLOREF
	try {
		do ..IsEqual(json1, json2)
	} catch (ex) {}
	do ..AssertEqual($isobject(ex), 1, description_": IsEqual()")
	do ..AssertEqual(ex.Name, "<INVALID OREF>", description_": IsEqual()")
}

ClassMethod AssertEqual(
	actual As %String,
	expected As %String,
	message As %String = "")
{
	if (actual '= expected) {
		throw ##class(%Exception.General).%New("ASSERTION FAILURE", 5001,,message_" Expected: ["_expected_"] but got: ["_actual_"]")
	}
}

}
