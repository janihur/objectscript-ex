Class OSEX.ipm.numbers.Random Extends %RegisteredObject
{

Property upperLimit As %Integer [ Private ];

Method %OnNew(upperLimit As %Integer = 100) As %Status
{
	set ..upperLimit = upperLimit
	return $$$OK
}

Method Rand() As %Integer
{
	return $random(..upperLimit)
}

}
