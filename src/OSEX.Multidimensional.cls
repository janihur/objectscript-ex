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

}

