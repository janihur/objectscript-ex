Class OSEX.IOP.Jokes.Runner Extends %RegisteredObject
{

ClassMethod Run(family As %String = "simpsons", amount As %Integer = 1) As %Status
{
	#dim status as %Status

	#dim service as OSEX.IOP.Jokes.Services.Main
	$$$THROWONERROR(status, ##class(Ens.Director).CreateBusinessService("Jokes.Services.Main",.service))
	
	#dim request = ##class(OSEX.IOP.Jokes.Messages.ProcessingRequest).%New()
	set request.Family = family
	set request.Amount = amount
	
	#dim response as OSEX.IOP.Jokes.Messages.ProcessingResponse = $$$NULLOREF
	set status = service.ProcessInput(request,.response)
	
	#dim statusDetails // md
	do $system.Status.DecomposeStatus(status, .statusDetails)
	
	if ($system.Status.IsOK(status)) {
		write "OK:",!
		write response.Joke
	} else { // error
		if (##class(OSEX.IOP.Jokes.Error).IsStatusContainsError(status)) {
			write !,"OSEX.IOP.Jokes.Error:",!
			#dim errorStatus = ##class(OSEX.IOP.Jokes.Error).UnwrapStatusError(status)
			write ##class(OSEX.IOP.Jokes.Error).CreateFromStatus(errorStatus).ExportToJson()
		} else {
			write !,"Other error:",!
			write $system.Status.GetErrorCodes(status),!
			write $system.Status.GetErrorText(status)
		}
	}
	
	return status
}

}
