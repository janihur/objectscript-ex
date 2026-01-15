/// <p>List implementations:</p>
/// <ul>
/// <li><a href="https://docs.intersystems.com/irislatest/csp/docbook/DocBook.UI.Page.cls?KEY=RCOS_flist">classic list</a> ($list or %List)</li>
/// <li><a href="https://docs.intersystems.com/irislatest/csp/docbook/DocBook.UI.Page.cls?KEY=GOBJ_propcoll#GOBJ_propcall_list">list collection</a></li>
/// <li><a href="https://docs.intersystems.com/irislatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25Library.DynamicArray">%Library.DynamicArray</a> (JSON)</li>
/// </ul>
Class OSEX.Ex.List
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

/// <p>Classic list ($list or %List).</p>
ClassMethod Ex2()
{
	// build from strings and iterate
	set list1 = $listbuild("alpha","bravo","charlie","delta","echo","foxtrot")
	zw list1
	for i=1:1:$listlength(list1) {
		write $list(list1,i), " "
	}
	write !

	// build from a single string
	set list2 = $listfromstring("alpha,bravo,charlie,delta,echo,foxtrot",",")
	zw list2
	for i=1:1:$listlength(list2) {
		write $list(list2,i), " "
	}
	write !

	// append to an empty list
	// null string ("") is used to represent an empty list
	// $listbuild() creates a list with at least one element
	// so the first append (*+1) will be the second element
	zw $listlength($listbuild()) // 1

	set list3 = "" // empty list
	set $list(list3,*+1) = "alpha"
	set $list(list3,*+1) = "bravo"
	set $list(list3,*+1) = "charlie"
	set $list(list3,*+1) = "delta"
	set $list(list3,*+1) = "echo"
	set $list(list3,*+1) = "foxtrot"
	zw list3
	for i=1:1:$listlength(list3) {
		write $list(list3,i), " "
	}
	write !
}

/// <p>%Library.DynamicArray (JSON).</p>
ClassMethod Ex3()
{
	// convert string to DynamicArray
	// split string by delimiter and push values to array
	set arr1 = [] // or ##class(%Library.DynamicArray).%New()
	set input = "alpha,bravo,charlie,delta,echo,foxtrot"
	for i=1:1:$length(input,",") {
		set value = $piece(input,",",i)
		do arr1.%Push(value)
	}
	zw arr1

	// convert DynamicArray to string
	set output = ""
	for i=0:1:arr1.%Size()-1 {
		set value = arr1.%Get(i) // zero-based index
		if (i > 0) {
			set output = output_","_value
		} else {
			set output = value
		}
	}
	zw output
}

ClassMethod Ex4()
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
ClassMethod Ex5()
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
