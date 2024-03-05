Class OSEX.IOP.UniversalExports.Util Extends %RegisteredObject
{

ClassMethod configureService(domain As %String, serviceJson As %DynamicObject) As %Status [ Private ]
{
	#dim status as %Status = $$$OK
	
	// service ----------------------------------------------------------------
	
	#dim service = ##class(%ZEN.proxyObject).%New()
	set service.Name = serviceJson.name
	set service.Domain = domain
	set service.Version = "1"
	set service.Endpoint = serviceJson.endpoint
	set service.Protocol = "REST"
	set service.ResponseStyle = "Sync"
	set service.Stage = "Live"
	
	set status = ##class(Ens.ServiceRegistry.External.API).SaveService(service)
  	if ($$$ISERR(status)) {
		// do $system.Status.DisplayError(status)
		return status
	}
	
	// attributes -------------------------------------------------------------
	
	#dim attributesJson as %DynamicObject = serviceJson.attributes
	
	if (attributesJson '= $$$NULLOREF) {
		#dim serviceId as %String = service.Name_"||"_service.Domain_"||"_service.Version
		#dim attributesIter as %Iterator.Object = attributesJson.%GetIterator()
		#dim key as %String = ""
		#dim value as %String = ""
		while (attributesIter.%GetNext(.key,.value)) {
			#dim attribute = ##class(%ZEN.proxyObject).%New()
			set attribute.Service = serviceId
			set attribute.Name = key
			set attribute.Value = value
			
			set status = ##class(Ens.ServiceRegistry.External.API).SaveAttribute(attribute)
		  	if ($$$ISERR(status)) {
				// do $system.Status.DisplayError(status)
				return status
			}
		}
	}
	
	// ------------------------------------------------------------------------
	
	return status
}

/// external-service registry configuration from json configuration file
/// configuration file contains only values that can change
/// fixed values are hardcoded here
/// doesn't delete services/attributes
ClassMethod Configure(path As %String) As %Status
{
	#dim status as %Status = $$$OK
	
	#dim configFileStream as %Stream = ##class(%Stream.FileCharacter).%New()
	
  	set status = configFileStream.LinkToFile(path)
  	if ($$$ISERR(status)) {
		// do $system.Status.DisplayError(status)
		return status
	}
  	// do configFileStream.OutputToDevice()
	
	#dim configJson as %DynamicObject = {}.%FromJSON(configFileStream)
	#dim servicesJson as %DynamicArray = configJson.services
	#dim servicesIter as %Iterator.Array = servicesJson.%GetIterator()
	
	#dim key as %Integer = 0
	#dim value as %DynamicObject = $$$NULLOREF
	
	while (servicesIter.%GetNext(.key,.value)) {
		set status = ..configureService(configJson.domain, value)
	  	if ($$$ISERR(status)) {
			// do $system.Status.DisplayError(status)
			return status
		}
	}
	
	return status
}

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

