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

}

