# objectscript-ex

InterSystems [IRIS](https://www.intersystems.com/data-platform/) and [ObjectScript](https://docs.intersystems.com/irislatest/csp/docbook/DocBook.UI.Page.cls?KEY=GCOS_intro) code snippets and examples.

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

## Import

Import all code in `<DIR>` recursively:
```
NAMESPACE>do $system.OBJ.ImportDir("<DIR>",,"/compile=1",,1)
```

## Export

```
NAMESPACE>do ##class(OSEX.Export).ExportClasses("OSEX\..*","/output/path")
```

## Running Unit Tests

[Unit Testing with %UnitTest](https://docs.intersystems.com/irislatest/csp/docbook/DocBook.UI.Page.cls?KEY=TUNT_WhatIsPercentUnitTest).

```
NAMESPACE>set ^UnitTestRoot = "<REPO_ROOT_DIR>/objectscript-ex/src"
NAMESPACE>do ##class(%UnitTest.Manager).RunTest(,"/nodelete")
NAMESPACE>do ##class(%UnitTest.Manager).RunTest(":codeGolf.unitTest.ChineseZodiac", "/nodelete")
```
