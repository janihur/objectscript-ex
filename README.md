# objectscript-ex
Intersystems [ObjectScript](https://docs.intersystems.com/irislatest/csp/docbook/DocBook.UI.Page.cls?KEY=GCOS_intro) code snippets and examples.

## Export

```
NAMESPACE>do ##class(OSEX.Export).ExportClasses("OSEX\..*","/output/path")
```

## Running Unit Tests

[Unit Testing with %UnitTest](https://docs.intersystems.com/irislatest/csp/docbook/DocBook.UI.Page.cls?KEY=TUNT_WhatIsPercentUnitTest).

```
NAMESPACE>set ^UnitTestRoot = "<ABSOLUTE_ROOT_PATH>"
NAMESPACE>do ##class(%UnitTest.Manager).RunTest("<SUB_DIR>", "/nodelete")
```
