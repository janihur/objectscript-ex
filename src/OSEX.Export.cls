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

/// Exports all items in the list (UDL format).
/// 
/// usage:
/// 
/// set items = ##class(%ListOfDataTypes).%New()
/// do items.Insert("OSEX.inc")
/// do items.Insert("OSEX.Export.cls")
/// do items.Insert("OSEX.IOP.Misc.Operations.CustomHttpRequest.cls")
/// 
/// do ##class(OSEX.Export).Export1(items, "/tmp")
/// 
ClassMethod Export1(list As %ListOfDataTypes, outDir As %String) [ Final ]
{
	for i=1:1:list.Count() {
		set item = list.GetAt(i)
		set filename = outDir_"/"_..FileToPathName(item)
		write !, "--------------"
		write !, "Exporting item"
		write !, "   from: "_item
		write !, "     to: "_filename
		set status = $system.OBJ.ExportUDL(item, filename, "/diffexport=1/displaylog=0", .error, "UTF-8")
		write !, " status: "_$system.Status.DisplayError(status)
	}
}

/// Convert a file name to a path name.
/// I.e. "OSEX.Export.cls" -> "OSEX/Export.cls"
ClassMethod FileToPathName(filename As %String) As %String [ Final ]
{
	set extLen = $find($reverse(filename),".")-2
	set extension = $extract(filename,$length(filename)-extLen,$length(filename))
	set path = $piece(filename, ".", 1, $length(filename, ".")-1)
	set path = $replace(path, ".", "/")
	return path_extension
}

/// Import all class files recursively.
ClassMethod ImportClasses(dir As %String) [ Final ]
{
	do $system.OBJ.ImportDir(dir,,"/compile=1",,1)
}

/// Imports and compile a single InterSystems code file (that usually is
/// ObjectScript code file).
/// See: https://docs.intersystems.com/irislatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25SYSTEM.OBJ#Load
ClassMethod ImportClass(filename As %String) [ Final ]
{
	do $system.OBJ.Load(filename, "/checkuptodate=1/compile=1/displayerror=1/displaylog=0/keepsource=1")
}

/// Exports a single include file.
/// name should not contain the .inc postfix.
ClassMethod ExportInclude(name As %String, outDir As %String) [ Final ]
{
	set item = name_".inc"
	set filename = outDir_"/"_name_".inc"
	set status = $system.OBJ.ExportUDL(item, filename)
	if ($$$ISERR(status)) {
		do $system.Status.DisplayError(status)
	}
}

}
