Class OSEX.IOP.UniversalExports.Runner Extends %RegisteredObject
{

ClassMethod Run(book As %String = "kalevala", amount As %Integer = 1) As %Status
{
	#dim status as %Status

	#dim service as OSEX.IOP.UniversalExports.Services.Main
	$$$THROWONERROR(status, ##class(Ens.Director).CreateBusinessService("OSEX.IOP.UniversalExports.Services.Main",.service))
	
	#dim request = ##class(OSEX.IOP.UniversalExports.Messages.BookExportRequest).%New()
	set request.Book = book
	set request.Amount = amount
	
	#dim response as Ens.Response = $$$NULLOREF
	set status = service.ProcessInput(request,.response)
	
	#dim statusDetails // md
	do $system.Status.DecomposeStatus(status, .statusDetails)
	
	if ($system.Status.IsOK(status)) {
		write "OK",!
	} else { // error
		if (##class(OSEX.IOP.UniversalExports.Error).IsStatusContainsError(status)) {
			write !,"OSEX.IOP.UniversalExports.Error:",!
			#dim errorStatus = ##class(OSEX.IOP.UniversalExports.Error).UnwrapStatusError(status)
			write ##class(OSEX.IOP.UniversalExports.Error).CreateFromStatus(errorStatus).ExportToJson()
		} else {
			write !,"Other error:",!
			write $system.Status.GetErrorCodes(status),!
			write $system.Status.GetErrorText(status)
		}
	}
	
	return status
}

}

