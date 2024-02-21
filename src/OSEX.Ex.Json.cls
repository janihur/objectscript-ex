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

}

