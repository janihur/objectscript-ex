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
	// TODO how to set the "original filename" so that %f specifier has 
	// effect in EnsLib.File.PassThroiughOperation ?
	// set exportRequest.OriginalFilename = "foo1"
	// do exportRequest.SetAttributes("OriginalFilename=foo1,Filename=foo2")
	set status = exportRequest.StreamSet(in)
	return:$$$ISERR(status) status
	
	#dim exportResponse as %Persistent = $$$NULLOREF
	
	set status = ..SendRequestSync("FileExport.Operations.Export",exportRequest,.exportResponse)
	
	return status
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}

