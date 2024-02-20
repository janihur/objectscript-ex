Class OSEX.IOP.Jokes.Messages.ProcessingResponse Extends Ens.Response
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
<Data name="ProcessingResponseDefaultData">
<Subscript>"ProcessingResponse"</Subscript>
<Value name="1">
<Value>Joke</Value>
</Value>
<Value name="2">
<Value>Ok</Value>
</Value>
</Data>
<DefaultData>ProcessingResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}

