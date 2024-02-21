Class OSEX.IOP.Jokes.Operations.Simpsons Extends EnsLib.REST.Operation
{

Parameter INVOCATION = "Queue";

Method getJoke(request As OSEX.IOP.Jokes.Messages.OperatingRequest, Output response As OSEX.IOP.Jokes.Messages.OperatingResponse) As %Status
{
	#dim status as %Status = $$$OK
	
	try {
		if (request.Amount > 1) {
			set ..Adapter.URL = ..Adapter.URL_"?count="_request.Amount
		}
		
		$$$TRACE("(Adapter.URL """_..Adapter.URL_""")")
		
		#dim httpResponse as %Net.HttpResponse = $$$NULLOREF
		set status = ..Adapter.Get(.httpResponse)
		
		$$$TRACE("(status """_$$$StatusDisplayString(status)_""")")
		
		If ($$$ISERR(status) && $isobject(httpResponse) && $isobject(httpResponse.Data) && httpResponse.Data.Size) {
        	set status = $$$ERROR($$$EnsErrGeneral,$$$StatusDisplayString(status)_":"_httpResponse.Data.Read())
      	}
      	
      	quit:$$$ISERR(status)
      	
      	if ($isobject(httpResponse)) {
	      	$$$TRACE(..httpResponseToString(httpResponse))
	    	  	
	      	set response = ##class(OSEX.IOP.Jokes.Messages.OperatingResponse).%New()
	      	set response.Joke = ..readResponseData(httpResponse)
      	}
	} catch {
		set status = $$$SystemError
	}
	
	return status
}

ClassMethod httpResponseToString(httpResponse As %Net.HttpResponse) As %String [ Private ]
{
	#dim statusCode as %String = "(StatusCode "_httpResponse.StatusCode_")"
	#dim dataSize as %String = "(Data.Size "_httpResponse.Data.Size_")"
	#dim data as %String = "(Data TODO)"
	#dim contentType as %String = "(ContentType """_httpResponse.ContentType_""")"
	
	#dim headers as %String = "(Headers ("
	#dim key as %String = $order(httpResponse.Headers(""))
	while (key '= "") {
		#dim value as %String = $get(httpResponse.Headers(key))
		set headers = headers_"("_key_" """_value_""")"
		set key = $order(httpResponse.Headers(key))
	}
	set headers = headers_"))"
	
	return "(HttpResponse ("_headers_statusCode_contentType_dataSize_data_"))"
}

/// TODO string doesn't read everything
/// TODO use stream instead
ClassMethod readResponseData(response As %Net.HttpResponse, maxlen As %Integer = 32656) As %String [ Private ]
{
	#dim stringData As %String
	if ($isobject(response.Data)) {
		#dim streamData As %Stream = response.Data
		#dim dummy as %Status = streamData.Rewind()
		set stringData = streamData.Read(.maxlen)
	}
	else {
		set stringData = $extract(response.Data,0,maxlen)
	}
	return stringData
}

XData MessageMap
{
<MapItems>
  <MapItem MessageType="OSEX.IOP.Jokes.Messages.OperatingRequest">
    <Method>getJoke</Method>
  </MapItem>
</MapItems>
}

}

