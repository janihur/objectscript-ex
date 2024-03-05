Class OSEX.Ex.List Extends %RegisteredObject
{

ClassMethod Ex1()
{
	set a1 = $listbuild("foo", 1)
	set a2 = $listbuild("bar", 2)
	
	set list1 = $listbuild(a1,a2)
	
	zwrite list1
	
	for i=1:1:$listlength(list1) {
		write $list(list1,i),!
	}
}

ClassMethod Ex2()
{
	#dim fromList as %String = "alpha,bravo,charlie,delta,echo,foxtrot"
	
	#dim toList = ##class(%ListOfDataTypes).%New()
	
	#dim value as %String = ""
	
	#dim i as %Integer
	for i=1:1:$length(fromList,",") {
		set value = $piece(fromList,",",i)
    	write "#"_i_": "_value, !
		do toList.Insert(value)
	}
	
	zw toList
	
	#dim key = ""
	set value = toList.GetNext(.key)
	while (key '= "") {
		write value,!
		set value = toList.GetNext(.key)
	}
}

/// for-loop syntax
ClassMethod Ex3()
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

