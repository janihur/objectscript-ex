/// Over-engineered class query.
/// 
/// <h2>1/2 Using ClassMethod</h2>
/// 
/// <p>Create an action object that defines the query and collects the results.
/// The action object have to implement an interface (that is not documented).</p>
/// 
/// <example>
/// set action = ##class(OSEX.Tools.ClassQuery.FileSetAction).%New("/tmp","*.json")
/// do ##class(OSEX.Tools.ClassQuery).Query(action)
/// </example>
/// 
/// <p>See <code>action</code> for the results.</p>
/// 
/// <h2>2/2 Using Object</h2>
/// 
/// <p>Create an action object that collects the results. The action object
/// have to implement an interface (that is not documented).</p>
/// 
/// <example>
/// set cq = ##class(OSEX.Tools.ClassQuery).%New("%File","FileSet")
/// set action = ##class(OSEX.Tools.ClassQuery.FileSetAction).%New()
/// do cq.Execute(action, "/tmp","*.json")
/// do cq.Execute(action, "/tmp","*.xml")
/// </example>
/// 
/// <p>See <code>action</code> for the results.</p>
Class OSEX.Tools.ClassQuery Extends %RegisteredObject
{

Property stmt As %SQL.Statement [ Private ];

/// <example>
/// Query("%File","FileSet")
/// Query("%RoutineMgr","StudioOpenDialog")
/// </example>
ClassMethod Query(action As %RegisteredObject)
{
    set stmt = ##class(%SQL.Statement).%New()

    // ------------------------------------------------------------------------

    set status = stmt.%PrepareClassQuery(action.QueryClass, action.QueryName)

    if ($$$ISERR(status)) {
        write "%PrepareClassQuery failed:"
        do $SYSTEM.Status.DisplayError(status)
        return
    }  

    // ------------------------------------------------------------------------

    #dim rset as %SQL.StatementResult = action.Execute(stmt)

    if (rset.%SQLCODE '= 0) {
        write "%Execute failed:", !, "SQLCODE ", rset.%SQLCODE, ": ", rset.%Message
        return
    }

    // ------------------------------------------------------------------------

    while (rset.%Next()) {
        do action.Action(rset)
    }

    if (rset.%SQLCODE < 0) {
        write "%Next failed:", !, "SQLCODE ", rset.%SQLCODE, ": ", rset.%Message 
        return
    }

    do rset.%Close()
}

Method %OnNew(
	queryClass As %String,
	queryName As %String,
	action As %RegisteredObject) As %Status
{
    set ..stmt = ##class(%SQL.Statement).%New()
    return ..stmt.%PrepareClassQuery(queryClass, queryName)
}

Method Execute(
	action As %RegisteredObject,
	args...)
{
    set rset = ..stmt.%Execute(args...)

    if (rset.%SQLCODE '= 0) {
        write "%Execute failed:", !, "SQLCODE ", rset.%SQLCODE, ": ", rset.%Message
        return
    }

    // ------------------------------------------------------------------------

    while (rset.%Next()) {
        do action.Action(rset)
    }

    if (rset.%SQLCODE < 0) {
        write "%Next failed:", !, "SQLCODE ", rset.%SQLCODE, ": ", rset.%Message 
        return
    }

    do rset.%Close()
}

Method Execute2(args...) As %SQL.StatementResult
{
    return ..stmt.%Execute(args...)
}

/// Class method example
/// Class query: %File FileSet
/// https://docs.intersystems.com/irislatest/csp/docbook/DocBook.UI.Page.cls?KEY=GFILE_dirsdrives#GFILE_dirsdrives_filesetquery
ClassMethod Ex1()
{
    set action = ##class(OSEX.Tools.ClassQuery.FileSetAction).%New("/tmp","*.txt")
    do ##class(OSEX.Tools.ClassQuery).Query(action)
    
    do action.GetFilesMd(.files)
    zwrite files
}

/// Object example #1
/// Class query: %File FileSet
/// https://docs.intersystems.com/irislatest/csp/docbook/DocBook.UI.Page.cls?KEY=GFILE_dirsdrives#GFILE_dirsdrives_filesetquery
ClassMethod Ex2()
{
    set cq = ##class(OSEX.Tools.ClassQuery).%New("%File","FileSet")
    set action = ##class(OSEX.Tools.ClassQuery.FileSetAction).%New()

    // ------------------------------------------------------------------------

    do cq.Execute(action, "/tmp", "foo*.txt")
    
    do action.GetFilesMd(.files)
    write "---",!
    zwrite files

    // ------------------------------------------------------------------------

    do cq.Execute(action, "/tmp", "bar*.txt")
    
    do action.GetFilesMd(.files)
    write "---",!
    zwrite files
}

/// Object example #2
/// Class query: %RoutineMgr StudioOpenDialog
/// https://docs.intersystems.com/iris20242/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25Library.RoutineMgr#StudioOpenDialog
ClassMethod Ex3()
{
    #dim rset as %SQL.StatementResult = ##class(OSEX.Tools.ClassQuery).%New("%RoutineMgr","StudioOpenDialog").Execute2("OSEX*.cls,OSEX*.inc",,,0,1)

    // ------------------------------------------------------------------------

    if (rset.%SQLCODE '= 0) {
        write "%Execute failed:", !, "SQLCODE ", rset.%SQLCODE, ": ", rset.%Message
        return
    }

    while (rset.%Next()) {
        write "name: ", rset.%Get("Name")
        write " type: ", rset.%Get("Type")

        write !
    }

    do rset.%Close()
}

}
