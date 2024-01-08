Class codeGolf.unitTest.ChineseZodiac Extends %UnitTest.TestCase
{

Method TestSolutions()
{
        Do $$$AssertEquals(##class(codeGolf.ChineseZodiac).Calendar(1972), "Water Rat")
        Do $$$AssertEquals(##class(codeGolf.ChineseZodiac).Calendar(1934), "Wood Dog")
        Do $$$AssertEquals(##class(codeGolf.ChineseZodiac).Calendar(2023), "Water Rabbit")
        Do $$$AssertEquals(##class(codeGolf.ChineseZodiac).Calendar(2043), "Water Pig")
        Do $$$AssertEquals(##class(codeGolf.ChineseZodiac).Calendar(1961), "Metal Ox")
        Do $$$AssertEquals(##class(codeGolf.ChineseZodiac).Calendar(2002), "Water Horse")
        Do $$$AssertEquals(##class(codeGolf.ChineseZodiac).Calendar(2016), "Fire Monkey")
}

}

