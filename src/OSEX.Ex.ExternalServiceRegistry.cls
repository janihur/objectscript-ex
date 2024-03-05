/// How to programmatically access External-Service Registry:
/// https://docs.intersystems.com/irisforhealth20221/csp/docbook/DocBook.UI.Page.cls?KEY=EESB_registry_admin#EESB_registry_admin_external
Class OSEX.Ex.ExternalServiceRegistry Extends %RegisteredObject
{

/// list all services
ClassMethod Ex1()
{
	#dim services // md
	do ##class(Ens.ServiceRegistry.External.API).ListServices(.services)
	
	#dim id as %Integer = $order(services(""))
	while (id '= "" ) {
		#dim val as %DynamicObject = {}.%FromJSON($get(services(id)))
		
		write "--------------------",!
		write "#"_id_" Name: "_val.Name,!
		write "#"_id_" Domain: "_val.Domain,!
		write "#"_id_" Version: "_val.Version,!
		write "#"_id_" exists: "_##class(Ens.ServiceRegistry.External.API).ExistsService(val.Name,val.Domain,val.Version),!
		write "#"_id_" json: "_val.%ToJSON(),!
		
		set id = $order(services(id))
	}
	
	//zw services
}

/// search services
ClassMethod Ex2()
{
	#dim searchCriteria // md
	set searchCriteria("DomainMatch") = "OSEX.IOP.UniversalExports"
	set searchCriteria("Stages") = "Live" // for some reason this has no effect ???
	#dim rs as %SQL.StatementResult = ##class(Ens.ServiceRegistry.External.API).PerformSearch(.searchCriteria,,.status)
	zw status
	
	while (rs.%Next()) {
		write rs.%CurrentResult.ID_": "_rs.%CurrentResult.Name_": "_rs.%CurrentResult.Stage,!
	}
}

/// returns all business operations attribute of services where
/// Service.Domain match the query parameter AND
/// Service.Stage = Live AND
/// Attribute.Name = ServiceType AND Attribute.Value match the query parameter
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

ClassMethod Ex3()
{
	#dim businessOperationList as %ListOfDataTypes = ..queryBusinessOperations("OSEX.IOP.UniversalExports","BookImport")

	write "Number of Business Operations: "_businessOperationList.Count(),!
	
	#dim key = ""
	#dim value as %String = businessOperationList.GetNext(.key)
	while (key '= "") {
		write "Business Operation: "_value,!
		set value = businessOperationList.GetNext(.key)
	}
}

/// add/modify service and related attributes
ClassMethod Ex4()
{
	#dim service = ##class(%ZEN.proxyObject).%New()
	set service.Name = "Foo Service"
	set service.Domain = "OSEX"
	set service.Version = "1"
	set service.Endpoint = "http://localhost:8080/foo"
	set service.Protocol = "REST"
	set service.ResponseStyle = "Sync"
	set service.Stage = "Live"
		
	//zw service
	
	#dim status as %Status = ##class(Ens.ServiceRegistry.External.API).SaveService(service)
	zw status
	
	#dim attribute = ##class(%ZEN.proxyObject).%New()
	set attribute.Service = service.Name_"||"_service.Domain_"||"_service.Version
	set attribute.Name = "Attribute ONE"
	set attribute.Value = "Updated value for ONE"
	
	zw ##class(Ens.ServiceRegistry.External.API).SaveAttribute(attribute)
	
	set service.Name = "Bar Service"
	set service.Endpoint = "http://localhost:8080/bar"

	zw ##class(Ens.ServiceRegistry.External.API).SaveService(service)
}

ClassMethod Ex5()
{
	#dim attribute = ##class(%ZEN.proxyObject).%New()
	set attribute.Service = "Foo Service||OSEX||1"
	set attribute.Name = "Attribute ONE"
	set attribute.Value = "Value for ONE"
	
	zw ##class(Ens.ServiceRegistry.External.API).SaveAttribute(attribute)
}

/// delete service
ClassMethod Ex6()
{
	#dim pid as %String = "Foo Service||OSEX||1"
	#dim status as %String = ##class(Ens.ServiceRegistry.External.API).DeleteService(pid)
	zw status
}

}

