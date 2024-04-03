Class OSEX.IOP.FileExport.Messages.ExportRequest Extends Ens.Request
{

Property Filename As %String(MAXLEN = "");

Storage Default
{
<Data name="ExportRequestDefaultData">
<Subscript>"ExportRequest"</Subscript>
<Value name="1">
<Value>Filename</Value>
</Value>
</Data>
<DefaultData>ExportRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}

