Class OSEX.IOP.Jokes.Processes.Main Extends Ens.BusinessProcess [ ClassType = persistent ]
{

Method OnRequest(pRequest As OSEX.IOP.Jokes.Messages.ProcessingRequest, Output pResponse As OSEX.IOP.Jokes.Messages.ProcessingResponse) As %Status
{
	$$$TRACE("(pRequest ((family """_pRequest.Family_""")(amount "_pRequest.Amount_")))")

	#dim status as %Status = $$$OK
	
	set pRequest.Family = $zconvert(pRequest.Family,"L")

	set status = ..validateFamily(pRequest.Family)
	return:$$$ISERR(status) status
	set status = ..validateAmount(pRequest.Amount)
	return:$$$ISERR(status) status
	
	// TODO generalize dispatch && response processing
	
	#dim opRequest = ##class(OSEX.IOP.Jokes.Messages.OperatingRequest).%New()
	#dim opResponse as OSEX.IOP.Jokes.Messages.OperatingResponse = $$$NULLOREF
	
	#dim opResponseDynO as %DynamicObject = $$$NULLOREF
	#dim responseDynO as %DynamicObject = $$$NULLOREF
	
	if (pRequest.Family = "simpsons") {
		set opRequest.Amount = pRequest.Amount
		
		set status = ..SendRequestSync("OSEX.IOP.Jokes.Operations.Simpsons",opRequest,.opResponse)
		
		if ('$$$ISERR(status) && $isobject(opResponse)) {
			set opResponseDynO = {}.%FromJSON(opResponse.Joke)
			set responseDynO = { "family": (pRequest.Family), "text": (opResponseDynO."0".quote) }
			set pResponse = ##class(OSEX.IOP.Jokes.Messages.ProcessingResponse).%New()
			set pResponse.Joke = responseDynO.%ToJSON()
		}
	} elseif (pRequest.Family = "chucknorris") {
		set opRequest.Amount = pRequest.Amount
		
		set status = ..SendRequestSync("OSEX.IOP.Jokes.Operations.ChuckNorris",opRequest,.opResponse)
		
		if ('$$$ISERR(status) && $isobject(opResponse)) {
			set opResponseDynO = {}.%FromJSON(opResponse.Joke)
			set responseDynO = { "family": (pRequest.Family), "text": (opResponseDynO.value) }
			set pResponse = ##class(OSEX.IOP.Jokes.Messages.ProcessingResponse).%New()
			set pResponse.Joke = responseDynO.%ToJSON()
		}
	} else {
		// unimplemented on purpose
		#dim error = ##class(OSEX.IOP.Jokes.Error).Create("Not implemented yet. Family: "_pRequest.Family)
		$$$LOGERROR(error.ExportToJson())
		set status = error.ExportToStatus()
	}
	
	return status
}

Method validateAmount(amount As %Integer) As %Status [ Private ]
{
	if (amount < 1) {
		#dim details as %String = "Invalid amount: "_amount_". Valid amount > 0."
		#dim error = ##class(OSEX.IOP.Jokes.Error).Create(details)
		$$$LOGERROR(error.ExportToJson())
		return error.ExportToStatus()
	}
	
	return $$$OK
}

Method validateFamily(family As %String) As %Status [ Private ]
{
	if ((family '= "baconipsum") && (family '= "chucknorris") && (family '= "simpsons")) {
		#dim details as %String = "Invalid family: "_family_". Valid families: ""baconipsum"", ""chucknorris"", ""simpsons""."
		#dim error = ##class(OSEX.IOP.Jokes.Error).Create(details)
		$$$LOGERROR(error.ExportToJson())
		return error.ExportToStatus()
	}
	
	return $$$OK
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}

