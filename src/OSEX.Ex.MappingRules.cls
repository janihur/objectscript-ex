/// <p>How to separate the mapping rules and mapping operation.</p>
Class OSEX.Ex.MappingRules
{

ClassMethod GetMappingRules(
	ruleName As %String,
	ByRef rules)
{
	kill rules
	if (ruleName = "NUMBERS") {
		set rules = 0 // default value
		set rules("alpha")   = "1"
		set rules("bravo")   = "2"
		set rules("charlie") = "3"
	} elseif (ruleName = "LETTERS") {
		set rules = "-" // default value
		set rules("alpha")   = "A"
		set rules("bravo")   = "B"
		set rules("charlie") = "C"
	}
}

ClassMethod Map(
	value As %String,
	ByRef rules = "") As %String
{
	if ($data(rules) = 11) { // rules are defined
		if ($data(rules(value))) { // value mapping
			return rules(value)
		} else { // default value mapping
			return rules
		}
	}
	return value // no mapping -> return original value
}

ClassMethod Run(ruleName As %String = "")
{
	do ..GetMappingRules(ruleName,.rules)
	zw rules
	write "alpha   -> ", ..Map("alpha",.rules), !
	write "bravo   -> ", ..Map("bravo",.rules), !
	write "charlie -> ", ..Map("charlie",.rules), !
	write "delta   -> ", ..Map("delta",.rules), !
}

}
