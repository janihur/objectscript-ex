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
            while (iter.%GetNext(.key, .value, .type)) {
                if ((type = "string") && (value '= "")) {
                    #dim type2 as %String = "GENERIC_NAME"
                    if ($extract(value, 1) = ".") {
                        set type2 = "FULLY_QUALIFIED_NAME"
                    } elseif (..countChars(value, ".") > 0) {
                        set type2 = "PARTIALLY_QUALIFIED_NAME"
                    }
                    set ..rules(value) = type2
                }
            }
        }
    }

    set ..NoRules = ($data(..rules) '= 10)

    return $$$OK
}

/// Removes the names from the input json object that are in the rules.
/// Modifies the input json object in place.
/// The rules is a a list of:
/// 1) simple names (of name/value pairs) - these names are removed from every level
/// 2) fully qualified names - these names are removed only from the specified path
/// Fully qualified name starts with a dot and the path is separated by dots.
/// Partially qualified names are not supported.
ClassMethod Remove(
	json As %DynamicObject,
	rules As %DynamicArray)
{
    set o = ##class(OSEX.Json.Transform).%New(rules)
    return:o.NoRules
    do o.removeImpl(json)
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

Method removeImpl(
	json As %DynamicObject,
	path As %String = "",
	isArrayIteration As %Boolean = 0) [ Private ]
{
    #dim iter as %Iterator.Object = json.%GetIterator()
    while (iter.%GetNext(.key, .value, .type)) {
        if (..hasRule(path, key)) {
            do json.%Remove(key)
        } else {
            if ((type = "object")) {
                if (isArrayIteration) {
                    // don't add array index to path
                    do ..removeImpl(value, path)
                } else {
                    do ..removeImpl(value, path_"."_key)
                }
            } elseif (type = "array") {
                do ..removeImpl(value, path_"."_key_".[]", 1)
            }
        }
    }
}

Method copyImpl(json As %DynamicObject) As %DynamicObject [ Private ]
{
    #dim output as %DynamicObject = {}

    #dim iter as %Iterator.Object = json.%GetIterator()
    while (iter.%GetNext(.key, .value)) {
        if (..hasRule("", key)) {
            do output.%Set(key, json.%Get(key))
        }
    }

    return output
}

Method hasRule(
	path As %String,
	key As %String) As %Boolean [ Private ]
{
    // 1/2 check rules for generic name, i.e. ignore path
    return:($data(..rules(key)) = 1) 1
    // 2/2 check rules for path specific name
    return $data(..rules(path_"."_key)) = 1
}

Method countChars(
	string As %String,
	char As %String) As %Integer [ Private ]
{
    #dim count as %Integer = 0
    for i = 1:1:$length(string) {
        if ($extract(string, i) = char) {
            set count = count + 1
        }
    }
    return count
}

ClassMethod RemoveEx1()
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
    do ..Remove(json, ["", null, 1, {"foo": "FOO"}, "foo", [1,2], true, "bar"])

    zwrite json
}

ClassMethod RemoveEx2()
{
    #dim json as %DynamicObject = { 
        "a": {
            "b": {
                "c1": 1,
                "c2": 2,
                "foo": "foo"
            },
            "foo": "foo",
            "bar": "bar"
        },
        "bar": "bar"
    }
    zwrite json

    // foo is a generic name, so all foo names are removed everywhere
    // the other rules are fully qualified names, so they are removed only
    // from the specified path
    do ..Remove(json, ["foo",".a.b.c1",".bar"])

    zwrite json
}

ClassMethod RemoveEx3()
{
    #dim json as %DynamicObject = { 
        "a": [
            {
                "b": {
                    "c1": 1,
                    "c2": 1
                }
            },
            {
                "b": {
                    "c1": 2,
                    "c2": 2
                }
            },
            {
                "b": {
                    "c1": 3,
                    "c2": 3
                }
            }
        ]
    }
    zwrite json
    do ..Remove(json, [".a.[].b.c1"])
    zwrite json
}

ClassMethod CopyEx1()
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
