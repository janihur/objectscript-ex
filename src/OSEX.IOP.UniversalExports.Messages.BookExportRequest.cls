Class OSEX.IOP.UniversalExports.Messages.BookExportRequest Extends Ens.Request
{

Property Book As %String(MAXLEN = "");

Property Amount As %Integer;

Storage Default
{
<Data name="BookExportRequestDefaultData">
<Subscript>"BookExportRequest"</Subscript>
<Value name="1">
<Value>Book</Value>
</Value>
<Value name="2">
<Value>Amount</Value>
</Value>
</Data>
<DefaultData>BookExportRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}

