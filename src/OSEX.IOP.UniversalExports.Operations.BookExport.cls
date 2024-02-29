Class OSEX.IOP.UniversalExports.Operations.BookExport Extends EnsLib.REST.Operation
{

Parameter INVOCATION = "Queue";

Method Export(request As OSEX.IOP.UniversalExports.Messages.BookExportRequest, Output response As OSEX.IOP.UniversalExports.Messages.ExportResponse) As %Status
{
	#dim status as %Status = $$$OK

	try {
		#dim url as %String = ..Adapter.URL
		if (request.Amount > 1) {
			set url = url_"?count="_request.Amount
		}
		
		$$$TRACE("(url """_url_""")")
		
		#dim httpResponse as %Net.HttpResponse = $$$NULLOREF
		set status = ..Adapter.GetURL(url, .httpResponse)
		
		$$$TRACE("(status """_$$$StatusDisplayString(status)_""")")
		
		If ($$$ISERR(status) && $isobject(httpResponse) && $isobject(httpResponse.Data) && httpResponse.Data.Size) {
        	set status = $$$ERROR($$$EnsErrGeneral,$$$StatusDisplayString(status)_":"_httpResponse.Data.Read())
      	}
      	
      	quit:$$$ISERR(status)
      	
      	if ($isobject(httpResponse)) {
	      	$$$TRACE(##class(OSEX.IOP.UniversalExports.Util).HttpResponseToString(httpResponse))
	      	set response = ##class(OSEX.IOP.UniversalExports.Messages.ExportResponse).%New()
	      	do response.Item.CopyFrom(httpResponse.Data)
      	}
	} catch {
		set status = $$$SystemError
	}
	
	return status
}

XData MessageMap
{
<MapItems>
  <MapItem MessageType="OSEX.IOP.UniversalExports.Messages.BookExportRequest">
    <Method>Export</Method>
  </MapItem>
</MapItems>
}

}

