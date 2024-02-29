Class OSEX.IOP.Jokes.Messages.OperatingResponse Extends Ens.Response
{

Property Joke As %String(MAXLEN = "");

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

