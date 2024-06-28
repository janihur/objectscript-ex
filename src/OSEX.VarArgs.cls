Include OSEX

Class OSEX.VarArgs
{

ClassMethod Ex1()
{
    write ..Join("key1", "val1", "key2", "val2", "key3")
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

}
