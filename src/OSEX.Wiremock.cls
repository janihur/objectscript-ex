Class OSEX.Wiremock Extends %RegisteredObject
{

Property Host As %String(MAXLEN = "");

Property Port As %Integer;

Method %OnNew(host As %String = "host.docker.internal", port As %Integer = 8080) As %Status [ Private, ServerOnly = 1 ]
{
	set ..Host = host
	set ..Port = port
	
	return $$$OK
}

Method Health() As %Boolean
{
	#dim req as %Net.HttpRequest = ..createHttpRequest()
	$$$ThrowOnError(req.Get("/__admin/health"))
	
	if ((req.HttpResponse.StatusCode = 200) && ($isobject(req.HttpResponse.Data)) && (req.HttpResponse.Data.Size > 0) ) {
		#dim json as %DynamicObject = {}.%FromJSON(req.HttpResponse.Data.Read())
		return (json.status = "healthy")
	}

	return 0
}

Method ResetMappings()
{
	#dim req as %Net.HttpRequest = ..createHttpRequest()
	$$$ThrowOnError(req.Post("/__admin/mappings/reset"))
}

Method AddMappings(filepath As %String)
{
	#dim file = ##class(%Stream.FileCharacter).%New()
	set file.TranslateTable = "UTF8"
	$$$ThrowOnError(file.LinkToFile(filepath))

	#dim req as %Net.HttpRequest = ..createHttpRequest()
	set req.ContentType = "application/json"
	$$$ThrowOnError(req.EntityBody.CopyFrom(file))
	$$$ThrowOnError(req.Post("/__admin/mappings/import"))
}

Method createHttpRequest() As %Net.HttpRequest [ Private ]
{
	#dim req = ##class(%Net.HttpRequest).%New()
	set req.Server = ..Host
	set req.Port = ..Port
	return req
}

}

