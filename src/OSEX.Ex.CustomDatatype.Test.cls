Class OSEX.Ex.CustomDatatype.Test Extends %RegisteredObject
{

Property FixedStr As OSEX.Ex.CustomDatatype.FixedString(MAXLEN = 8);

ClassMethod Create(str As %String) As OSEX.Ex.CustomDatatype.Test
{
	set obj = ##class(OSEX.Ex.CustomDatatype.Test).%New()
	set obj.FixedStr = str
	return obj
}

}
