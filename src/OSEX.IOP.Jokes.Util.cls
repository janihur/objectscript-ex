Class OSEX.IOP.Jokes.Util Extends %RegisteredObject
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

/// String doesn't read everything but in this application the arbitrary string max length is good enough.
/// For big payloads one should use streams instead.
/// String length limit is 3,641,144 characters
/// https://docs.intersystems.com/irislatest/csp/docbook/DocBook.UI.Page.cls?KEY=RCOS_appx_limits#RCOS_appx_limits_string_length
ClassMethod ReadHttpResponseData(response As %Net.HttpResponse, maxlen As %Integer = 32656) As %String
{
	#dim stringData As %String = ""
	if ($isobject(response.Data)) {
		#dim streamData As %Stream = response.Data
		#dim dummy as %Status = streamData.Rewind()
		set stringData = streamData.Read(.maxlen)
	}
	else {
		set stringData = $extract(response.Data,0,maxlen)
	}
	return stringData
}

}

