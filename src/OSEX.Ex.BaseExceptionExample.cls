Include OSEX

Class OSEX.Ex.BaseExceptionExample
{

ClassMethod Ex1()
{
	set base = ##class(BaseException).%New("Name","Code",,,,1)
	zw base
	#dim status as %Status = base.AsStatus()
	zw status
	Do $system.Status.DecomposeStatus(status,.err,"-d")
	For i=1:1:err Write err(i),!
}

ClassMethod Ex2()
{
	#dim base as BaseException = ##class(BaseException).Create(1)
	zw base
	#dim status as %Status = base.AsStatus()
	zw status
	Do $system.Status.DecomposeStatus(status,.err,"-d")
	For i=1:1:err Write err(i),!
}

/// User defined %Status
/// Have to use $$$GeneralError error code
/// General Error Messages
/// https://docs.intersystems.com/irislatest/csp/docbook/DocBook.UI.Page.cls?KEY=RERR_gen
/// $$$ERROR macro in System Macros
/// https://docs.intersystems.com/irislatest/csp/docbook/DocBook.UI.Page.cls?KEY=RCOS_appx_sysmacros
ClassMethod Ex3()
{
	// https://docs.intersystems.com/irislatest/csp/docbook/DocBook.UI.Page.cls?KEY=GCOS_status
	// https://docs.intersystems.com/irislatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25SYSTEM.Status
	
	#dim status as %Status
 	#dim statusDetails // md

	// ------------------------------------------------------------------------
	write "---",!
	set status = $$$OK
	zw status
	write "GetErrorText(): "
	zw $system.Status.GetErrorText(status)
	write "DecomposeStatus():",!
	do $system.Status.DecomposeStatus(status, .statusDetails)
	zw statusDetails
	kill statusDetails

	// ------------------------------------------------------------------------
	write "---",!
	set status = $$$ERROR($$$GeneralError,"your error text here","parm","anotherparm")
	zw status
	write "GetErrorText(): "
	zw $system.Status.GetErrorText(status)
	write "DecomposeStatus():",!
	do $system.Status.DecomposeStatus(status, .statusDetails)
	zw statusDetails
	kill statusDetails

	// ------------------------------------------------------------------------
	write "---",!
	set status = $$$ERROR($$$GeneralError,"your error text here",$listbuild("one","two","three"))
	zw status
	write "GetErrorText(): "
	zw $system.Status.GetErrorText(status)
	write "DecomposeStatus():",!
	do $system.Status.DecomposeStatus(status, .statusDetails)
	zw statusDetails
	kill statusDetails
}

ClassMethod Ex4()
{
	#dim detailsIn = ##class(ErrorDetails).%New()
	set detailsIn.Flag1 = $$$TRUE
	set detailsIn.MagicNumber = 1979
	set detailsIn.Message = "Message In A Bottle"
	zw detailsIn
	
	// how long the detailsIn OREF will survive?
	#dim status as %Status = $$$ERROR($$$GeneralError,"your error text here",detailsIn)
	zw status

	#dim statusDetails // md
	do $system.Status.DecomposeStatus(status, .statusDetails)
	
	// write "DecomposeStatus():",!
	// zw statusDetails
	
	#dim detailsOut as ErrorDetails = $zobjref(statusDetails(1,"param",2))
	zw detailsOut
}

/// Using the JSON Adaptor
/// https://docs.intersystems.com/irislatest/csp/docbook/DocBook.UI.Page.cls?KEY=GJSON_adaptor
ClassMethod Ex5()
{
	#dim detailsIn = ##class(ErrorDetails).%New()
	set detailsIn.Flag1 = $$$TRUE
	set detailsIn.MagicNumber = 1979
	set detailsIn.Message = "Message In A Bottle"
	zw detailsIn
	
	#dim serialized as %String
	do detailsIn.%JSONExportToString(.serialized)
	zw serialized
	
	#dim status as %Status = $$$ERROR($$$GeneralError,"your error text here",serialized)
	zw status

	#dim statusDetails // md
	do $system.Status.DecomposeStatus(status, .statusDetails)

	// write "DecomposeStatus():",!
	// zw statusDetails

	#dim detailsOutSerialized as %String = statusDetails(1,"param",2)
	// write "detailsOut:",!
	// zw detailsOutSerialized
	
	#dim detailsOut = ##class(ErrorDetails).%New()
	do detailsOut.%JSONImport(detailsOutSerialized)
	zw detailsOut
}

/// Using TRY-CATCH
/// https://docs.intersystems.com/irislatest/csp/docbook/DocBook.UI.Page.cls?KEY=GCOS_trycatch
ClassMethod implEx6() As %Status
{
	#dim ex as BaseException
	try {
		throw ##class(BaseException).Create("description","message",42,$$$TRUE)
	} catch ex {
		// just for demonstration
		// %ClassName() in %Library.SystemBase:
		// https://docs.intersystems.com/iris20233/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&PRIVATE=1&CLASSNAME=%25Library.SystemBase#%25ClassName
		// zwrite ex.%ClassName($$$TRUE)

		// just for demonstration
		// %IsA() in %Library.SystemBase:
		// https://docs.intersystems.com/iris20233/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&PRIVATE=1&CLASSNAME=%25Library.SystemBase#%25IsA
		if ex.%IsA("OSEX.Ex.BaseException") {
			write "verified the object is BaseException",!
		}
		#dim status as %Status = ex.AsStatus()
		return status
	}
	return $$$OK
}

ClassMethod getErrorDetailsFrom(status As %Status) As ErrorDetails
{
	#dim statusDetails // md
	do $system.Status.DecomposeStatus(status, .statusDetails)

	#dim details = ##class(ErrorDetails).%New()
	do details.%JSONImport(statusDetails(1,"param",2))

	return details
}

ClassMethod Ex6()
{
	#dim status as %Status = ..implEx6()
	zw status
	#dim errorDetails as ErrorDetails = ..getErrorDetailsFrom(status)
	zw errorDetails
}

}

