Include OSEX

/// <p><a href="https://docs.intersystems.com/irislatest/csp/docbook/DocBook.UI.Page.cls?KEY=GCOS_usercode#GCOS_usercode_args_variable">Variable Number of Parameters</a></p>
Class OSEX.VarArgs
{

ClassMethod Ex1()
{
    write "#1 ---",!
    write ..Join("key1", "val1", "key2", "val2", "key3"),!

    write "#2 ---",!
    write ..Join2("key1", 1, "key2", 2),!
}

ClassMethod Join(args... As %String) As %String
{
    set isEven = '(args#2)
    set str = ""
    set isKey = 1
    for i=1:1:$get(args,0) {
        if (isKey) {
            set str = str_"("
            set str = str_$get(args(i))
            set str = str_" "
            set isKey = 0
        } else {
            set str = str_$get(args(i))
            set str = str_")"
            set isKey = 1
        }
    }
    if ('isEven) {
        set str = str_""""")"
    }
    return str
}

/// <p>Example how to pass varargs.</p>
ClassMethod Join2(args... As %String) As %String
{
    return ..Join(args...)
}

}
