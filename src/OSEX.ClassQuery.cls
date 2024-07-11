/// https://community.intersystems.com/post/class-queries-intersystems-iris
Class OSEX.ClassQuery Extends %Persistent
{

Property Foo As %String;

Property Bar As %Integer;

Method %OnNew(foo As %String = "", bar As %Integer = 0) As %Status
{
    set ..Foo = foo
    set ..Bar = bar

    return $$$OK
}

/// Description
Query ByFoo(foo As %String = "") As %SQLQuery(COMPILEMODE = "IMMEDIATE", CONTAINID = 1, ROWSPEC = "ID:%Integer,Foo:%String,Bar:%Integer", SELECTMODE = "RUNTIME") [ SqlName = OSEX_ClassQuery_ByFoo, SqlProc ]
{
    SELECT ID, Foo, Bar
    FROM OSEX.ClassQuery
    WHERE Foo = :foo
    ORDER BY Foo, Bar
}

Storage Default
{
<Data name="ClassQueryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Foo</Value>
</Value>
<Value name="3">
<Value>Bar</Value>
</Value>
</Data>
<DataLocation>^OSEX.ClassQueryD</DataLocation>
<DefaultData>ClassQueryDefaultData</DefaultData>
<IdLocation>^OSEX.ClassQueryD</IdLocation>
<IndexLocation>^OSEX.ClassQueryI</IndexLocation>
<StreamLocation>^OSEX.ClassQueryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
