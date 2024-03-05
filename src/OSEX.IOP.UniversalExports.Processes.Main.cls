Class OSEX.IOP.UniversalExports.Processes.Main Extends Ens.BusinessProcess [ ClassType = persistent ]
{

Method OnRequest(pRequest As OSEX.IOP.UniversalExports.Messages.BookExportRequest, Output pResponse As Ens.Response) As %Status
{
	$$$TRACE("(pRequest ((Book """_pRequest.Book_""")(Amount "_pRequest.Amount_")))")
	
	#dim status as %Status = $$$OK
	
	// resolve import addresses -----------------------------------------------
	// quit if no import addresses (nothing to do)
	
	#dim businessOperationList as %ListOfDataTypes = ..queryBusinessOperations("OSEX.IOP.UniversalExports","BookImport")

	$$$TRACE("(businessOperationList (Count "_businessOperationList.Count()_"))")

	if (businessOperationList.Count() = 0) {
		return status
	}

	// 1/2 export -------------------------------------------------------------
	
	#dim exportResponse as OSEX.IOP.UniversalExports.Messages.ExportResponse = $$$NULLOREF
	set status = ..SendRequestSync("OSEX.IOP.UniversalExports.Operations.BookExport",pRequest,.exportResponse)

	return:$$$ISERR(status) status
	
	if ('$isobject(exportResponse)) {
		#dim details as %String = "Export response is not an object."
		#dim error = ##class(OSEX.IOP.UniversalExports.Error).Create(details)
		$$$LOGERROR(error.ExportToJson())
		return error.ExportToStatus()
	}

	// 2/2 import -------------------------------------------------------------

	#dim key = ""
	#dim businessOperation as %String = businessOperationList.GetNext(.key)
	while (key '= "") {
		//write "Business Operation: "_value,!
		set status = ..SendRequestSync(businessOperation,.exportResponse,.pResponse)
		// TODO log error and report how many succeeded and failed
		return:$$$ISERR(status) status
		set businessOperation = businessOperationList.GetNext(.key)
	}
	
	// ------------------------------------------------------------------------
	
	return status
}

/// returns all business operations attribute of services where
/// Service.Domain match the query parameter AND
/// Service.Stage = Live AND
/// Attribute.Name = ServiceType AND
/// Attribute.Value match the query parameter
ClassMethod queryBusinessOperations(domain As %String, serviceType As %String) As %ListOfDataTypes
{
	#dim businessOperationList = ##class(%ListOfDataTypes).%New()

	#dim businessOperation as %String = ""
	
	&sql(DECLARE c1 CURSOR FOR
		select
		a2.BusinessOperation
		into :businessOperation
		from (
		  select s.ID, s.Name, s."Domain", cast(s.Version as int) as Version, s.Stage,
		  rank() over (partition by s.Name, s."Domain" order by cast(s.Version as int) desc) as Rank
		  from Ens_ServiceRegistry_External.Service as s
		  where s."Domain" = :domain
		  and s.Stage = 'Live'
		) as s2
		inner join (
		  select
		   a.Service
		  ,max(case when a.Name = 'ServiceType'       then a.Value else null end) as ServiceType
		  ,max(case when a.Name = 'BusinessOperation' then a.Value else null end) as BusinessOperation
		  from Ens_ServiceRegistry_External."Attribute" as a
		  group by a.Service
		) as a2
		on s2.ID = a2.Service
		where 1 = 1
		and s2.Rank = 1
		and a2.ServiceType = :serviceType
	)
	
	&sql(OPEN c1)
	&sql(FETCH c1)
	
	while (SQLCODE = 0) {
		do businessOperationList.Insert(businessOperation)
		&sql(FETCH c1)
	}
	
	&sql(CLOSE c1)

	return businessOperationList
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}

