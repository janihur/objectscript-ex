# objectscript-ex

InterSystems [IRIS](https://www.intersystems.com/data-platform/) and [ObjectScript](https://docs.intersystems.com/irislatest/csp/docbook/DocBook.UI.Page.cls?KEY=GCOS_intro) code snippets and examples.

## `OSEX.IOP.Jokes`

[Interoperability](https://www.intersystems.com/data-platform/interoperability/) (IOP) production outbound HTTP REST example that uses different humorous APIs.

Relevant InterSystems documentation:
* [Introduction to Developing Productions](https://docs.intersystems.com/irislatest/csp/docbook/DocBook.UI.Page.cls?KEY=EGDV_intro)
* [Creating REST Operations in Productions](https://docs.intersystems.com/irislatest/csp/docbook/DocBook.UI.Page.cls?KEY=EREST_operation)

The production is triggered with external ObjectScript package `Runner`:
```
NAMESPACE>set status = ##class(OSEX.IOP.Jokes.Runner).Run("simpsons")
```

Mermaid [sequence diagram](https://mermaid.js.org/syntax/sequenceDiagram.html): [osex-iop-jokes.svg](osex-iop-jokes.svg)

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
