/// <p>Poor man's retry #2.</p>
/// <p>Operation and retry state is kept in a separate iterable object
/// (<class>OSEX.Retry2.State</class>). Failed operation is not retried
/// immediatelly but only after all other operations have been tried too.</p>
Class OSEX.Retry2
{

ClassMethod Main()
{
    // initialiase the state
    set initialState = [
        {"operation": 1, "state": "INITIAL", "retryCountLeft": 3},
        {"operation": 3, "state": "INITIAL", "retryCountLeft": 3},
        {"operation": 5, "state": "INITIAL", "retryCountLeft": 3},
        {"operation": 7, "state": "INITIAL", "retryCountLeft": 3},
        {"operation": 9, "state": "INITIAL", "retryCountLeft": 3}
    ]
    set operationState = ##class(OSEX.Retry2.State).%New(initialState)

    // iterate and operate
    while (operationState.GetNext(.key, .value)) {
        try {
            write "Main(): BEGIN operating #",key," ",value.%ToJSON(),!
            do ..DoStuff(value.operation)
            do operationState.MarkOperationSucceeded(value.operation)
            write "Main(): END operating #",key,!
        } catch (ex) {
            write "Main(): caught exception ",..ToStr(ex),!
            do operationState.MarkOperationFailed(value.operation)
        }
    }

    // just the reporting
    write "Main(): final state:",!
    set iter = operationState.GetState().%GetIterator()

    while (iter.%GetNext(.key, .value)) {
        write "  key: ",key," value: ",value.%ToJSON(),!
    }
}

ClassMethod DoStuff(number As %Integer = 0)
{
    write "  DoStuff(): number=",number,!
    set x = number / $random(2) // sometimes fails on purpose
    write "  DoStuff(): x=",x,!
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
