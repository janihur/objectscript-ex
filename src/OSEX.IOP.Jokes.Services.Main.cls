Class OSEX.IOP.Jokes.Services.Main Extends Ens.BusinessService
{

Method OnProcessInput(pInput As OSEX.IOP.Jokes.Messages.ProcessingRequest, Output pOutput As OSEX.IOP.Jokes.Messages.ProcessingResponse) As %Status
{
	#dim status as %Status = ..SendRequestSync("Jokes.Processes.Main",pInput,.pOutput)
	return status
}

}
