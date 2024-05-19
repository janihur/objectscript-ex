/// hello world as an object
/// usage:
/// NAMESPACE>set obj=##class(OSEX.Hello2).%New()
/// NAMESPACE>do obj.Hello()
Class OSEX.Hello2 Extends %RegisteredObject
{

Parameter GREETING = "Hello";

Property Name As %String [ InitialExpression = "World", Private ];

Method %OnNew(name As %String = "") As %Status
{
    if (name '= "") {
        set ..Name = name
    }

    return $$$OK
}

/// Description
Method Hello()
{
        write ..#GREETING, ", ", ..Name, "!",!
}

}
