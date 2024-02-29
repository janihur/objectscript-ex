Class OSEX.IOP.Jokes.Operations.Simpsons Extends EnsLib.REST.Operation
{

Parameter INVOCATION = "Queue";

Method GetJoke(request As OSEX.IOP.Jokes.Messages.OperatingRequest, Output response As OSEX.IOP.Jokes.Messages.OperatingResponse) As %Status
{
	#dim status as %Status = $$$OK
	
	try {
		#dim url as %String = ..Adapter.URL
		if (request.Amount > 1) {
			set url = url_"?count="_request.Amount
		}
		
		$$$TRACE("(url """_url_""")")

		#dim httpResponse as %Net.HttpResponse = $$$NULLOREF
		set status = ..Adapter.GetURL(url,.httpResponse)
		
		$$$TRACE("(status """_$$$StatusDisplayString(status)_""")")
		
		If ($$$ISERR(status) && $isobject(httpResponse) && $isobject(httpResponse.Data) && httpResponse.Data.Size) {
        	set status = $$$ERROR($$$EnsErrGeneral,$$$StatusDisplayString(status)_":"_httpResponse.Data.Read())
      	}
      	
      	quit:$$$ISERR(status)
      	
      	if ($isobject(httpResponse)) {
	      	$$$TRACE(##class(OSEX.IOP.Jokes.Util).HttpResponseToString(httpResponse))
	      	set response = ##class(OSEX.IOP.Jokes.Messages.OperatingResponse).%New()
	      	set response.Joke = ##class(OSEX.IOP.Jokes.Util).ReadHttpResponseData(httpResponse)
      	}
	} catch {
		set status = $$$SystemError
	}
	
	return status
}

XData MessageMap
{
<MapItems>
  <MapItem MessageType="OSEX.IOP.Jokes.Messages.OperatingRequest">
    <Method>GetJoke</Method>
  </MapItem>
</MapItems>
}

}

