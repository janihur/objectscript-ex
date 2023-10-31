/// How to use multidimensional.
Class OSEX.Multidimensional
{

Parameter Foo = "DEFAULT_FOO";

Parameter Bar = "DEFAULT_BAR";

ClassMethod Ex1()
{
	// data part --------------------------------------------------------------
	#dim d // md
	set d(1) = ""
	set d(2, "foo") = "my foo #2"
	set d(3, "bar") = "my bar #3"
	set d(4, "foo") = "my foo #4"
	set d(4, "bar") = "my bar #4"
	
	// operation part ---------------------------------------------------------
	#dim id as %Integer = $order(d(""))
	while (id '= "" ) {
		#dim foo as %String = $get(d(id, "foo"))
		#dim bar as %String = $get(d(id, "bar"))
		
		#dim fVal as %String;
		if ((foo = "") && (bar = "")) {
			set fVal = ..f()
		} elseif ((foo '= "") && (bar = "")) {
			set fVal = ..f(foo)
		} elseif ((foo = "") && (bar '= "")) {
			set fVal = ..f(,bar)
		} else {
			set fVal = ..f(foo,bar)
		}
		write "#"_id_": "_fVal,!
		
		set id = $order(d(id))
	}
}

ClassMethod f(foo As %String = {..#Foo}, bar As %String = {..#Bar}) As %String [ Private ]
{
	return "(foo """_foo_""")(bar """_bar_""")"
}

}

