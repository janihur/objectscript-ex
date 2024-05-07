# objectscript-ex

InterSystems [IRIS](https://www.intersystems.com/data-platform/) and [ObjectScript](https://docs.intersystems.com/irislatest/csp/docbook/DocBook.UI.Page.cls?KEY=GCOS_intro) code snippets and examples.

## ObjectScript Code Management

Code management operations are part of [`%SYSTEM.OBJ`](https://docs.intersystems.com/irislatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25SYSTEM.OBJ) class.

|Operation|Command|Details|
|---------|-------|-------|
|Import   |`do $system.OBJ.ImportDir("<DIR>",,"/compile=1",,1)`|Import all code in `<DIR>` directory recursively to server.|
|Export   |`do ##class(OSEX.Export).ExportClasses("<REGEX>","<DIR>")`|Export all class code to `<DIR>` directory from server where `<REGEX>` have to match the whole class name. E.g. all classes of `OSEX`top level package: `OSEX\..*`.|
|Delete   |`do $system.OBJ.DeletePackage("<PACKAGE>")`|Delete all classes of the specified `<PACKAGE>` from server.|

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

|Operation|Command|Details|
|---------|-------|-------|
|Start    |`do ##class(Ens.Director).StartProduction("OSEX.IOP.Production")`||
|Remove   |`do ##class(Ens.Director).DeleteProduction("OSEXPKG.FoundationProduction")`||
|Restart  |`do ##class(Ens.Director).RestartProduction()`||

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