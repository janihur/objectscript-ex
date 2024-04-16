/// https://docs.intersystems.com/irislatest/csp/docbook/DocBook.UI.Page.cls?KEY=RCOS_vnamespace
Class OSEX.Namespace Extends %RegisteredObject
{

ClassMethod Ex1()
{
    write "--- BEGIN Ex1() ---",!
    write "($namespace """_$namespace_""")",!

    do ..ex1Impl()

    write "($namespace """_$namespace_""")",!
    write "---  END Ex1() ---",!
}

ClassMethod ex1Impl()
{
    write "--- BEGIN ex1Impl() ---",!
    write "($namespace """_$namespace_""")",!

    new $namespace
    set $namespace="%SYS"

    // do stuff in %SYS namespace

    write "($namespace """_$namespace_""")",!
    write "---  END ex1Impl() ---",!
}

}
