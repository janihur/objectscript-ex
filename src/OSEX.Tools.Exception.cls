Class OSEX.Tools.Exception Extends %Exception.AbstractException
{

Property Message As %String(MAXLEN = "");

Property cause As %Status [ Private ];

ClassMethod Create(
	message As %String,
	cause As %Status = {$$$OK}) As OSEX.Tools.Exception
{
	set ex = ##class(OSEX.Tools.Exception).%New()
	set ex.Message = message
	set ex.cause = cause
	return ex
}

Method %OnNew() As %Status [ Private ]
{
	set ..Code = 5001
	set ..Name = $classname()
	return $$$OK
}

}
