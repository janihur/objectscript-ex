/// class for ##class(OSEX.Tools.DirWalk).Walk() to collect file names
Class OSEX.Tools.DirWalk.Action Extends %RegisteredObject
{

Property files [ MultiDimensional, Private ];

Method Action(name As %String, type As %String)
{
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
