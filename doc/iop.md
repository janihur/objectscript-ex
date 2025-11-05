# Interoperability (IOP)

## IOP Production Management

[Ens.Director](https://docs.intersystems.com/irislatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=ENSLIB&PRIVATE=1&CLASSNAME=Ens.Director)

|Operation|Command|Details|
|---------|-------|-------|
|Name     |`set name = ##class(Ens.Director).GetActiveProductionName()`|Not documented, see the source code.|
|Status   |`do ##class(Ens.Director).GetProductionStatus(.name,.state)`||
|Start    |`do ##class(Ens.Director).StartProduction("OSEX.IOP.Production")`||
|Stop     |`do ##class(Ens.Director).StopProduction("OSEX.IOP.Production")`||
|Remove   |`do ##class(Ens.Director).DeleteProduction("OSEXPKG.FoundationProduction")`||
|Restart  |`do ##class(Ens.Director).RestartProduction()`||
|Clean    |`do ##class(Ens.Director).CleanProduction()`|Development time only, see [Resetting Productions in a Namespace](https://docs.intersystems.com/irislatest/csp/docbook/DocBook.UI.Page.cls?KEY=EGDV_testing#EGDV_prod_cleanProd).|

## IOP Production Purge

IOP production records messaging data into internal database. The data have to be manually deleted.

Delete all data older than 10 days:
```
NAMESPACE>write ##class(Ens.Purge).PurgeAll(.pDeletedCount,10,1,1)
NAMESPACE>zwrite pDeletedCount
```

Use class `Ens.Util.Tasks.Purge` when running deletion as a scheduled task.

Delete only messages to/from business hosts (note the counterintuitive parameters/behaviour):
```
NAMESPACE>set pExtendedOptions("LimitToConfigItems") = "<BUSINESS_HOST_NAME>,<BUSINESS_HOST_NAME>"
NAMESPACE>write ##class(Ens.Util.MessagePurge).Purge(.pDeletedCount,10,1,1,500,.pExtendedOptions)
NAMESPACE>zwrite pDeletedCount
```

Delete only the payloads (i.e. message bodies):
```
-- 1/3 sql: find the payload(s)
select ID, MessageBodyId from Ens.MessageHeader
where 1 = 1
and MessageBodyClassName = 'OSEX.IOP.Jokes.Messages.OperatingResponse'
and SourceConfigName = 'Jokes.Operations.Simpsons'
and TargetConfigName = 'Jokes.Processes.Main'
;
-- returns:
-- 82, 57

// 2/3 objectscript: delete
write ##class(OSEX.IOP.Jokes.Messages.OperatingResponse).%DeleteId(57)

-- 3/3 sql: remove the reference to the deleted object
--          or replace with a dummy "removed on purpose" object (TODO)
update Ens.MessageHeader set 
 MessageBodyClassName = null
,MessageBodyId = null
where ID = 82
;
```

TODO: the idea above should be encapsulated into a proper ObjectScript API.

## IOP Production Extra Properties Example

Production class: [OSEX.IOP.Production.ExtraProperties](../src/OSEX.IOP.Production.ExtraProperties.cls)

Set [System Default Settings](https://docs.intersystems.com/irislatest/csp/docbook/DocBook.UI.Page.cls?KEY=ECONFIG_other_default_settings):
```
Home > Interoperability > Configure > System Default Settings
  > New
    > Production: *
      Item Name: *
      Host Class Name: *
      Setting Name: Bar
      Setting Value: From System Default Setting
  > Save

Read settings programmatically:
```
// current production
zw ##class(Ens.Production).GetSettingsArray(.settings)  zw settings
zw ##class(Ens.Production).GetSettingValue("Bar")

zw ##class(Ens.Director).GetProductionSettings("",.settings)  zw settings
zw ##class(Ens.Director).GetProductionSettingValue("","Bar",.status)  zw status
```

Set settings programmatically:
```
set prodname = "OSEX.IOP.Production.ExtraProperties"
set prodconf = ##class(Ens.Config.Production).%OpenId(prodname,,.status)  zw status
// this is important!
zw prodconf.PopulateVirtualSettings()

set newvalue = ##class(Ens.Config.Setting).%New()
set newvalue.Name = "Foo"
set newvalue.Value = "VALUE1"
zw prodconf.Settings.SetAt(newvalue,1)

zw prodconf.%Save()
```

`prodconf.Settings` is `%Collection.ListOfObj` of `Ens.Config.Setting` objects. See [Working with Collection Classes](https://docs.intersystems.com/irislatest/csp/docbook/DocBook.UI.Page.cls?KEY=GOBJ_propcoll). See [`OSEX.IOP.Production.ExtraProperties.Tools`](../src/OSEX.IOP.Production.ExtraProperties.Tools.cls) for complete example.
