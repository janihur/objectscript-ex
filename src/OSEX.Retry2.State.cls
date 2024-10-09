/// <p>Encapsulates the iteration and manipulation of the following JSON
/// structure (array of objects):</p>
/// 
/// <example>
/// [
///   {"operation": 1, "state": "INITIAL", "retryCountLeft": 3},
///   {"operation": 3, "state": "INITIAL", "retryCountLeft": 3},
///   {"operation": 5, "state": "INITIAL", "retryCountLeft": 3}
/// ]
/// </example>
/// 
/// <p>Where <code>state</code> could be one of the following</p>
/// 
/// <example>
/// INIATIAL --> SUCCESS
/// INIATIAL --> RETRY --> SUCCESS
///               ^--/ \-> FAILURE
/// </example>
/// 
/// See <class>OSEX.Retry2</class> for the indented usage.
Class OSEX.Retry2.State Extends %RegisteredObject
{

Property stateIter As %Iterator.Array [ Private ];

Property state As %DynamicArray [ Private ];

/// <p>Makes a deep copy of <code>initialState</code>.</p>
Method %OnNew(initialState As %DynamicArray) As %Status
{
    // DIY deep copy
    // https://community.intersystems.com/post/how-clone-dynamic-objects#comment-246441
    set tmpStream = ##class(%Stream.TmpCharacter).%New()
    do initialState.%ToJSON(tmpStream)
    set ..state = [].%FromJSON(tmpStream)

    set ..stateIter = ..state.%GetIterator()
    
    return $$$OK
}

Method GetNext(Output operation As %Integer) As %Boolean
{
    while (..stateIter.%GetNext(.key, .value)) {
        if ((value.state = "INITIAL")||(value.state = "RETRY")) {
            set operation = value.operation
            return 1
        }
    }
    if (..IsOperationsLeft()) {
        set ..stateIter = ..state.%GetIterator()
        return ..GetNext(.operation)
    }
    return 0
}

Method IsOperationsLeft() As %Boolean
{
    #dim iter as %Iterator.Array = ..state.%GetIterator()
    while (iter.%GetNext(.key, .value)) {
        if ((value.state = "INITIAL")||(value.state = "RETRY")) {
            return 1
        }
    }
    return 0
}

Method MarkOperationSucceeded(operation As %Integer)
{
    do ..setNextStateFor(operation, 1)
}

Method MarkOperationFailed(operation As %Integer)
{
    do ..setNextStateFor(operation, 0)
}

Method GetState() As %DynamicArray
{
    // TODO: return a deep copy
    return ..state
}

Method setNextStateFor(
	operation As %Integer,
	success As %Boolean) [ Private ]
{
    #dim iter as %Iterator.Array = ..state.%GetIterator()
    while (iter.%GetNext(.key, .value)) {
        if (value.operation = operation) {
            #; write "old value: ",value.%ToJSON(),!
            if (success) {
                // just for consistentcy in bookkeeping
                if ((value.state = "RETRY")&&(value.retryCountLeft > 0)) {
                    set value.retryCountLeft = value.retryCountLeft - 1
                }
                set value.state = "SUCCESS"
            } else { // error
                if (value.state = "RETRY") {
                    if (value.retryCountLeft > 1) {
                        set value.retryCountLeft = value.retryCountLeft - 1
                    } else {
                        set value.state = "FAILURE"
                        set value.retryCountLeft = 0
                    }
                } else {
                    set value.state = "RETRY"
                }
            }
            #; write "new value: ",value.%ToJSON(),!
            return
        }
    }
}

ClassMethod Ex1()
{
    do ..GetExampleData1(.state)

    set operationState = ##class(OSEX.Retry2.State).%New(state)

    while (operationState.GetNext(.operation)) {
        write "operating: ",operation,!
        set isError = ($random(2) = 1) // 50% chance of error
        if (isError) {
            do operationState.MarkOperationFailed(operation)
        } else {
            do operationState.MarkOperationSucceeded(operation)
        }
    }
    
    write "final state --- ",!
    set iter = operationState.GetState().%GetIterator()

    while (iter.%GetNext(.key, .value)) {
        write "key: ",key," value: ",value.%ToJSON(),!
    }
}

ClassMethod GetExampleData1(Output json As %DynamicArray)
{
    set json = [
        {"operation": 1, "state": "INITIAL", "retryCountLeft": 3},
        {"operation": 3, "state": "INITIAL", "retryCountLeft": 3},
        {"operation": 5, "state": "INITIAL", "retryCountLeft": 3},
        {"operation": 7, "state": "INITIAL", "retryCountLeft": 3},
        {"operation": 9, "state": "INITIAL", "retryCountLeft": 3}
    ]
}

ClassMethod GetExampleData2(Output json As %DynamicArray)
{
    set json = [
        {"operation": 1, "state": "INITIAL", "retryCountLeft": 3}
    ]
}

}
