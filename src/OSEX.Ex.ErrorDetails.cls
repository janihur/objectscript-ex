/// Simple data object for error details.
Class OSEX.Ex.ErrorDetails Extends (%RegisteredObject, %JSON.Adaptor)
{

Property Flag1 As %Boolean [ InitialExpression = 0 ];

Property MagicNumber As %Integer [ InitialExpression = 0 ];

Property Message As %String;

}

