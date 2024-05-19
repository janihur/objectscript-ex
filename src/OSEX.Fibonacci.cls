/// Different ways to calculate the Fibonacci sequence.
/// https://en.wikipedia.org/wiki/Fibonacci_sequence
Class OSEX.Fibonacci Extends %RegisteredObject
{

/// Calculate the Fibonacci sequence using a for loop.
ClassMethod F1(n As %Integer = 10)
{
    set a = 0
    set b = 1

    for i = 0:1:n-1
    {
        if (i < 2) { 
            write i,!
            continue
        }
        set c = a + b
        set a = b
        set b = c

        write c,!
    }
}

/// Calculate the Fibonacci sequence using a while loop.
ClassMethod F2(n As %Integer = 10)
{
    set a = 0
    set b = 1

    set i = 0
    while (i < n)
    {
        if (i < 2) { 
            write i,!
        } else {
            set c = a + b
            set a = b
            set b = c

            write c,!
        }
        set i = i + 1
    }
}

/// Calculate the Fibonacci sequence using a do-while loop.
ClassMethod F3(n As %Integer = 10)
{
    set a = 0
    set b = 1

    set i = 0

    do {
        if (i < 2) { 
            write i,!
        } else {
            set c = a + b
            set a = b
            set b = c

            write c,!
        }
        set i = i + 1
    } while (i < n)
}

/// Calculate the Fibonacci sequence using recursion.
ClassMethod F4(n As %Integer = 10)
{
    for i = 0:1:n-1
    {
        write ..f4Impl(i),!
    }
}

ClassMethod f4Impl(n As %Integer) As %Integer [ Private ]
{
    if (n < 2) { 
        return n
    }

    return ..f4Impl(n-1) + ..f4Impl(n-2)
}

}
