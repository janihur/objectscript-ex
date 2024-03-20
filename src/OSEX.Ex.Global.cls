/// https://docs.intersystems.com/irislatest/csp/docbook/DocBook.UI.Page.cls?KEY=RCOS_sglobal
Class OSEX.Ex.Global Extends %RegisteredObject
{

/// list all globals in the current namespace
ClassMethod Ex1()
{
	#dim name = ""
  	WRITE !,"The following globals are in namespace: ",$namespace
  	FOR I=1:1 {
    	set name =$ORDER(^$GLOBAL(name))
    	WRITE !,name
    	QUIT:name=""
  	}
  	WRITE !,"All done"
}

ClassMethod Ex2()
{
	// ^%qStream
	zw $data(^%qStream)
}

ClassMethod Ex3()
{
	set ^OSEX.IOP.Jokes("foo", 1) = "foo 1"
	set ^OSEX.IOP.Jokes("foo", 2) = "foo 2"
	set ^OSEX.IOP.Jokes("bar", 1) = "bar 1"
	set ^OSEX.IOP.Jokes("bar", 2) = "bar 2"
	
	zw $data(^OSEX.IOP.Jokes)
	zw ^OSEX.IOP.Jokes
}

}

