/// a poor man's retry
Class OSEX.Retry
{

ClassMethod Main()
{
    set numbers = ##class(%ArrayOfDataTypes).%New()
    do numbers.SetAt(1,1)
    do numbers.SetAt(3,2)
    do numbers.SetAt(5,3)

    for i=1:1:numbers.Count() {
        write "Main(): BEGIN iteration #",i,!
        do ..Loop(numbers.GetAt(i))
        write "Main(): END iteration #",i,!
    }
}

ClassMethod Loop(number As %Integer)
{
    write "  Loop(): BEGIN number=",number,!
    set retryCount = 0
    set maxRetryCount = 3
    set retryDelay = 1
    set stop = 0 // false
    while (('stop) && (retryCount < maxRetryCount)) {
        try {
            // do something
            do ..DoStuff(number)
            set stop = 1 // true
        } catch (ex){
            #; zwrite ex
            write "  Loop(): caught exception ",..ToStr(ex),!
            do $increment(retryCount)
            write "  Loop(): retrying in ",retryDelay," seconds",!
            hang retryDelay
        }
    }
    write "  Loop(): END number=",number,!
}

ClassMethod DoStuff(number As %Integer = 0)
{
    write "    DoStuff(): number=",number,!
    set x = number / $random(2) // sometimes fails on purpose
    write "    DoStuff(): x=",x,!
}

/// stringified exception for logging
ClassMethod ToStr(ex)
{
    // https://docs.intersystems.com/irislatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25Exception.AbstractException
    set str = "displaystring:"_ex.DisplayString() // from 
    if (ex.%IsA("%Exception.SystemException")) {
        // https://docs.intersystems.com/irislatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25Exception.SystemException
        set str = str_" type:"_ex.%ClassName(1)
        set str = str_" name:"_ex.Name_"("_ex.Code_")"
        set str = str_" location:"_ex.Location
        set str = str_" data:"_ex.Data
    } else {
        set str = str_" type:"_ex.%ClassName(1)
        set str = str_" name:"_ex.Name_"("_ex.Code_")"
    }
    return str
}

}
