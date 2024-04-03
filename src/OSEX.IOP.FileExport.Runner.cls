Class OSEX.IOP.FileExport.Runner Extends %RegisteredObject
{

ClassMethod Run(filename As %String) As %Status
{
	#dim status as %Status = $$$OK

	#dim service as OSEX.IOP.FileExport.Services.Main
	$$$THROWONERROR(status, ##class(Ens.Director).CreateBusinessService("FileExport.Services.Main",.service))
	
	#dim request = ##class(OSEX.IOP.FileExport.Messages.ExportRequest).%New()
	set request.Filename = filename
	
	#dim response as Ens.Response = $$$NULLOREF
	set status = service.ProcessInput(request,.response)
	
	#dim statusDetails // md
	do $system.Status.DecomposeStatus(status, .statusDetails)
	
	if ($system.Status.IsOK(status)) {
		write "OK",!
	} else { // error
		write !,"Error:",!
		write $system.Status.GetErrorCodes(status),!
		write $system.Status.GetErrorText(status)
	}

	return status
}

}

