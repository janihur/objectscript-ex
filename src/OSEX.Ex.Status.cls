Include EnsErrors

Class OSEX.Ex.Status Extends %RegisteredObject
{

ClassMethod Ex1()
{
	// ERROR <Ens>ErrHTTPStatus: Received non-OK status 401 from remote HTTP server: 'HTTP/1.1 401 Unauthorized'
	#dim status as %Status = $$$ERROR($$$EnsErrHTTPStatus,"401","HTTP/1.1 401 Unauthorized")
	do $system.Status.DisplayError(status)
	write !
	write "error text: "_$system.Status.GetErrorText(status),!
	write "error code: "_$system.Status.GetErrorCodes(status),!
	
	#dim statusDetails // md
	do $system.Status.DecomposeStatus(status, .statusDetails)
	zwrite statusDetails
}

ClassMethod Ex2()
{
	// ------------------------------------------------------------------------
	// ERROR #6059: Unable to open TCP/IP socket to server host.docker.internal:8080
	#dim status1 as %Status = $$$ERROR(6059, "host.docker.internal:8080")
	write "--- status 1 ----------------------------------------",!
	do $system.Status.DisplayError(status1)
	
	// ------------------------------------------------------------------------
	// ERROR <Ens>ErrFailureTimeout: FailureTimeout of 15 seconds exceeded in OSEX.IOP.Jokes.Operations.Simpsons; status from last attempt was ERROR #6059: Unable to open TCP/IP socket to server host.docker.internal:8080
	#dim status2 as %Status = $$$ERROR($$$EnsErrFailureTimeout,15,$system.Status.GetErrorText(status1),"OSEX.IOP.Jokes.Operations.Simpsons")
	write !,"--- status 2 ----------------------------------------",!
	do $system.Status.DisplayError(status2)

	// ------------------------------------------------------------------------
	// ERROR <Ens>ErrBPTerminated: Terminating BP OSEX.IOPJokes.Process # due to error:
	#dim status3 as %Status = $$$ERROR($$$EnsErrBPTerminated,"OSEX.IOPJokes.Process","",$system.Status.GetErrorText(status2))
	write !,"--- status 3 ----------------------------------------",!
	do $system.Status.DisplayError(status3)
	
	// ------------------------------------------------------------------------
	write !,"--- decompose ---------------------------------------",!
	#dim statusDetails // md
	do $system.Status.DecomposeStatus(status3, .statusDetails)
	zwrite statusDetails

	// ------------------------------------------------------------------------
	write !,"--- appended ---------------------------------------",!
	#dim statusAll = $system.Status.AppendStatus(status1, status2)
	do $system.Status.DisplayError(statusAll)
	do $system.Status.DecomposeStatus(statusAll, .statusDetails)
	zwrite statusDetails
}

ClassMethod Ex3()
{
	#dim status1 as %Status = $$$ERROR(6059, "host.docker.internal:8080")
	#dim status2 as %Status = $$$ERROR($$$EnsErrFailureTimeout,15,"","OSEX.IOP.Jokes.Operations.Simpsons")
	#dim status3 as %Status = $$$ERROR($$$EnsErrBPTerminated,"OSEX.IOP.Jokes.Process","","")
	
	#dim status as %Status = $$$NULLOREF
	set status = $system.Status.AppendStatus(status3, status2)
	set status = $system.Status.AppendStatus(status, status1)
	
	do $system.Status.DisplayError(status)

	write !,!

	#dim statusDetails // md
	do $system.Status.DecomposeStatus(status, .statusDetails)
	zwrite statusDetails
	
	#dim len as %Integer = statusDetails
	write !,"(length ",len,")",!

	write "--- $system.Status.GetErrorText():",!
	zwrite $system.Status.GetErrorText(status)
	write "--- $system.Status.GetErrorCodes()",!
	zwrite $system.Status.GetErrorCodes(status)
}

/// Ensemble embeds errors
ClassMethod Ex4()
{
	#dim statusDetails //md
	set statusDetails=1
	set statusDetails(1)="ERROR <Ens>ErrBPTerminated: Terminating BP OSEX.IOP.Jokes.Process # due to error: ERROR <Ens>ErrGeneral: ERROR <Ens>ErrHTTPStatus: Received non-OK status 401 from remote HTTP server: 'HTTP/1.1 401 Unauthorized':{""error"":""Imaginary authentication error""}"_$c(13,10)_"  > ERROR <Ens>ErrGeneral: ERROR <Ens>ErrHTTPStatus: Received non-OK status 401 from remote HTTP server: 'HTTP/1.1 401 Unauthorized':{""error"":""Imaginary authentication error""}"
	set statusDetails(1,"caller")="zMessageHeaderHandler+205^Ens.Actor.1"
	set statusDetails(1,"code")="<Ens>ErrBPTerminated"
	set statusDetails(1,"dcode")="ErrBPTerminated"
	set statusDetails(1,"domain")="Ens"
	set statusDetails(1,"embeddederror")=1
	set statusDetails(1,"embeddederror",1)="0 "_$lb($lb("<Ens>ErrGeneral","ERROR <Ens>ErrHTTPStatus: Received non-OK status 401 from remote HTTP server: 'HTTP/1.1 401 Unauthorized':{""error"":""Imaginary authentication error""}",,,,,,,,$lb(,"DEV-9159",$lb("e^zImport+7^Mylab.EI.LaboratoryTestHandbook.Operations.ExternalTutkimusohjekirja.1^1","e^zMessageHandler+6^Mylab.EI.LaboratoryTestHandbook.Operations.ExternalTutkimusohjekirja.1^1","e^zMessageHeaderHandler+23^Mylab.EI.LaboratoryTestHandbook.Operations.ExternalTutkimusohjekirja.1^1","e^zOnTask+42^Ens.Host.1^1","e^zStart+62^Ens.Job.1^2","d^StartEnsembleJob+6^|""%SYS""|STU^1","d^^^0"))))
	set statusDetails(1,"embeddedstatus")="0 "_$lb($lb("<Ens>ErrGeneral","ERROR <Ens>ErrHTTPStatus: Received non-OK status 401 from remote HTTP server: 'HTTP/1.1 401 Unauthorized':{""error"":""Imaginary authentication error""}",,,,,,,,$lb(,"DEV-9159",$lb("e^zImport+7^Mylab.EI.LaboratoryTestHandbook.Operations.ExternalTutkimusohjekirja.1^1","e^zMessageHandler+6^Mylab.EI.LaboratoryTestHandbook.Operations.ExternalTutkimusohjekirja.1^1","e^zMessageHeaderHandler+23^Mylab.EI.LaboratoryTestHandbook.Operations.ExternalTutkimusohjekirja.1^1","e^zOnTask+42^Ens.Host.1^1","e^zStart+62^Ens.Job.1^2","d^StartEnsembleJob+6^|""%SYS""|STU^1","d^^^0"))))
	set statusDetails(1,"namespace")="DEV-9159"
	set statusDetails(1,"param")=3
	set statusDetails(1,"param",1)="OSEX.IOP.Jokes.Process"
	set statusDetails(1,"param",2)=""
	set statusDetails(1,"param",3)="ERROR <Ens>ErrGeneral: ERROR <Ens>ErrHTTPStatus: Received non-OK status 401 from remote HTTP server: 'HTTP/1.1 401 Unauthorized':{""error"":""Imaginary authentication error""}"
	set statusDetails(1,"stack")=$lb("e^zMessageHeaderHandler+205^Ens.Actor.1^1","e^zOnTask+42^Ens.Host.1^1","e^zStart+62^Ens.Job.1^2","d^StartEnsembleJob+6^|""%SYS""|STU^1","d^^^0")
}

}
