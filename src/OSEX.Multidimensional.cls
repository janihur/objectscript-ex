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

ClassMethod Ex2()
{
	// ------------------------------------------------------------------------
	
	#dim statusDetails // md
	set statusDetails=1
	set statusDetails(1)="ERROR <Ens>ErrBPTerminated: Terminating BP OSEX.IOP.Jokes.Processes.Main # due to error: ERROR #83: Error code = OSEX.IOP.Jokes.Error"_$c(13,10)_"  > ERROR #83: Error code = OSEX.IOP.Jokes.Error"
	set statusDetails(1,"caller")="zMessageHeaderHandler+205^Ens.Actor.1"
	set statusDetails(1,"code")="<Ens>ErrBPTerminated"
	set statusDetails(1,"dcode")="ErrBPTerminated"
	set statusDetails(1,"domain")="Ens"
	set statusDetails(1,"embeddederror")=1
	set statusDetails(1,"embeddederror",1)="0 "_$lb($lb(83,"OSEX.IOP.Jokes.Error","{""Description"":""Not implemented yet."",""Time"":""2024-02-20T11:15:57Z""}",,,,,,,$lb(,"DEV-9159",$lb("e^zExportToStatus+3^OSEX.IOP.Jokes.Error.1^1","e^zOnRequest+33^OSEX.IOP.Jokes.Processes.Main.1^1","e^zMessageHeaderHandler+19^OSEX.IOP.Jokes.Processes.Main.1^1","e^zMessageHeaderHandler+106^Ens.Actor.1^1","e^zOnTask+42^Ens.Host.1^1","e^zStart+62^Ens.Job.1^2","d^StartEnsembleJob+6^|""%SYS""|STU^1","d^^^0"))))/* ERROR #83: Error code = OSEX.IOP.Jokes.Error */
	set statusDetails(1,"embeddedstatus")="0 "_$lb($lb(83,"OSEX.IOP.Jokes.Error","{""Description"":""Not implemented yet."",""Time"":""2024-02-20T11:15:57Z""}",,,,,,,$lb(,"DEV-9159",$lb("e^zExportToStatus+3^OSEX.IOP.Jokes.Error.1^1","e^zOnRequest+33^OSEX.IOP.Jokes.Processes.Main.1^1","e^zMessageHeaderHandler+19^OSEX.IOP.Jokes.Processes.Main.1^1","e^zMessageHeaderHandler+106^Ens.Actor.1^1","e^zOnTask+42^Ens.Host.1^1","e^zStart+62^Ens.Job.1^2","d^StartEnsembleJob+6^|""%SYS""|STU^1","d^^^0"))))/* ERROR #83: Error code = OSEX.IOP.Jokes.Error */
	set statusDetails(1,"namespace")="DEV-9159"
	set statusDetails(1,"param")=3
	set statusDetails(1,"param",1)="OSEX.IOP.Jokes.Processes.Main"
	set statusDetails(1,"param",2)=""
	set statusDetails(1,"param",3)="ERROR #83: Error code = OSEX.IOP.Jokes.Error"
	set statusDetails(1,"stack")=$lb("e^zMessageHeaderHandler+205^Ens.Actor.1^1","e^zOnTask+42^Ens.Host.1^1","e^zStart+62^Ens.Job.1^2","d^StartEnsembleJob+6^|""%SYS""|STU^1","d^^^0")
	write "(1)"_..GetStringFromStatus(.statusDetails),!
	
	// ------------------------------------------------------------------------
	
	#dim status as %Status = $$$ERROR(83,"OSEX.IOP.Jokes.Error","Lorem ipsum dolor sit amet.")
	kill statusDetails
	do $system.Status.DecomposeStatus(status, .statusDetails)
	write "(2)"_..GetStringFromStatus(.statusDetails),!
	
	// ------------------------------------------------------------------------
	
	set status = $$$ERROR(5001,"A.Big.Rewrite","Lorem ipsum dolor sit amet.")
	kill statusDetails
	do $system.Status.DecomposeStatus(status, .statusDetails)
	write "(3)"_..GetStringFromStatus(.statusDetails),!

	// ------------------------------------------------------------------------
	
	set status = $$$OK
	kill statusDetails
	do $system.Status.DecomposeStatus(status, .statusDetails)
	write "(4)"_..GetStringFromStatus(.statusDetails),!
}

/// returns a specific string from %Status if the status contains the specific error
ClassMethod GetStringFromStatus(ByRef statusDetails As %String) As %String [ Private ]
{
	if (($get(statusDetails(1,"code")) = 83) && ($get(statusDetails(1,"param",1)) = "OSEX.IOP.Jokes.Error")) {
		return $get(statusDetails(1,"param",2))
	}
	
	#dim embeddedStatus as %Status = $get(statusDetails(1,"embeddedstatus"))
	if (embeddedStatus '= "") {
		#dim embeddedStatusDetails // md
		do $system.Status.DecomposeStatus(embeddedStatus, .embeddedStatusDetails)
		return ..GetStringFromStatus(.embeddedStatusDetails)
	}
	
	return ""
}

