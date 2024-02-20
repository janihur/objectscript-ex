Class OSEX.IOP.Jokes.Messages.OperatingResponse Extends Ens.Response
{

Property Joke As %String(MAXLEN = "");

/*
Method %OnNew(joke As %String) As %Status [ Private, ServerOnly = 1 ]
{
	set ..Joke = joke
    return $$$OK
}
*/
Storage Default
{
<Data name="OperatingResponseDefaultData">
<Subscript>"OperatingResponse"</Subscript>
<Value name="1">
<Value>Joke</Value>
</Value>
</Data>
<DefaultData>OperatingResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}

