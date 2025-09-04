Include OSEX

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

/// <p>Return current local date and time in ISO 8601 format (3).</p>
ClassMethod Now() As %String
{
	return $zdatetime($horolog,3)
}

/// is valid ISO 8601 UTC date time string without time zone offset
/// accepts also only date or time strings
/// not a bullet proof (yet)
ClassMethod IsValidUtc(dateTimeStr As %String) As %Boolean
{
	// remove possible utc indicator ('Z')
	set dateTimeStr = $replace(dateTimeStr,"Z","")
	set status = ##class(%TimeStamp).IsValid(dateTimeStr)
	if ($$$ISERR(status)) {
		return 0
	}
	return 1
}

ClassMethod TestIsValidUtc()
{
	set tests = [
		{
			// no T separator
			"dateTimeStr": "2024-03-21 14:39:32",
			"expected": 1
		},
		{
			// no T separator
			"dateTimeStr": "2024-03-21 14:39:32.123",
			"expected": 1
		},
		{
			// random string
			"dateTimeStr": "lorem ipsum dolor sit amet",
			"expected": 0
		},
		{
			"dateTimeStr": "2024-07-11T15:30:45",
			"expected": 1
		},
		{
			"dateTimeStr": "2024-07-11T15:30:45.123",
			"expected": 1
		},
		{
			"dateTimeStr": "2024-07-11T15:30:45Z",
			"expected": 1
		},
		#; {
		#; 	"dateTimeStr": "2024-07-11T15:30:45+02:00",
		#; 	"expected": 1
		#; },
		{
			"dateTimeStr": "2024-07-11",
			"expected": 1
		},
		{
			"dateTimeStr": "15:30:45",
			"expected": 1
		},
		{
			// valid february date (non-leap year)
			"dateTimeStr": "2023-02-28 14:39:32",
			"expected": 1
		},
		{
			// invalid february date (non-leap year)
			"dateTimeStr": "2023-02-29 14:39:32",
			"expected": 0
		},
		{
			// valid february date (leap year)
			"dateTimeStr": "2024-02-29 14:39:32",
			"expected": 1
		},
		{
			// invalid february date (leap year)
			"dateTimeStr": "2024-02-30 14:39:32",
			"expected": 0
		},
		{
			// invalid month
			"dateTimeStr": "2024-13-11 14:39:32",
			"expected": 0
		},
		{
			// invalid day
			"dateTimeStr": "2024-07-32 14:39:32",
			"expected": 0
		},
		{
			// invalid hour
			"dateTimeStr": "2024-07-11 25:39:32",
			"expected": 0
		},
		{
			// invalid minute
			"dateTimeStr": "2024-07-11 14:60:32",
			"expected": 0
		},
		{
			// invalid second
			"dateTimeStr": "2024-07-11 14:39:60",
			"expected": 0
		},
		{
			"dateTimeStr": "",
			"expected": 0
		},
		{
			// invalid format (slashes instead of dashes)
			"dateTimeStr": "2025/07/08 14:30:00",
			"expected": 0
		}
	]

	set iter = tests.%GetIterator()

	while(iter.%GetNext(.index,.test)) {
		write "test case #", index, ": ", test.dateTimeStr, !
		set result = ..IsValidUtc(test.dateTimeStr)
		$$$ASSERT(result = test.expected)
	}
}

}
