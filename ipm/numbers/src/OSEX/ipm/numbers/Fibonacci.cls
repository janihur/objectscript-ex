Class OSEX.ipm.numbers.Fibonacci Extends %Persistent
{

Property cache [ MultiDimensional, Private ];

Method %OnNew() As %Status
{
    set ..cache(1) = 0
    set ..cache(2) = 1

    return $$$OK
}

/// <p>Return nth Fibonacci number.</p>
Method Fib(n As %Integer = 10) As %Integer
{
    if ((1 > n) || (n > 701)) {
        throw ##class(OSEX.Exception).%New("Invalid input. Please enter a number between 1 and 701.")
    }

    if ($data(..cache(n))) {
        return ..cache(n)
    }

    for i = 1:1:n
    {
        set num = ..impl(i)
    }

    return num
}

Method impl(n As %Integer) As %Integer [ Private ]
{
    if ($data(..cache(n))) {
        return ..cache(n)
    }

    set ..cache(n) = ..impl(n-1) + ..impl(n-2)

    return ..cache(n)
}

Storage Default
{
<Data name="FibonacciDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^OSEX.ipm.numbers.FibonacciD</DataLocation>
<DefaultData>FibonacciDefaultData</DefaultData>
<IdLocation>^OSEX.ipm.numbers.FibonacciD</IdLocation>
<IndexLocation>^OSEX.ipm.numbers.FibonacciI</IndexLocation>
<StreamLocation>^OSEX.ipm.numbers.FibonacciS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
