Class OSEX.IOP.FileExport.Services.Main Extends Ens.BusinessService
{

Method OnProcessInput(pInput As OSEX.IOP.FileExport.Messages.ExportRequest, Output pOutput As Ens.Response) As %Status
{
	return ..SendRequestSync("FileExport.Processes.Main",pInput,.pOutput)
}

}

