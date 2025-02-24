Class OSEX.db1.Foo Extends %Persistent [ DdlAllowed ]
{

Property num As %Integer [ Required ];

Property str As %String [ Required ];

/// metadata
Property createdAt As %DateTime [ InitialExpression = {$zdatetime($horolog,3,1)} ];

/// metadata
Property updatedAt As %DateTime;

/// metadata
Property saveCounter As %Integer [ InitialExpression = 0 ];

Index strIndex On str [ Unique ];

Method %OnAddToSaveSet(
	depth As %Integer,
	insert As %Integer,
	callcount As %Integer) As %Status [ Private, ServerOnly = 1 ]
{
	set ..saveCounter = ..saveCounter + 1
	set ..updatedAt = $zdatetime($horolog,3,1)

	return $$$OK
}

/// Defining and Using Stored Procedures
/// https://docs.intersystems.com/irislatest/csp/docbook/Doc.View.cls?KEY=GSQL_procedures
ClassMethod Upsert(
	num As %Integer,
	str As %String) As %Status [ SqlProc ]
{
	set o = ##class(OSEX.db1.Foo).strIndexOpen(str)
	if ($isobject(o)) {
		set o.num = o.num + 1
		return o.%Save()
	} else {
		set o = ##class(OSEX.db1.Foo).%New()
		set o.num = num
		set o.str = "A"
		return o.%Save()
	}
}

Storage Default
{
<Data name="FooDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>num</Value>
</Value>
<Value name="3">
<Value>str</Value>
</Value>
<Value name="4">
<Value>createdAt</Value>
</Value>
<Value name="5">
<Value>updatedAt</Value>
</Value>
<Value name="6">
<Value>saveCounter</Value>
</Value>
</Data>
<DataLocation>^OSEX.db1.FooD</DataLocation>
<DefaultData>FooDefaultData</DefaultData>
<IdLocation>^OSEX.db1.FooD</IdLocation>
<IndexLocation>^OSEX.db1.FooI</IndexLocation>
<StreamLocation>^OSEX.db1.FooS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
