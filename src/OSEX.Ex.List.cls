Class OSEX.Ex.List Extends %RegisteredObject
{

ClassMethod Ex1()
{
	set a1 = $listbuild("foo", 1)
	set a2 = $listbuild("bar", 2)
	
	set list1 = $listbuild(a1,a2)
	
	zwrite list1
}

ClassMethod Ex2()
{
	#dim index as %Integer = 0
	#dim start as %Integer = 1
	#dim increment as %Integer = 1
	#dim end as %Integer = 5
	
	for index=start:increment:end {
		write index,!
	}
}

}

