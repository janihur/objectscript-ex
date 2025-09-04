/// <p>List classes by quering <class>%Dictionary.ClassDefinition</class>.</p>
/// 
Class OSEX.Tools.Code.ListClasses Extends %RegisteredObject
{

/// <p>Dynamic SQL implementation returing <class>%ListOfDataTypes</class>.</p>
ClassMethod List1() As %ListOfDataTypes
{
	set classList = ##class(%ListOfDataTypes).%New()
	set query = "SELECT ID FROM %Dictionary.ClassDefinition"
	set rs = ##class(%ResultSet).%New()
	do rs.Prepare(query)
	do rs.Execute()
	while rs.Next() {
		do classList.Insert(rs.Get("ID"))
	}
	return classList
}

/// <p>Embedded SQL implementation returning <class>%ListOfDataTypes</class>.</p>
ClassMethod List2(pattern As %String = "%") As %ListOfDataTypes
{
	set classList = ##class(%ListOfDataTypes).%New()

	&sql(declare cur cursor for
	  select ID 
	  into :id
	  from %Dictionary.ClassDefinition
	  where System = 0
	  and Hidden = 0
	  and ID like :pattern
	)

	&sql(open cur)

	if (SQLCODE = 100) { // no data
		&sql(close cur)
		return classList
	}

	if (SQLCODE '= 0) { // not ok
		set details = "SQL error. Error code: "_SQLCODE_" Error text: "_$system.SQL.Functions.SQLCODE(SQLCODE)
		&sql(close cur)
		$$$ThrowOnError($$$ERROR($$$GeneralError,details))
	}

	&sql(fetch cur)
	while (SQLCODE = 0) {
		do classList.Insert(id)
		&sql(fetch cur)
	}

	&sql(close cur)

	return classList
}

/// <p>Embedded SQL implementation returning %List.</p>
ClassMethod List3(pattern As %String = "%") As %List
{
	#dim classList as %List = ""

	&sql(declare cur cursor for
	  select ID 
	  into :id
	  from %Dictionary.ClassDefinition
	  where System = 0
	  and Hidden = 0
	  and ID like :pattern
	)

	&sql(open cur)

	if (SQLCODE = 100) { // no data
		&sql(close cur)
		return classList
	}

	if (SQLCODE '= 0) { // not ok
		set details = "SQL error. Error code: "_SQLCODE_" Error text: "_$system.SQL.Functions.SQLCODE(SQLCODE)
		&sql(close cur)
		$$$ThrowOnError($$$ERROR($$$GeneralError,details))
	}

	&sql(fetch cur)
	while (SQLCODE = 0) {
		set classList = classList _ $listbuild(id)
		&sql(fetch cur)
	}

	&sql(close cur)

	return classList
}

}
