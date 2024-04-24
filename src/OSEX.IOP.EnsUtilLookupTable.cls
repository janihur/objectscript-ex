/// global: ^Ens.LookupTable
/// corresponding sql table: Ens_Util.LookupTable
/// select * from Ens_Util.LookupTable
Class OSEX.IOP.EnsUtilLookupTable Extends %RegisteredObject
{

ClassMethod Ex1()
{
    set config = ##class(Ens.Util.LookupTable).%New()
    set config.TableName = ..%ClassName(1)

    set config.KeyName = "foo"
    set config.DataValue = "Value in step #1"
    zw config.%Save()

    zw ^Ens.LookupTable
}

ClassMethod Ex2()
{
    set config = ##class(Ens.Util.LookupTable).%OpenId(..%ClassName(1)_"||foo")

    // original value
    write "("_config.KeyName_" """_config.DataValue_""")",!

    // upsert
    zw ##class(Ens.Util.LookupTable).%UpdateValue(..%ClassName(1), "foo", "Value in step #2",1)
    zw ##class(Ens.Util.LookupTable).%UpdateValue(..%ClassName(1), "bar", "Value in step #2",1)

    // updated value
    write "("_config.KeyName_" """_config.DataValue_""")",!

    zw ^Ens.LookupTable
}

ClassMethod Ex3()
{
    do ##class(Ens.Util.LookupTable).%ClearTable(..%ClassName(1))

    zw ^Ens.LookupTable
}

ClassMethod Ex4()
{
    set config = ##class(Ens.Util.LookupTable).%New()
    set config.TableName = ..%ClassName(1)

    set config.KeyName = "directories"
    set config.DataValue = "/tmp/1,/tmp/2,/tmp/3"
    zw config.%Save()

    zw ^Ens.LookupTable

    kill config

    set config = ##class(Ens.Util.LookupTable).%OpenId(..%ClassName(1)_"||directories")
    
    #dim i as %Integer = 1
    for {
        #dim dir as %String = $piece(config.DataValue,",",i)
        quit:dir=""
        write "(dir """,dir,""")",!
        set i = i + 1
    }

    zw ##class(Ens.Util.LookupTable).%RemoveValue(..%ClassName(1), "directories")

    zw ^Ens.LookupTable
}

ClassMethod Ex5()
{
    set ^Ens.LookupTable(..%ClassName(1),"directories") = "/tmp/1,/tmp/2,/tmp/3"
    zw ^Ens.LookupTable

    set value = ^Ens.LookupTable(..%ClassName(1),"directories")

    #dim i as %Integer = 1
    for {
        #dim dir as %String = $piece(value,",",i)
        quit:dir=""
        write "(dir """,dir,""")",!
        set i = i + 1
    }

    kill ^Ens.LookupTable(..%ClassName(1),"directories")
    zw ^Ens.LookupTable
}

ClassMethod Ex6()
{
    set config = ##class(Ens.Util.LookupTable).%OpenId(..%ClassName(1)_"||DOESNT_EXISTS")
    zw config
    if ($ISOBJECT(config)) {
        zw config.DataValue
    } else {
        write "No such key",!
    }
}

ClassMethod Ex7()
{
    set config = ##class(Ens.Util.LookupTable).%New()
    set config.TableName = ..%ClassName(1)
    set config.KeyName = "foo"
    set config.DataValue = "Value of foo"
    do config.%Save()

    set foo = ..GetValueOr(..%ClassName(1), "foo", "default")
    write "(foo """,foo,""")",!

    set bar = ..GetValueOr(..%ClassName(1), "bar", "default")
    write "(bar """,bar,""")",!

    set zoo = ..GetValueOr(..%ClassName(1), "zoo")
    write "(zoo """,zoo,""")",!
}

ClassMethod GetValueOr(table As %String, key As %String, default As %String = "") As %String
{
    set config = ##class(Ens.Util.LookupTable).%OpenId(table_"||"_key)
    if ($ISOBJECT(config)) {
        return config.DataValue
    } else {
        return default
    }
}

}
