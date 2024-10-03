Class OSEX.Ex.Json Extends %RegisteredObject
{

ClassMethod Ex1()
{
	#dim json1 as %DynamicArray = [{"quote":"For once maybe someone will call me \"sir\" without adding, \"You're making a scene.\"","character":"Homer Simpson","image":"https://cdn.glitch.com/3c3ffadc-3406-4440-bb95-d40ec8fcde72%2FHomerSimpson.png?1497567511939","characterDirection":"Right"},{"quote":"In theory, Communism works! In theory.","character":"Homer Simpson","image":"https://cdn.glitch.com/3c3ffadc-3406-4440-bb95-d40ec8fcde72%2FHomerSimpson.png?1497567511939","characterDirection":"Right"}]
	zwrite json1
	
	#dim json2 as %DynamicObject = { "jokes": [] }
	zwrite json2
	
	#dim json1Iter as %Iterator.Array = json1.%GetIterator()
	#dim index as %Integer
	#dim object as %DynamicObject = $$$NULLOREF
	while (json1Iter.%GetNext(.index, .object)) {
		//zwrite index
		//zwrite object
		do json2.jokes.%Push(object)
	}
	
	zwrite json2
}

ClassMethod Ex2()
{
	#dim json as %DynamicObject = { "list": ["foo","bar"] }
	
	#dim list as %DynamicArray = json.list

	if ($isobject(list)) {
		write "list exists",!
	} else {
		write "no list",!
		return
	}
	
	#dim iter as %Iterator.Array = list.%GetIterator()
	
	zw iter
	
	#dim index as %Integer
	#dim value as %String = ""
	while (iter.%GetNext(.index, .value)) {
		zw index
		zw value
	}
}

ClassMethod Ex3()
{
	set iter = [ { "first": "one" }, { "second": "two" } ].%GetIterator()
	while (iter.%GetNext(.key, .value)) {
		#dim iter2 as %Iterator.Object = value.%GetIterator()
		while (iter2.%GetNext(.key, .value)) {
			write "((key """,key,""")(value """,value,"""))",!
		}
	}
}

ClassMethod Ex4()
{
	#dim json as %DynamicObject = { 
		"array": ["foo","bar"],
		"boolean": true,
		"null": null,
		"number": 42,
		"object": { "key": "value" },
		"string": "string"
	}
	
	#dim iter as %Iterator.Object = json.%GetIterator()
	
	#dim key as %String = ""
	#dim value // any
	#dim type as %String = ""
	while (iter.%GetNext(.key, .value, .type)) {
		write "---",!
		write "(key "_key_")(value "_value_")(type "_type_")",!
		// two ways to check for object
		if ($isobject(value)) {
			write "isobject()    check: ",value.%ToJSON(),!
		}
		if ((type = "array")||(type = "object")) {
			write "type variable check: ",value.%ToJSON(),!
		}
	}
}

}
