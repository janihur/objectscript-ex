# Unit Testing

## Running Unit Tests

[Unit Testing with %UnitTest](https://docs.intersystems.com/irislatest/csp/docbook/DocBook.UI.Page.cls?KEY=TUNT_WhatIsPercentUnitTest).

```
NAMESPACE>set ^UnitTestRoot = "<REPO_ROOT_DIR>/objectscript-ex/src"
NAMESPACE>do ##class(%UnitTest.Manager).RunTest(,"/nodelete")
NAMESPACE>do ##class(%UnitTest.Manager).RunTest(":codeGolf.unitTest.ChineseZodiac", "/nodelete")
```
