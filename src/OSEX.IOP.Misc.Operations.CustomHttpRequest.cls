/// how to use custom http request operation
/// forget other methods but always prefer SendFormDataArray()
Class OSEX.IOP.Misc.Operations.CustomHttpRequest Extends EnsLib.REST.Operation
{

Parameter INVOCATION = "Queue";

Method Call(request As Ens.Request, Output response As Ens.Response) As %Status
{
    $$$TRACE("OSEX.IOP.Misc.Operations.CustomHttpRequest.Call()")

    // example json payload ---------------------------------------------------

    set payload = ##class(%Stream.GlobalCharacter).%New()
    #dim json as %DynamicObject = {"payload": "Hello, World!"}
    do json.%ToJSON(payload)
    
    // custom http request -----------------------------------------------------
    #dim httpRequest as %Net.HttpRequest = ##class(%Net.HttpRequest).%New()

    #dim status as %Status = httpRequest.EntityBody.CopyFrom(payload)
    $$$TRACE("(status """_$$$StatusDisplayString(status)_""")")
    return:$$$ISERR(status) status

    // standard headers are properties
    set httpRequest.ContentType = "application/json"
    set httpRequest.ContentCharset = "UTF-8"

    // customer headers (ignoring %Status return value)
    do httpRequest.SetHeader("X-Clacks-Overhead","GNU Terry Pratchett")

    // make the request --------------------------------------------------------

	#dim httpResponse as %Net.HttpResponse = $$$NULLOREF

    set status = ..Adapter.SendFormDataArray(.httpResponse,"POST",httpRequest)
		
	$$$TRACE("(status """_$$$StatusDisplayString(status)_""")")
    $$$TRACE("(httpResponse "_..HttpResponseToString(httpResponse,1)_")")

    // ------------------------------------------------------------------------

    return status
}

ClassMethod HttpResponseToString(httpResponse As %Net.HttpResponse, showData As %Boolean = 0) As %String
{
	#dim isDataObject as %Boolean = $isobject(httpResponse.Data)
	
	#dim statusCode as %String = "(StatusCode "_httpResponse.StatusCode_")"
	#dim dataIsObject as %String = "(Data ($isobject "_isDataObject_")"")"
	
	#dim dataClassname as %String = ""
	#dim dataSize as %String = ""
	#dim dataData as %String = ""
	
	if (isDataObject) {
		set dataClassname = "(Data ($classname """_$classname(httpResponse.Data)_"""))"
		set dataSize = "(Data (Size "_httpResponse.Data.Size_"))"
		if (showData) {
			set dataData = "(Data "_httpResponse.Data_")"
		}
	}
	
	#dim contentType as %String = "(ContentType """_httpResponse.ContentType_""")"
	
	#dim headers as %String = "(Headers ("
	#dim key as %String = $order(httpResponse.Headers(""))
	while (key '= "") {
		#dim value as %String = $get(httpResponse.Headers(key))
		set headers = headers_"("_key_" """_value_""")"
		set key = $order(httpResponse.Headers(key))
	}
	set headers = headers_"))"
	
	return "(HttpResponse ("_headers_statusCode_contentType_dataIsObject_dataClassname_dataSize_dataData_"))"
}

XData MessageMap
{
<MapItems>
  <MapItem MessageType="Ens.Request">
    <Method>Call</Method>
  </MapItem>
</MapItems>
}

}
