/// https://community.intersystems.com/post/code-golf-chinese-zodiac-cycle
Class codeGolf.ChineseZodiac
{

ClassMethod Calendar(y As %Integer) As %String
{
	set calendar(0, "element") = "Wood"
	set calendar(1, "element") = "Wood"
	set calendar(2, "element") = "Fire"
	set calendar(3, "element") = "Fire"
	set calendar(4, "element") = "Earth"
	set calendar(5, "element") = "Earth"
	set calendar(6, "element") = "Metal"
	set calendar(7, "element") = "Metal"
	set calendar(8, "element") = "Water"
	set calendar(9, "element") = "Water"

	set calendar(0, "animal") = "Rat"
	set calendar(1, "animal") = "Ox"
	set calendar(2, "animal") = "Tiger"
	set calendar(3, "animal") = "Rabbit"
	set calendar(4, "animal") = "Dragon"
	set calendar(5, "animal") = "Snake"
	set calendar(6, "animal") = "Horse"
	set calendar(7, "animal") = "Goat"
	set calendar(8, "animal") = "Monkey"
	set calendar(9, "animal") = "Rooster"
	set calendar(10, "animal") = "Dog"
	set calendar(11, "animal") = "Pig"

	set elementIndex = ($zabs(1924-y))#10

	set animalIndex = ($zabs(1924-y))#12

	return calendar(elementIndex, "element")_" "_calendar(animalIndex, "animal")
}

}
