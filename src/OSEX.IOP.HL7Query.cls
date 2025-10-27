Class OSEX.IOP.HL7Query Extends %Persistent
{

Query AllStatic() As %Query(CONTAINID = 1, ROWSPEC = "Id:%String,Prop1:%String,Prop2:%Integer") [ SqlName = AllStatic, SqlProc ]
{
}

ClassMethod AllStaticExecute(ByRef qHandle As %Binary) As %Status
{
    &sql(DECLARE C CURSOR FOR
        SELECT 1, 'foo', 'bar'
     )
     &sql(OPEN C)
    Quit $$$OK
}

ClassMethod AllStaticFetch(
	ByRef qHandle As %Binary,
	ByRef Row As %List,
	ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = AllStaticExecute ]
{
    #; INTO must be with FETCH
    &sql(FETCH C INTO :Id, :Prop1, :Prop2)
    #; Check if we reached end of data
    If (SQLCODE'=0) {
        Set AtEnd = 1
        Set Row = ""
        Quit $$$OK
    }
    Set Row = $Lb(Id, Prop1, Prop2)
    Quit $$$OK
}

ClassMethod AllStaticClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = AllStaticFetch ]
{
    &sql(CLOSE C)
    Quit $$$OK
}

// select * from OSEX_IOP.MarkoQ('Mylab.EI.TransmissionPermitRegister.HL7In.Process', 'PID(1):2') order by SessionId desc

Query MarkoQ(
	configName As %String,
	hl7Query As %String) As %Query(CONTAINID = 1, ROWSPEC = "TimeCreated:%String,Type:%String,MessageBodyClassName:%String,MessageBodyId:%Integer,SessionId:%Integer,Value:%String") [ SqlName = MarkoQ, SqlProc ]
{
}

ClassMethod MarkoQExecute(
	ByRef handle As %Binary,
	configName As %String,
	hl7Query As %String) As %Status
{
	&sql(declare cur cursor for 
		select
		 TimeCreated
		,case 
			when Type = 1 then 'REQUEST'
			when Type = 2 then 'RESPONSE'
			else               'UNKNOWN'
		 end as Type
		--,SourceConfigName 
		--,TargetConfigName 
		,MessageBodyClassName
		,MessageBodyId
		,SessionId 
		,:hl7Query
		from Ens.MessageHeader 
		where TargetConfigName = :configName
	)

	&sql(open cur)
	return $$$OK
}

ClassMethod MarkoQFetch(
	ByRef qHandle As %Binary,
	ByRef Row As %List,
	ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = MarkoQExecute ]
{
	&sql(fetch cur into :timeCreated, :type, :messageBodyClassName, :messageBodyId, :sessionId, :hl7Query)
	if (SQLCODE '= 0) {
		set AtEnd = 1
		set Row = ""
		return $$$OK
	}

	set value = ""

	if (messageBodyClassName = "EnsLib.HL7.Message") {
		set obj = $classmethod(messageBodyClassName, "%OpenId", messageBodyId, 1) // concurrency is atomic read
		set value = obj.FindSegmentValues(hl7Query, obj.Separators, .status)
	}

	set Row = $listbuild(timeCreated, type, messageBodyClassName, messageBodyId, sessionId, value)
	return $$$OK
}

ClassMethod MarkoQClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = MarkoQFetch ]
{
	&sql(close cur)
	return $$$OK
}

Storage Default
{
<Data name="HL7QueryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^OSEX.IOP.HL7QueryD</DataLocation>
<DefaultData>HL7QueryDefaultData</DefaultData>
<IdLocation>^OSEX.IOP.HL7QueryD</IdLocation>
<IndexLocation>^OSEX.IOP.HL7QueryI</IndexLocation>
<StreamLocation>^OSEX.IOP.HL7QueryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
