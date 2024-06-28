Class OSEX.StringBuilder.Test Extends %RegisteredObject
{

ClassMethod Test1()
{
    set sb = ##class(OSEX.StringBuilder).%New("initialvalue")
    write sb.Append("string1").Append("string2").ToString()

    write !, ##class(OSEX.StringBuilder).%New("initialvalue").Append("string1").Append("string2").ToString()
}

ClassMethod Test2()
{
    set sb = ##class(OSEX.StringBuilder).%New()
    set sb.Separator = ";"
    write sb.Append("string1").Append("string2").ToString()
}

ClassMethod Test3()
{
    set sb1 = ##class(OSEX.StringBuilder).%New("sb1")
    do sb1.Append("string1").Append("string2")

    set sb2 = ##class(OSEX.StringBuilder).%New("sb2")
    do sb2.Append("string3").Append("string4")

    write sb1.Append(sb2).ToString()
}

ClassMethod Test4()
{
    set httpResponse = ##class(%Net.HttpResponse).%New()
    set sb = ##class(OSEX.StringBuilder).%New()

    write sb.Append(httpResponse,1).ToString()
}

ClassMethod Test5()
{
    set sb = ##class(OSEX.StringBuilder).%New()
    write sb.Append(sb.KvN("key1", 42)).Append(sb.Kv("key2", "1st fortytwo")).Append(sb.KvS("key2", "2nd fortytwo")).ToString()
}

ClassMethod Test6()
{
    set sb = ##class(OSEX.StringBuilder).%New()
    write sb.AppendKv("key1", "val1").AppendKv("key2", "val2").ToString()
}

ClassMethod Test7()
{
    set x(1) = "one"
    set x(2) = "two"
    set x(3) = "three"
    
    set x(1, "fr") = "un/une"
    set x(2, "fr") = "deux"
    set x(3, "fr") = "trois"

    set x(1, "de") = "eins"
    set x(2, "de") = "zwei"
    set x(3, "de") = "drei"

    set sb = ##class(OSEX.StringBuilder).%New()
    write sb.AppendMd(.x).ToString()
}

}
