/// simple (in-place) json transformations
/// https://docs.intersystems.com/irislatest/csp/docbook/DocBook.UI.Page.cls?KEY=GJSON_intro
Class OSEX.Json.Transform Extends %RegisteredObject
{

Property NoRules As %Boolean [ InitialExpression = 1 ];

Property rules As %Binary [ MultiDimensional, Private ];

Method %OnNew(rules As %DynamicArray = "") As %Status [ Private ]
{
    if ($isobject(rules)) {
        if (rules.%IsA("%DynamicArray")) {
            #dim iter as %Iterator.Array = rules.%GetIterator()
            while (iter.%GetNext(.key, .value)) {
                #dim type as %String = rules.%GetTypeOf(key)
                if ((type = "string") && (value '= "")) {
                    set ..rules(value) = 1
                }
            }
        }
    }

    set ..NoRules = ($data(..rules) '= 10)

    return $$$OK
}

/// Removes the names from the input json object that are in the rules.
/// Modifies the input json object in place.
/// Rules are simple names (of name/value pairs).
/// No hierarchy can be expressed but the names are removed on every level 
/// (objects and arrays).
ClassMethod Remove(
	ByRef json As %DynamicObject,
	rules As %DynamicArray = "")
{
    set o = ##class(OSEX.Json.Transform).%New(rules)
    return:o.NoRules
    do o.removeImpl(.json)
}

/// Copies the top level names only from the input json object to output json
/// object.
ClassMethod Copy(
	json As %DynamicObject,
	rules As %DynamicArray = "") As %DynamicObject
{
    set o = ##class(OSEX.Json.Transform).%New(rules)
    return:o.NoRules {}
    return o.copyImpl(json)
}

Method removeImpl(ByRef json As %DynamicObject) [ Private ]
{
    #dim iter as %Iterator.Object = json.%GetIterator()
    while (iter.%GetNext(.key, .value)) {
        if (..hasRule(key)) {
            do json.%Remove(key)
        } else {
            #dim type as %String = json.%GetTypeOf(key)
            if ((type = "object") || (type = "array")) {
                do ..removeImpl(.value)
            }
        }
    }
}

Method copyImpl(json As %DynamicObject) As %DynamicObject [ Private ]
{
    #dim output as %DynamicObject = {}

    #dim iter as %Iterator.Object = json.%GetIterator()
    while (iter.%GetNext(.key, .value)) {
        if (..hasRule(key)) {
            do output.%Set(key, json.%Get(key))
        }
    }

    return output
}

Method hasRule(key As %String) As %Boolean [ Private ]
{
    return $data(..rules(key)) = 1
}

ClassMethod Ex1()
{
    #dim json as %DynamicObject = { 
        "One": 1, 
        "Two": {
            "TwoOne": 21, 
            "foo": "Foo",
            "TwoTwo": 22
        }, 
        "Three": 3, 
        "foo": "Foo", 
        "Four": [
            { 
                "FourOne": 41, 
                "bar": "Bar",
                "foo": "Foo",
                "FourTwo": 42
            },
            { 
                "FourOne": 41, 
                "bar": "Bar",
                "foo": "Foo",
                "FourTwo": 42
            }
        ],
        "Five": {
            "foo": [1,2,3]
        },
        "bar": {
            "BarOne": "B1"
        } 
    }
    zwrite json

    #; #dim rules as %DynamicArray = ["foo", "bar"]
    // everything but string literals are ignored when the rules are created
    // so here the array is effectively: ["foo", "bar"]
    do ..Remove(.json, ["", null, 1, {"foo": "FOO"}, "foo", [1,2], true, "bar"])

    zwrite json
}

ClassMethod Ex2()
{
    #dim json1 as %DynamicObject = { 
        "One": 1, 
        "foo": "Foo", 
        "Two": {
            "TwoOne": 21
        }, 
        "bar": {
            "BarOne": "B1"
        },
        "Three": 3
    }
    zwrite json1

    #; #dim rules as %DynamicArray = ["foo", "bar"]
    // everything but string literals are ignored when the rules are created
    // so here the array is effectively: ["foo", "bar"]
    set json2 = ..Copy(json1, ["", null, 1, {"foo": "FOO"}, "foo", [1,2], true, "bar"])

    zwrite json2
}

}
