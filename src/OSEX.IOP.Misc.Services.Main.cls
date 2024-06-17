Class OSEX.IOP.Misc.Services.Main Extends Ens.BusinessService
{

Method OnProcessInput(pInput As Ens.Request, Output pOutput As Ens.Response) As %Status
{
	return ..SendRequestSync("Misc.Operations.CustomHttpRequest",pInput,.pOutput)
}

}
