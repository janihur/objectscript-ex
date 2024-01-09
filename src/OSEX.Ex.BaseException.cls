Class OSEX.Ex.BaseException Extends %Exception.AbstractException
{

/// https://docs.intersystems.com/irislatest/csp/docbook/DocBook.UI.Page.cls?KEY=RERR_gen
/// Two error codes, 83 ($$$ErrorCodeIs) and 5001 ($$$GeneralError), are provided to enable you to generate your own custom error messages. 
Parameter UserErrorCode = 5001;

Property Flag1 As %Boolean [ InitialExpression = 0 ];

Property MagicNumber As %Integer [ InitialExpression = 0 ];

Property Message As %String;

/// uses %OnNew() just for demonstration purposes
ClassMethod Create(pDescription As %String, pMessage As %String, pMagicNumber As %Integer = 0, pFlag1 As %Boolean = 0) As OSEX.Ex.BaseException
{
	return ..%New(pDescription,,,,,pMessage,pMagicNumber,pFlag1)
}

/// %OnNew() in Callback Methods:
/// https://docs.intersystems.com/irislatest/csp/docbook/DocBook.UI.Page.cls?KEY=GOBJ_callbacks#GOBJ_cb_onnew
Method %OnNew(pName As %String = "", pCode As %String = "", pLocation As %String = "", pData As %String = "", pInnerException As %Exception.AbstractException = {$$$NULLOREF}, pMessage As %String, pMagicNumber As %Integer = 0, pFlag1 As %Boolean = 0) As %Status [ Private ]
{
	do ##super(pName, ..#UserErrorCode, pLocation, pData, pInnerException)

	set ..Message = pMessage
	set ..MagicNumber = pMagicNumber
	set ..Flag1 = pFlag1
	
	return $$$OK
}

Method OnAsStatus() As %Status [ Private ]
{
	#dim details = ##class(ErrorDetails).%New()
	set details.Flag1 = ..Flag1
	set details.MagicNumber = ..MagicNumber
	set details.Message = ..Message

	#dim serialized as %String
	do details.%JSONExportToString(.serialized)
	
	return $$$ERROR($$$GeneralError,"REQUIRED_DUMMY",serialized)
}

}

