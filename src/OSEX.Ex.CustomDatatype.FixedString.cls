/// <p>Custom datatype that returns modified value.</p>
/// <p>From <a href="https://community.intersystems.com/node/578811">Defining Fixed-Length String Properties in a Class</a>.</p>
Class OSEX.Ex.CustomDatatype.FixedString Extends %Library.String
{

/// <p>Right padded fixed size (MAXLEN) string.</p>
Method Get() As %String [ CodeMode = generator, ServerOnly = 1 ]
{
	// generates code:
	// return $extract(%val_"        ",1,8)
	set maxlen = +%parameter("MAXLEN")
	set padding = """"_$justify("", maxlen)_""""
	set code = "$extract(%val_"_padding_",1,"_maxlen_")"
	$$$GENERATE( "  return "_code) // significant whitespace
	return $$$OK
}

}
