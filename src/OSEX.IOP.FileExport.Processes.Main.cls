Class OSEX.IOP.FileExport.Processes.Main Extends Ens.BusinessProcess
{

Method OnRequest(pRequest As OSEX.IOP.FileExport.Messages.ExportRequest, Output pResponse As Ens.Response) As %Status
{
	$$$TRACE("(pRequest ((Filename """_pRequest.Filename_""")))")
	
	#dim status as %Status = $$$OK
	
	#dim in = ##class(%Stream.FileCharacter).%New()
	set in.TranslateTable = "UTF8"
	set status = in.LinkToFile(pRequest.Filename)
	return:$$$ISERR(status) status
	
	#dim exportRequest = ##class(Ens.StreamContainer).%New()
	set status = exportRequest.StreamSet(in)
	return:$$$ISERR(status) status
	// has to be after StreamSet() which sets OriginalFilename to ""
	// this is the property that controls %f specifier
	set exportRequest.OriginalFilename = "foo"
	
	#dim exportResponse as %Persistent = $$$NULLOREF
	
	set status = ..SendRequestSync("FileExport.Operations.Export",exportRequest,.exportResponse)
	
	return status
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}

