Class OSEX.Stream Extends %RegisteredObject
{

/// throws OSEX.Ex.StreamError if status is error
ClassMethod assertStreamStatus(status As %Status) [ Private ]
{
	if ($$$ISERR(status)) {
		#dim ex = ##class(OSEX.Ex.StreamError).%New()

		set ex.Name = "STREAM" // just an example
		set ex.Location = "LOCATION TODO"

		#dim errorList // md
		do $system.Status.DecomposeStatus(status, .errorList)
		zw errorList // TODO
		
		//#dim statusException As %Exception.StatusException = ##class(%Exception.StatusException).CreateFromStatus(status)
		//set ex.Code = statusException.Code
		//set ex.Data = statusException.Data

		// TODO InnerException

		// magic string copied somewhere: $LI($ZU(41,-2),2,*)
		// $zutil is deprecated but no replacement found for operation 42,-2
		set ex.StackTrace = $list($zutil(41,-2),2,*)
		
		/*
		#dim index as %Integer
		for index = 0:1:$stack(-1) {
			set ex.StackTrace = ex.StackTrace_"((contextLevel "_index_")(contextType """_$stack(index)_""")"
			set ex.StackTrace = ex.StackTrace_"(place "_$stack(index, "place")_")(mcode """_$stack(index, "mcode")_"""))"
		}
		*/
		
		set ex.CauseStatus = status

		throw ex
	}
}

ClassMethod Ex1()
{
	#dim error as OSEX.Ex.StreamError
	try {
		#dim outputFileStream as %Stream = ##class(%Stream.FileCharacter).%New()
	 	#dim status as %Status
  		set status = outputFileStream.LinkToFile("xxx/tmp/waste-land.txt")
  		do ..assertStreamStatus(status)
	} catch (error) {
		write "Exception class: "_$classname(error),!
		write "Exception: "_error.DisplayString()
		// https://docs.intersystems.com/irislatest/csp/docbook/DocBook.UI.Page.cls?KEY=GCOS_errorlog
		// do error.Log() 
	}
}

ClassMethod Ex2()
{
	// ------------------------------------------------------------------------
	
	#dim error as OSEX.Ex.StreamError
	try {
		#dim outputFileStream as %Stream = ##class(%Stream.FileCharacter).%New()
	 	#dim status as %Status
  		set status = outputFileStream.LinkToFile("/tmp/waste-land.txt")
  		do ..assertStreamStatus(status)
	 	set status = outputFileStream.WriteLine("April is the cruellest month, breeding")
  		do ..assertStreamStatus(status)
	 	set status = outputFileStream.WriteLine("Lilacs out of the dead land, mixing")
  		do ..assertStreamStatus(status)
 		set status = outputFileStream.WriteLine("Memory and desire, stirring")
  		do ..assertStreamStatus(status)
 		set status = outputFileStream.WriteLine("Dull roots with spring rain.")
  		do ..assertStreamStatus(status)
 		set status = outputFileStream.%Save()
  		do ..assertStreamStatus(status)
	} catch (error) {
		write !,"Exception:",!
		write error.DisplayString(),!
	}
 	
 	// ------------------------------------------------------------------------

 	#dim stream2 as %Stream = ##class(%Stream.FileCharacter).%New()
	set status = stream2.CopyFrom(outputFileStream)
  	if ($$$ISERR(status)) {
		// zwrite status
		do $system.Status.DisplayError(status)
	}
	
	do stream2.OutputToDevice()

 	// ------------------------------------------------------------------------
 	
	#dim inputFileStream as %Stream = ##class(%Stream.FileCharacter).%New()

  	set status = inputFileStream.LinkToFile("/tmp/waste-land.txt")
  	if ($$$ISERR(status)) {
		// zwrite status
		do $system.Status.DisplayError(status)
	}

  	while (inputFileStream.AtEnd = 0) {
	  	#dim chunkSize as %Integer = 20 // arbitrary small value
  		#dim chunk as %String = inputFileStream.Read(.chunkSize)
  		// process the chunk here
  		write !,"process loop("_chunkSize_" chars): "
  		write chunk
  	}

 	// ------------------------------------------------------------------------
}

ClassMethod Ex3(path As %String)
{
	#dim status as %Status = $$$OK
	#dim instream = ##class(%Stream.FileBinary).%New()
	$$$THROWONERROR(status,instream.LinkToFile(path))
	zwrite status
	zwrite instream
}

/// expects the following utf-8 encoded input file in:
/// 
/// char unicode utf8   cp1252
/// Æ    U+00c6  0xc386 0xc6
/// Ç    U+00c7  0xc387 0xc7
/// Ø    U+00d8  0xc398 0xd8
/// 
/// $ cat in; echo; xxd in
/// loremÆÇØ
/// 00000000: 6c6f 7265 6dc3 86c3 87c3 98              lorem......
ClassMethod Ex4()
{
 	#dim status as %Status

	// ------------------------------------------------------------------------
	
	#dim in = ##class(%Stream.FileCharacter).%New()
	set in.TranslateTable = "UTF8"
	set status = in.LinkToFile("/tmp/in")
  	if ($$$ISERR(status)) {
		do $system.Status.DisplayError(status)
	}

	// ------------------------------------------------------------------------
	
	#dim out = ##class(%Stream.FileCharacter).%New()
	set out.TranslateTable = "CP1252"
	set status = out.LinkToFile("/tmp/out")
  	if ($$$ISERR(status)) {
		do $system.Status.DisplayError(status)
	}
	
	// ------------------------------------------------------------------------
	
	do out.CopyFrom(in)
	
	// ------------------------------------------------------------------------
	
  	set status = out.%Save()
  	if ($$$ISERR(status)) {
		do $system.Status.DisplayError(status)
	}
}

/// expects the following utf-8 encoded input file in2:
/// 
/// char unicode utf8   cp1252
/// Æ    U+00c6  0xc386 0xc6
/// Ç    U+00c7  0xc387 0xc7
/// Ø    U+00d8  0xc398 0xd8
/// 
/// $ cat in2; echo; xxd in2
/// {"a":"loremÆÇØ"}
/// 00000000: 7b22 6122 3a22 6c6f 7265 6dc3 86c3 87c3  {"a":"lorem.....
/// 00000010: 9822 7d                                  ."}
ClassMethod Ex5()
{
 	#dim status as %Status

	// ------------------------------------------------------------------------
	
	#dim in = ##class(%Stream.FileCharacter).%New()
	set in.TranslateTable = "UTF8"
	set status = in.LinkToFile("/tmp/in2")
  	if ($$$ISERR(status)) {
		do $system.Status.DisplayError(status)
	}

	// ------------------------------------------------------------------------
	
  	#dim chunkSize as %Integer = 32000 // arbitrary long enough value
	#dim chunk as %String = in.Read(.chunkSize)
	zzdump chunk

	// ------------------------------------------------------------------------
	
	#dim obj as %DynamicObject = {}.%FromJSON(in)
	zzdump obj.a
	
	// ------------------------------------------------------------------------
	
	#dim out = ##class(%Stream.FileCharacter).%New()
	set out.TranslateTable = "CP1252"
	set status = out.LinkToFile("/tmp/out2")
  	if ($$$ISERR(status)) {
		do $system.Status.DisplayError(status)
	}
	
	// ------------------------------------------------------------------------
	
	#dim line as %String = ""
	
	set line = "a|b|c"
	set status = out.WriteLine(line)
  	if ($$$ISERR(status)) {
		do $system.Status.DisplayError(status)
	}

	set line = obj.a_"|"_obj.a_"|"_obj.a
	set status = out.WriteLine(line)
  	if ($$$ISERR(status)) {
		do $system.Status.DisplayError(status)
	}
	
	// ------------------------------------------------------------------------

  	set status = out.%Save()
  	if ($$$ISERR(status)) {
		do $system.Status.DisplayError(status)
	}
}

}

