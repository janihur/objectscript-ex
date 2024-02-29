Class OSEX.IOP.UniversalExports.Services.Main Extends Ens.BusinessService
{

Method OnProcessInput(pInput As OSEX.IOP.UniversalExports.Messages.BookExportRequest, Output pOutput As Ens.Response) As %Status
{
	return ..SendRequestSync("OSEX.IOP.UniversalExports.Processes.Main",pInput,.pOutput)
}

}

