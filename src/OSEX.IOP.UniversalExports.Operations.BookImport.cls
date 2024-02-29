Class OSEX.IOP.UniversalExports.Operations.BookImport Extends EnsLib.REST.Operation
{

Parameter INVOCATION = "Queue";

Method Import(request As OSEX.IOP.UniversalExports.Messages.ExportResponse, Output response As Ens.Response) As %Status
{
	#dim status as %Status = $$$OK

	try {
		#dim httpResponse as %Net.HttpResponse = $$$NULLOREF
		set status = ..Adapter.Post(.httpResponse,,request.Item)
		
		$$$TRACE("(status """_$$$StatusDisplayString(status)_""")")
		
		If ($$$ISERR(status) && $isobject(httpResponse) && $isobject(httpResponse.Data) && httpResponse.Data.Size) {
        	set status = $$$ERROR($$$EnsErrGeneral,$$$StatusDisplayString(status)_":"_httpResponse.Data.Read())
      	}
      	
      	quit:$$$ISERR(status)
      	
      	if ($isobject(httpResponse)) {
	      	$$$TRACE(##class(OSEX.IOP.UniversalExports.Util).HttpResponseToString(httpResponse))
      	}
	} catch {
		set status = $$$SystemError
	}
	
	return status
}

XData MessageMap
{
<MapItems>
  <MapItem MessageType="OSEX.IOP.UniversalExports.Messages.ExportResponse">
    <Method>Import</Method>
  </MapItem>
</MapItems>
}

}

