Class OSEX.IOP.Jokes.Operations.ChuckNorris Extends EnsLib.REST.Operation
{

Parameter INVOCATION = "Queue";

Method GetJoke(request As OSEX.IOP.Jokes.Messages.OperatingRequest, Output response As OSEX.IOP.Jokes.Messages.OperatingResponse) As %Status
{
	#dim status as %Status = $$$OK
	
	try {
		#dim responseDynA as %DynamicArray = []
	
		#dim count as %Integer
		for count=1:1:request.Amount {
			#dim httpResponse as %Net.HttpResponse = $$$NULLOREF
			set status = ..Adapter.Get(.httpResponse)
		
			$$$TRACE("((count "_count_")(status """_$$$StatusDisplayString(status)_"""))")
		
			If ($$$ISERR(status) && $isobject(httpResponse) && $isobject(httpResponse.Data) && httpResponse.Data.Size) {
        		set status = $$$ERROR($$$EnsErrGeneral,$$$StatusDisplayString(status)_":"_httpResponse.Data.Read())
      		}
      	
      		// TODO do we quit the loop here only? use return instead? will responseDynA leak?
      		quit:$$$ISERR(status)
      	
      		if ($isobject(httpResponse)) {
	      		$$$TRACE("((count "_count_")"_##class(OSEX.IOP.Jokes.Util).HttpResponseToString(httpResponse)_")")
	      		do responseDynA.%Push({}.%FromJSON(##class(OSEX.IOP.Jokes.Util).ReadHttpResponseData(httpResponse)))
      		}
		}

		set response = ##class(OSEX.IOP.Jokes.Messages.OperatingResponse).%New()
		set response.Joke = responseDynA.%ToJSON()
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

