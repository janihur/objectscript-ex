Class OSEX.IOP.Jokes.Messages.OperatingRequest Extends Ens.Request
{

Property Amount As %Integer;

/*
Method %OnNew(amount As %Integer) As %Status [ Private, ServerOnly = 1 ]
{
    set ..Amount = amount
    return $$$OK
}
*/
Storage Default
{
<Data name="OperatingRequestDefaultData">
<Subscript>"OperatingRequest"</Subscript>
<Value name="1">
<Value>Amount</Value>
</Value>
</Data>
<DefaultData>OperatingRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}

