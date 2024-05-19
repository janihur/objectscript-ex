/// https://en.wikipedia.org/wiki/Recam%C3%A1n%27s_sequence
Class OSEX.Recaman
{

ClassMethod R(n)
{
    set sequence(0) = 0
    set exists(0) = 1

    for i = 1:1:n-1 {
        set candidate1 = sequence(i-1) - i
        if ((candidate1 > 0) && ($data(exists(candidate1)) = 0)) {
            set sequence(i) = candidate1
        } else { // candidate2
            set sequence(i) = sequence(i-1) + i
        }
        set exists(sequence(i)) = 1
    }

    set i = ""
    for {
        set i = $order(sequence(i))
        quit:(i = "")
        write i+1,": ",sequence(i),!
    }
}

}
