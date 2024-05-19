/// Calculate the Fibonacci sequence using a recursive function and memoization.
/// https://en.wikipedia.org/wiki/Fibonacci_sequence
Class OSEX.Fibonacci2 Extends %RegisteredObject
{

Property cache [ MultiDimensional, Private ];

Method %OnNew() As %Status
{
    set ..cache(0) = 0
    set ..cache(1) = 1

    return $$$OK
}

Method Fib(n As %Integer = 10)
{
    if ((1 > n) || (n > 701)) {
        write "Invalid input. Please enter a number between 1 and 701.",!
        return
    }

    for i = 0:1:n-1
    {
        write ..impl(i),!
    }
}

Method impl(n As %Integer) As %Integer [ Private ]
{
    if ($data(..cache(n))) {
        return ..cache(n)
    }

    set ..cache(n) = ..impl(n-1) + ..impl(n-2)

    return ..cache(n)
}

}
