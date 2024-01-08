/// https://community.intersystems.com/post/code-golf-parenthesis
Class codeGolf.ParenthesisHell
{

ClassMethod IsValid(s As %String) As %Boolean
{
    set c = 0
    for i=1:1:$length(s) {
	    set char = $extract(s,i)
	    if (char = "(") {
		    set c = c + 1
	    } elseif (char = ")") {
		    set c = c - 1
	    }
	    // write "(char """_char_""")(c "_c_")",!
	    if (c < 0) {
		    return 0
	    }
    }
    return (c = 0)
}

}
