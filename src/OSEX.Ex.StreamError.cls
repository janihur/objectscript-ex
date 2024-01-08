/// Example of an user defined error.
Class OSEX.Ex.StreamError Extends %Exception.AbstractException
{

Property CauseStatus As %Status;

Property StackTrace As %String;

Method DisplayString(pLevel As %Integer = 0) As %String
{
	// TODO InnerException
	// https://docs.intersystems.com/irislatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25Exception.CPPException#PROPERTY_Name
	#dim str as %String = ..kvs("exception", $classname())
	set str = str_..kvs("name", ..Name)
	set str = str_..kvs("code", ..Code)
	set str = str_..kvs("location", ..Location)
	set str = str_..kvs("data", ..Data)
	set str = str_..kvs("stackTrace", ..StackTrace)
	set str = str_..kv("causeStatus", ..statusToString(..CauseStatus))
	// set str = str_##super() // example how to call superclass' method
	return str
}

ClassMethod statusToString(status As %Status) As %String [ Private ]
{
	#dim str as %String = ..kvs("errorCodes", $system.Status.GetErrorCodes(status))
	set str = str_..kvs("errorText", $system.Status.GetErrorText(status))
	return str
}

/// key-value where value is other key-value pair
ClassMethod kv(key As %String, value As %String) As %String [ Private ]
{
	return "("_key_" "_value_")"
}

/// key-value where value is string
ClassMethod kvs(key As %String, value As %String) As %String [ Private ]
{
	return "("_key_" "_""""_value_""")"
}

}

