# objectscript-ex
Intersystems [ObjectScript](https://docs.intersystems.com/irislatest/csp/docbook/DocBook.UI.Page.cls?KEY=GCOS_intro) code snippets and examples.

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
