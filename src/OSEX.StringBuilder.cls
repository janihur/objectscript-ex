Class OSEX.StringBuilder Extends %RegisteredObject
{

/// TODO
Property Separator As %String(MAXLEN = "");

Property Stream As %Stream.TmpCharacter [ Private ];

/// ---------------------------------------------------------------------------
/// Public Methods
/// ---------------------------------------------------------------------------
Method %OnNew(initialValue As %String = "") As %Status
{
    do ..appendString(initialValue)
    
    return $$$OK
}

Method Append(value, args...) As OSEX.StringBuilder
{
    if ($isobject(value)) {
        if (value.%IsA("OSEX.StringBuilder")) {
           do ..appendStringBuilder(value)
        } elseif (value.%IsA("%Net.HttpResponse")) {
            #dim showData as %Boolean = $get(args(1),0)
            do ..appendHttpResponse(value, showData)
        }
    } else { // string
        do ..appendString(value)
    }
    
    return ##this
}

Method AppendKv(key As %String, value As %String) As OSEX.StringBuilder
{
    do ..appendString(..KvS(key, value))
    
    return ##this
}

Method AppendMd(ByRef md) As OSEX.StringBuilder [ PublicList = md ]
{
    set ref = $query(md(""))
    while (ref '= "") {
        do ..appendString(..KvS(ref, @ref))
        set ref = $query(@ref)
    }
    
    return ##this
}

/// Return a key-value pair as s-expression look-alike string.
/// Return value surrounded with quotes "" (as a string):
/// (key "value") 
/// Example:
/// (foo "lorem ipsum dolor sit amet")
/// 
/// Doesn't escape quotes in value.
ClassMethod Kv(key As %String, value As %String) As %String [ CodeMode = expression ]
{
..KvS(key, value)
}

ClassMethod KvS(key As %String, value As %String) As %String [ CodeMode = expression ]
{
"("_key_" """_value_""")"
}

/// Return a key-value pair as s-expression look-alike string.
/// Return plain value (as a number):
/// (key value) 
/// Example:
/// (foo 42)
ClassMethod KvN(key As %String, value) As %String [ CodeMode = expression ]
{
"("_key_" "_value_")"
}

Method ToString() As %String
{
    // ignore the errors ...
    do ..Stream.Rewind()
    
    return ..Stream.Read()
}

/// ---------------------------------------------------------------------------
/// Private Methods
/// ---------------------------------------------------------------------------
Method appendStringBuilder(sb As OSEX.StringBuilder) [ Private ]
{
    set status = ..Stream.CopyFrom(sb.Stream)
}

Method appendHttpResponse(httpResponse As %Net.HttpResponse, showData As %Boolean = 0) [ Private ]
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
			do httpResponse.Data.Rewind()

			set dataData = "(Data """_httpResponse.Data.Read()_""")"
            do httpResponse.Data.Rewind()
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
	
    do ..appendString("(HttpResponse ("_headers_statusCode_contentType_dataIsObject_dataClassname_dataSize_dataData_"))")
}

Method appendString(value As %String) [ Private ]
{
    do ..Stream.Write(value)
}

}
