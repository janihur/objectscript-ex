Class OSEX.StyleGuide
{

ClassMethod Dim()
{
        // WRONG: a variable should be declared with an intended data type
        set a = "A"

        // RIGHT
        #dim b as %String = "B"
        
        // WRONG: the intended data type is not specified
        #dim c = "C"
        
        // RIGHT
        #dim d as %String
        set d = "D"

        // WRONG: the intended data type is not specified
        #dim e
        set e = "E"
        
        // RIGHT: #dim not required when creating a new object (%New())
        set f1 = ##class(%DynamicObject).%New()

        // RIGHT: but redundant
        #dim f2 as %DynamicObject = ##class(%DynamicObject).%New()

        // RIGHT: but redundant
        #dim f3 as %DynamicObject
        set f3 = ##class(%DynamicObject).%New()

        // RIGHT: #dim not required when opening an existing object (%OpenId())
        set g1 = ##class(%Dictionary.ClassDefinition).%OpenId("%Dictionary.ClassDefinition")

        // RIGHT: but redundant
        #dim g2 as %Dictionary.ClassDefinition = ##class(%Dictionary.ClassDefinition).%OpenId("%Dictionary.ClassDefinition")

        // RIGHT: but redundant
        #dim g3 as %Dictionary.ClassDefinition
        set g3 = ##class(%Dictionary.ClassDefinition).%OpenId("%Dictionary.ClassDefinition")

        // RIGHT: multidimensional array
        #dim h // md
        set h(1,1) = "H"
        
        write
}

}
