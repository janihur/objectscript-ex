Class OSEX.Time Extends %RegisteredObject
{

ClassMethod Ex1()
{
	#dim nowDateTime = $horolog
	#dim nowDate = $piece(nowDateTime,",",1)
	#dim nowTime = $piece(nowDateTime,",",2)
	
	zw nowDateTime
	zw nowDate
	zw nowTime
	
	// format 3 is ISO
	// there is more formats but here we just use the first ones
	
	#dim i as %Integer
	for i=1 : 1 : 20 {
		write "format: ",i," ---",!
		write "$zdatetime: ",$zdatetime(nowDateTime,i),!
		write "$zdate:     ",$zdate(nowDateTime,i),!
		write "$ztime:     "
		if (i < 5) {
			write $ztime(nowDateTime,i),!
		} else {
			write "not a valid format",!
		}
	}
}

ClassMethod Ex2()
{
	do ..ex2Impl("2024-03-21 14:39:32")
	do ..ex2Impl("2024-03-31 14:39:32")
}

ClassMethod ex2Impl(dateTimeStr As %String)
{
	write "---",!
	zw dateTimeStr
	write "horolog full: ",$zdatetimeh(dateTimeStr,3),!
	write "horolog date: ",$zdateh(dateTimeStr,3),!
	write "horolog time: ",$ztimeh($piece(dateTimeStr," ",2)),!
	write "is daylight saving time: ",$system.Util.IsDST($zdatetimeh(dateTimeStr,3)),!
}

}

