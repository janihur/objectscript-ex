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

ClassMethod Ex2()
{
    // list
    write "#1 ---",!
    do ..Join3($listbuild("key1", "val1", "key2", "val2", "key3"))
    
    // objects
    set obj1 = ##class(%Dictionary.ClassDefinition).%New()
    set obj2 = ##class(%ArrayOfDataTypes).%New()
    set obj3 = ##class(%Dictionary.ClassDefinition).%New()
    set obj4 = "BANG!"
    
    write "#2 ---",!
    do ..Join3(obj1)

    write "#3 ---",!
    do ..Join3(obj1, obj2, obj3, obj4)

    write "#4 ---",!
    do ..Join3()
}

ClassMethod Join3(args...)
{
    #dim argSize as %Integer = $get(args,0)
    #dim isList as %Boolean = $$$FALSE

    // check listness
    set:(argSize = 1) isList = $listvalid($get(args(1)))

    zwrite argSize
    zwrite isList

    // check expected object type
    if ('isList) {
        for i=1:1:argSize{
            set obj = $get(args(i))
            set isExpectedObjectType = $$$FALSE
            set:($isobject(obj)) isExpectedObjectType = obj.%IsA("%Dictionary.ClassDefinition")
            zwrite i, isExpectedObjectType
        }
    }
}

}
