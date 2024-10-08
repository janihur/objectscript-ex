/// <p>Simple iterator for <class>OSEX.Fibonacci3</class>.</p>
/// <p>Mimics the iterator interface for of <class>%Library.DynamicObject</class>.</p>
Class OSEX.Fibonacci3.Iterator Extends %RegisteredObject
{

Property currentIter As %Integer [ InitialExpression = 1, Private ];

/// <p>Inclusive end limit.</p>
Property end As %Integer [ Private ];

Property obj As OSEX.Fibonacci3 [ Private ];

ClassMethod GetIterator(
	start As %Integer = 1,
	end As %Integer = 701) As OSEX.Fibonacci3.Iterator
{
    set fib = ##class(OSEX.Fibonacci3).%New()
    return ##class(OSEX.Fibonacci3.Iterator).%New(fib,start,end)
}

/// <p><code>start</code> and <code>end</code> limits are inclusive.</p>
Method %OnNew(
	fib As OSEX.Fibonacci3,
	start As %Integer = 1,
	end As %Integer = 701) As %Status
{
    set ..obj = fib
    set ..currentIter = start
    set ..end = end

    return $$$OK
}

Method GetNext(Output num As %Integer) As %Boolean
{
    if (..currentIter > ..end) {
        return 0
    }

    set num = ..obj.Fib(..currentIter)
    set ..currentIter = ..currentIter + 1

    return 1
}

/// <p>Usage example.</p>
ClassMethod Ex1()
{
    set i = 1
    set fib = ##class(OSEX.Fibonacci3).%New()
    set iter = ##class(OSEX.Fibonacci3.Iterator).%New(fib,i,i-1+12)

    while (iter.GetNext(.num)) {
        write i,": ",num,!
        do $increment(i,1)
    }
}

/// <p>Usage example.</p>
ClassMethod Ex2()
{
    set i = 1
    set iter = ##class(OSEX.Fibonacci3.Iterator).GetIterator(i,i-1+12)

    while (iter.GetNext(.num)) {
        write i,": ",num,!
        do $increment(i,1)
    }
}

}
