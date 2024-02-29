Class OSEX.IOP.UniversalExports.Processes.Main Extends Ens.BusinessProcess [ ClassType = persistent ]
{

Method OnRequest(pRequest As OSEX.IOP.UniversalExports.Messages.BookExportRequest, Output pResponse As Ens.Response) As %Status
{
	$$$TRACE("(pRequest ((Book """_pRequest.Book_""")(Amount "_pRequest.Amount_")))")
	
	#dim status as %Status = $$$OK
	
	// 1/2 export -------------------------------------------------------------
	
	#dim exportResponse as OSEX.IOP.UniversalExports.Messages.ExportResponse = $$$NULLOREF
	set status = ..SendRequestSync("OSEX.IOP.UniversalExports.Operations.BookExport",pRequest,.exportResponse)

	return:$$$ISERR(status) status
	
	if ('$isobject(exportResponse)) {
		#dim details as %String = "Export response is not an object."
		#dim error = ##class(OSEX.IOP.UniversalExports.Error).Create(details)
		$$$LOGERROR(error.ExportToJson())
		return error.ExportToStatus()
	}

	// 2/2 import -------------------------------------------------------------
	
	set status = ..SendRequestSync("OSEX.IOP.UniversalExports.Operations.BookImport",.exportResponse,.pResponse)

	// ------------------------------------------------------------------------
	
	return status
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}

