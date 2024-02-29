Class OSEX.IOP.UniversalExports.Util Extends %RegisteredObject
{

ClassMethod HttpResponseToString(httpResponse As %Net.HttpResponse, showData As %Boolean = 0) As %String
{
	#dim isDataObject as %Boolean = $isobject(httpResponse.Data)
	
	#dim statusCode as %String = "(StatusCode "_httpResponse.StatusCode_")"
	#dim dataIsObject as %String = "(Data ($isobject "_isDataObject_")"")"
	
	#dim dataClassname as %String = ""
	#dim dataSize as %String = ""
	#dim dataData as %String = ""
	
	if (isDataObject) {
		set dataClassname = "(Data ($classname """_$classname(httpResponse.Data)_"""))"
		set dataSize = "(Data (Size "_httpResponse.Data.Size_"))"
		if (showData) {
			set dataData = "(Data "_httpResponse.Data_")"
		}
	}
	
	#dim contentType as %String = "(ContentType """_httpResponse.ContentType_""")"
	
	#dim headers as %String = "(Headers ("
	#dim key as %String = $order(httpResponse.Headers(""))
	while (key '= "") {
		#dim value as %String = $get(httpResponse.Headers(key))
		set headers = headers_"("_key_" """_value_""")"
		set key = $order(httpResponse.Headers(key))
	}
	set headers = headers_"))"
	
	return "(HttpResponse ("_headers_statusCode_contentType_dataIsObject_dataClassname_dataSize_dataData_"))"
}

}

