/// <p><a href="https://en.wikipedia.org/wiki/Reflective_programming">Reflective programming</a></p>
/// <p><a href="https://docs.intersystems.com/irislatest/csp/docbook/DocBook.UI.Page.cls?KEY=GOBJ_dictionary">Using the %Dictionary Classes</a></p>
Class OSEX.Ex.Reflection
{

ClassMethod Ex1()
{
	#define PrintError(%status) do:($$$ISERR(%status)) $system.Status.DisplayError(%status)

	// ------------------------------------------------------------------------
	// 1/3 create the class

	set packageName = "OSEX"
	set className = "Generated1"
	set fqcn = packageName_"."_className

	set classDefinition = ##class(%Dictionary.ClassDefinition).%New(fqcn)
	set classDefinition.Description = "A demo class created runtime."
	set classDefinition.Super = "%RegisteredObject"

	// properties -------------------------------------------------------------

	set propertyDefinition = ##class(%Dictionary.PropertyDefinition).%New(className_":Foo")
	set propertyDefinition.Description = "A demo property created runtime."
	set propertyDefinition.Type = "%String"

	set status = classDefinition.Properties.Insert(propertyDefinition)
	$$$PrintError(status)

	// methods ----------------------------------------------------------------

	set methodDefinition = ##class(%Dictionary.MethodDefinition).%New(className_":GetGreeting")
	set methodDefinition.Description = "A demo method created runtime giving you ""Hello"" string."
	set methodDefinition.ReturnType = "%String"

	set methodDefinition.Implementation = ##class(%Stream.TmpCharacter).%New()
	// note the first character needs to be a tab
	do methodDefinition.Implementation.Write("	return ""Hello, "" _ ..Foo _ ""!""")

	set status = classDefinition.Methods.Insert(methodDefinition)
	$$$PrintError(status)

	// ------------------------------------------------------------------------

	set status = classDefinition.%Save()
	$$$PrintError(status)

	set status = $system.OBJ.Compile(fqcn, "/display=none")
	$$$PrintError(status)

	// ------------------------------------------------------------------------
	// 2/3 use the class

	set obj1 = ##class(OSEX.Generated1).%New()
	set obj1.Foo = "Object ONE"
	#; zwrite obj1
	write obj1.GetGreeting(),!

	set obj2 = $classmethod(fqcn, "%New")
	set obj2.Foo = "Object TWO"
	#; zwrite obj2
	write obj2.GetGreeting(),!

	// ------------------------------------------------------------------------
	// 3/3 delete the class

	set status = $system.OBJ.Delete(fqcn, "/display=none")
	$$$PrintError(status)
}

}
