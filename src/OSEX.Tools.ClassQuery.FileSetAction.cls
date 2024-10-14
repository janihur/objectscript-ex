/// <p>A companion class for <class>OSEX.Tools.ClassQuery</class>.</p>
Class OSEX.Tools.ClassQuery.FileSetAction Extends %RegisteredObject
{

/// parameters for statement %PrepareClassQuery
Property QueryClass As %String [ InitialExpression = "%File" ];

Property QueryName As %String [ InitialExpression = "FileSet" ];

/// parameters for class query %Execute
Property directory As %String [ Private ];

Property wildcards As %String [ Private ];

/// collected action results
Property files [ MultiDimensional, Private ];

Method %OnNew(
	directory As %String = "",
	wildcards As %String = "") As %Status
{
    set ..directory = directory
    set ..wildcards = wildcards
    return $$$OK
}

Method Execute(stmt As %SQL.Statement) As %SQL.StatementResult
{
    return stmt.%Execute(..directory, ..wildcards)
}

Method Action(rset As %SQL.StatementResult)
{
    set name = rset.%Get("Name")
    set type = rset.%Get("Type")

    if (type = "F") {
        set ..files(name) = ""
    }
}

Method GetFilesMd(Output files)
{
    set name = $order(..files(""))
    while (name '= "") {
        set files(name) = ""
        set name = $order(..files(name))
    }
}

Method GetFilesList() As %ListOfDataTypes
{
    set list = ##class(%ListOfDataTypes).%New()
    set name = $order(..files(""))
    while (name '= "") {
        do list.Insert(name)
        set name = $order(..files(name))
    }
    return list
}

}
