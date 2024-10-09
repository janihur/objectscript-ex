# objectscript-ex

InterSystems [IRIS](https://www.intersystems.com/data-platform/) and [ObjectScript](https://docs.intersystems.com/irislatest/csp/docbook/DocBook.UI.Page.cls?KEY=GCOS_intro) code snippets and examples.

See [doc/](doc/) directory for random notes about the language and the runtime.

## Editor (Visual Studio Code) Setting

See [`.vscode/settings.json`](.vscode/settings.json) for [InterSystems ObjectScript Extension Pack](https://marketplace.visualstudio.com/items?itemName=intersystems-community.vscode-objectscript) settings used here and [Settings Reference](https://docs.intersystems.com/components/csp/docbook/DocBook.UI.Page.cls?KEY=GVSCO_settings) for the full list.

## ObjectScript Code Management

Code management operations for ObjectScript classes are part of [`%SYSTEM.OBJ`](https://docs.intersystems.com/irislatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25SYSTEM.OBJ) class.

Classes in Management Portal:
```
System Explorer > Classes
```

|Operation|Command|Details|
|---------|-------|-------|
|Import   |`do $system.OBJ.ImportDir("<DIR>",,"/compile=1",,1)`|Import and compile all code in `<DIR>` directory recursively to server.|
|Export   |`do ##class(OSEX.Export).ExportClasses("<REGEX>","<DIR>")`|Export all class code to `<DIR>` directory from server where `<REGEX>` have to match the whole class name. E.g. all classes of `OSEX`top level package: `OSEX\..*`.|
|Delete Package|`do $system.OBJ.DeletePackage("<PACKAGES>")`|Delete all classes of the specified `<PACKAGES>` from server. `<PACKAGES>` can be a single package name, a comma separated list of package names or `* ` to delete all classes.|
|Delete Class  |`do $system.OBJ.Delete("<CLASSES>")`|Delete a class or classes from server. `<CLASSES>` can be a single class name, a comma separated list of class names or a multidimensional array of class names. Accepts `?` and `*` wildcards and not operator `'` to exclude class from deletion.|

Routines can be managed with [`%Library.Routine`](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25Library.Routine) class.

Routines in Management Portal:
```
System Explorer > Routines
```

Delete a routine:
```
zwrite ##class(%Routine).Delete("<ROUTINE>")
```

## How to Create Namespace

In Management Portal:
```
System Administration
 > Configuration
  > System Configuration
   > Namespaces
    > press button: Create New Namespace
```

Programmatically see [Config.Namespaces](https://docs.intersystems.com/iris20241/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&PRIVATE=1&CLASSNAME=Config.Namespaces) class.

See also [Namespaces and Databases](https://docs.intersystems.com/irislatest/csp/docbook/DocBook.UI.Page.cls?KEY=GORIENT_enviro).

## IOP Production Management

[Ens.Director](https://docs.intersystems.com/irislatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=ENSLIB&PRIVATE=1&CLASSNAME=Ens.Director)

|Operation|Command|Details|
|---------|-------|-------|
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

## Running Unit Tests

[Unit Testing with %UnitTest](https://docs.intersystems.com/irislatest/csp/docbook/DocBook.UI.Page.cls?KEY=TUNT_WhatIsPercentUnitTest).

```
NAMESPACE>set ^UnitTestRoot = "<REPO_ROOT_DIR>/objectscript-ex/src"
NAMESPACE>do ##class(%UnitTest.Manager).RunTest(,"/nodelete")
NAMESPACE>do ##class(%UnitTest.Manager).RunTest(":codeGolf.unitTest.ChineseZodiac", "/nodelete")
```

## `OSEX.IOP.FileExport`

[Interoperability](https://www.intersystems.com/data-platform/interoperability/) (IOP) production file operation (`EnsLib.File.PassthroughOperation`) example.

Assumes the input file encoding is UTF-8 and writes the the content to `/tmp/out` using file name specifier `%f_%Q%!+(_a)` with CP-1252 encoding.

Input file example:
```
This is foo example #1.
Stranger things: ÆÇØ.
```

Expected output file hex dump:
```
$ xxd /tmp/out/<FILE>
00000000: 5468 6973 2069 7320 666f 6f20 6578 616d  This is foo exam
00000010: 706c 6520 2331 2e0a 5374 7261 6e67 6572  ple #1..Stranger
00000020: 2074 6869 6e67 733a 20c6 c7d8 2e0a        things: .....
```

Note the unix EOL (`0a`).

The production is triggered with external ObjectScript package `Runner`:
```
NAMESPACE>zw ##class(OSEX.IOP.FileExport.Runner).Run("/tmp/foo")
```

## `OSEX.IOP.Jokes`

[Interoperability](https://www.intersystems.com/data-platform/interoperability/) (IOP) production outbound HTTP REST example that uses different humorous APIs.

Relevant InterSystems documentation:
* [Introduction to Developing Productions](https://docs.intersystems.com/irislatest/csp/docbook/DocBook.UI.Page.cls?KEY=EGDV_intro)
* [Creating REST Operations in Productions](https://docs.intersystems.com/irislatest/csp/docbook/DocBook.UI.Page.cls?KEY=EREST_operation)

The production is triggered with external ObjectScript package `Runner`:
```
NAMESPACE>zw ##class(OSEX.IOP.Jokes.Runner).Run("simpsons")
```

Mermaid [sequence diagram](https://mermaid.js.org/syntax/sequenceDiagram.html): [osex-iop-jokes.svg](osex-iop-jokes.svg)

## `OSEX.IOP.Misc`

Miscellany Interoperability (IOP) stuff:

`Misc.Operations.CustomHttpRequest` how to use custom HTTP request with `EnsLib.REST.Operation`.

Have WireMock running:
```
java -jar wiremock-standalone.jar \
 --disable-gzip \
 --no-request-journal \
 --port 8080 \
 --print-all-network-traffic \
 --root-dir wiremock/ \
 --verbose
```

Call:
```
set request = ##class(Ens.Request).%New()
set response = ##class(Ens.Response).%New()
zwrite ##class(Ens.Director).CreateBusinessService("Misc.Services.Main",.service)
zwrite service.ProcessInput(request,.response)
```

## `OSEX.IOP.UniversalExports`

[Interoperability](https://www.intersystems.com/data-platform/interoperability/) (IOP) production outbound HTTP REST example that demonstrates:
* how to transfers arbitrary long string data from one HTTP API to another one in production using [streams](https://docs.intersystems.com/irislatest/csp/docbook/Doc.View.cls?KEY=GOBJ_propstream)
* business operations' configuration is separated from production to [external service registry](https://docs.intersystems.com/irislatest/csp/docbook/DocBook.UI.Page.cls?KEY=EESB_registry_admin)
* how to decide message routing target business operations runtime based on configuration in external service registry
* how to configure external service registry programmatically

After ObjectScript code installation configure external service registry:
```
NAMESPACE>zw ##class(OSEX.IOP.UniversalExports.Util).Configure("<DIR>/osex-iop-universalexports-conf.json")
```

You can check and modify the configuration in IRIS Management Portal:
```
Home
 > Interoperability
  > Configure
   > External-Service Registry
```

Two running instances of `server.py` are required. The default configuration expects the servers running in:
* `localhost:8080`
* `localhost:8081`

`server.py` expects file `~/pg7000.txt` that can be generated e.g. with:
```
$ curl -L -o ~/pg7000.txt https://www.gutenberg.org/ebooks/7000.txt.utf-8
```

The content and size of the file is not important as long as the size is "big enough". Here I'm using [Kalevala](https://en.wikipedia.org/wiki/Kalevala) by Elias Lönnrot that is ~600KB.

The production is triggered with external ObjectScript package `Runner`:
```
NAMESPACE>zw ##class(OSEX.IOP.UniversalExports.Runner).Run("kalevala", 10)
```