ClassMethod Ex3()
{
	// data part --------------------------------------------------------------
	#dim d // md
	set d("A") = "OPERATED_OK"
	set d("B") = "OPERATED_OK"
	set d("C") = "OPERATED_ERROR"
	set d("D") = "NOT_OPERATED_YET"
	set d("E") = "NOT_OPERATED_YET"
	set d("F",1) = "NOT_OPERATED_YET"
	set d("F",3) = "NOT_OPERATED_YET"

	// convert to string ------------------------------------------------------
	write ..MdToString2(.d),!
}

ClassMethod Ex4()
{
	#dim operationList as %ListOfDataTypes = ##class(%ListOfDataTypes).%New()
	do operationList.Insert("OP.1")
	do operationList.Insert("OP.2")
	do operationList.Insert("OP.3")
	do operationList.Insert("OP.4")
	do operationList.Insert("OP.5")
	do operationList.Insert("OP.6")

	#dim dataSet1 // md
	set dataSet1("OP.1") = "DS.1"
	set dataSet1("OP.2") = "DS.1"
	set dataSet1("OP.3") = "DS.2"
	set dataSet1("OP.4") = ""
	
	write "--- original data:",!
	zwrite operationList
	zwrite dataSet1

	// ------------------------------------------------------------------------

	#dim i as %Integer
	for i=1:1:operationList.Count() {
		#dim operation as %String = operationList.GetAt(i)
		if ('$data(dataSet1(operation))) {
			set dataSet1(operation) = ""
		}
	}
	write "--- modified dataSet1:",!
	zwrite dataSet1

	// ------------------------------------------------------------------------

	#dim dataSet2 // md
	#dim index1 as %String = $order(dataSet1(""))
	#dim index2 as %Integer = 1
	while (index1 '= "") {
		#dim value as %String = $get(dataSet1(index1))
		if (value = "") {
			set value = "default"
		}
		#dim hasIndex as %Boolean = $data(dataSet2(value))
		if (hasIndex) {
			do $increment(index2)
		} else {
			set index2 = 1
		}
		set dataSet2(value, index2) = index1
		set index1 = $order(dataSet1(index1))
	}
	write "--- dataSet2:",!
	zwrite dataSet2

	// ------------------------------------------------------------------------

	write "--- operating:",!
	#dim dataSet as %String = ""
	for {
		set dataSet = $order(dataSet2(dataSet))
		quit:(dataSet = "")
		write "dataset: "_dataSet,!

		#dim index3 as %String = ""
		for {
			set index3 = $order(dataSet2(dataSet,index3))
			quit:(index3 = "")
			write "  operation: "
			write index3
			write ": "
			write $get(dataSet2(dataSet, index3)),!
		}
	}
}

ClassMethod Ex5()
{
	set a("A", 1) = 1
	set a("A", 2) = 2
	set a("A", 3) = 3
	set a("B", 1) = 4

	write "---",!
	write ..MdToString(.a),!

	write "---",!
	write ..MdToString2(.a),!

	// #1038: Private variable not allowed
	// #dim ref as %String = $query(a(""))

	// but works in method with PublicList
	write "---",!	
	write ..MdToString3(.a),!
}

/// multidimensional with one subscript max to string
ClassMethod MdToString(ByRef md) As %String
{
	#dim accu as %String = ""

	#dim key as %String = $order(md(""))
	while (key '= "" ) {
		#dim value as %String = $get(md(key))
		set accu=accu_"("_key_" "_value_")"
		set key = $order(md(key))
	}

	return accu
}

/// multidimensional with two subscripts max to string
ClassMethod MdToString2(ByRef md) As %String
{
	#dim accu as %String = ""

	#dim key1 as %String = ""
	for {
		set key1 = $order(md(key1))
		quit:(key1 = "")
		#dim hasData as %Integer = $data(md(key1))
		// write "key1: "_key1_", hasData: "_hasData,!
		if (hasData = 10) {
			#dim key2 as %String = ""
			for {
				set key2 = $order(md(key1, key2))
				quit:(key2 = "")
				set accu = accu_"("_key1_" "_key2_" "_$get(md(key1, key2))_")"
			}
		} else {
			set accu = accu_"("_key1_" "_$get(md(key1))_")"
		}
	}

	return accu
}

ClassMethod MdToString3(ByRef md) As %String [ PublicList = md ]
{
	#dim accu as %String = ""

    set ref = $query(md(""))
    while (ref '= "") {
		set accu = accu_"("_ref_" "_@ref_")"
        set ref = $query(@ref)
    }

	return accu
}

}
