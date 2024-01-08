/// Tools to export/import ObjectScript code.
Class OSEX.Export
{

/// Exports all classes matching regex.
/// The regex have to match the whole class name:
/// "OSEX\..*"
ClassMethod ExportClasses(regex As %String, outDir As %String) [ Final ]
{
	do $system.OBJ.GetClassList(.classes, "")
	// zwrite classes
	
	set re = ##class(%Regex.Matcher).%New(regex)
	
	set className = $order(classes(""))
	while (className '= "") {
		set re.Text = className
		set matched = re.Match()
		// write !, "(className "_className_")(matched "_matched_")"
		if (matched) {
			set classFileName = className_".cls"
			set outFileName = outDir_"/"_classFileName
			write !, "Exporting "_outFileName
			do $system.OBJ.ExportUDL(classFileName, outFileName, "/diffexport=1/displaylog=0", .error, "UTF-8")
		}
		set className = $order(classes(className))
	}
}

/// Imports the class file exported by ExportClasses().
ClassMethod ImportClass(filename As %String) [ Final ]
{
	do $system.OBJ.Load(filename, "/checkuptodate=1/compile=1/displayerror=1/displaylog=0/keepsource=1")
}

/// Exports a single include file.
/// name should not contain the .inc postfix.
ClassMethod ExportInclude(name As %String, outDir As %String) [ Final ]
{
	set items = name_".inc"
	set filename = outDir_"/"_name_".inc"
	set status = $system.OBJ.Export(items, filename)
	if ($$$ISERR(status)) {
		do $system.Status.DisplayError(status)
	}
}

}

