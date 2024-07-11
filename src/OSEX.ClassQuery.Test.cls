/// https://docs.intersystems.com/irislatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25SQL.Statement
/// https://docs.intersystems.com/irislatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25SQL.StatementResult
Class OSEX.ClassQuery.Test Extends %RegisteredObject
{

ClassMethod Test1()
{
    #; do ##class(OSEX.ClassQuery).%New("foo1", 42).%Save()
    #; do ##class(OSEX.ClassQuery).%New("foo1", 52).%Save()
    #; do ##class(OSEX.ClassQuery).%New("foo1", 62).%Save()

    set statement = ##class(%SQL.Statement).%New()   
    set status = statement.%PrepareClassQuery("OSEX.ClassQuery","ByFoo")   
    if $$$ISERR(status) {
        do $system.OBJ.DisplayError(status)
        return
    }

    #dim rs as %SQL.StatementResult = $$$NULLOREF
    
    set rs = statement.%Execute("foo1")
    write "%SQLCODE: ",rs.%SQLCODE,!
    write "%Message: ",rs.%Message,!

    write "--- %Display()"
    do rs.%Display()
    write !

    write "--- iterate with %Next()",!

    set rs = statement.%Execute("foo1")
    while rs.%Next() {
        write rs.%Get("ID"), ": ", rs.%Get("Foo"), ": ", rs.%Get("Bar")
        write !
    }

    write "--- use automatically generated query function",!
    set rs = ##class(OSEX.ClassQuery).ByFooFunc("foo1")
    while rs.%Next() {
        write rs.%Get("ID"), ": ", rs.%Get("Foo"), ": ", rs.%Get("Bar")
        write !
    }
}

/// query mapped packages
/// https://docs.intersystems.com/iris20221/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=Config.MapPackages#List
ClassMethod Ex1()
{
    new $namespace
    set $namespace = "%SYS"

    set statement = ##class(%SQL.Statement).%New()
    set status = statement.%PrepareClassQuery("Config.MapPackages","List")
    if $$$ISERR(status) {
        do $system.OBJ.DisplayError(status)
        return
    }

    set rs = statement.%Execute("OSEX")

    while (rs.%Next()) {
        write rs.%Get("Name")_", "_rs.%Get("Package")_", "_rs.%Get("Database")
        write !
    }
}

}
