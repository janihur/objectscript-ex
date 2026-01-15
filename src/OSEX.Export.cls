/// <p>Tools to export/import ObjectScript code.</p>
Class OSEX.Export
{

/// <p>Exports all classes matching regex in UDL format.</p>
/// 
/// <p>Each class is exported to a separate file in format 
/// <code>PACKAGE.PACKAGE.CLASS.cls</code>.</p>
/// 
/// <p>The regex have to match the whole package/class name:
/// <code>"OSEX\..*"</code></p>
ClassMethod ExportClasses1(
	regex As %String,
	outDir As %String) [ Final ]
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

/// <p>Exports all classes matching regex in UDL format.</p>
/// 
/// <p>Each class is exported to a separate file in format 
/// <code>PACKAGE/PACKAGE/CLASS.cls</code>.</p>
/// 
/// <p>The regex have to match the whole package/class name:
/// <code>"OSEX\..*"</code></p>
ClassMethod ExportClasses2(
	regex As %String,
	outDir As %String) [ Final ]
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
			set outFileName = outDir_"/"_..FileToPathName(classFileName)
			write !, "Exporting "_outFileName
			do $system.OBJ.ExportUDL(classFileName, outFileName, "/diffexport=1/displaylog=0", .error, "UTF-8")
		}
		set className = $order(classes(className))
	}
}

/// <p>Exports all items in the list (UDL format).</p>
/// 
/// <p>usage:</p>
/// 
/// <example>
/// set items = ##class(%ListOfDataTypes).%New()
/// do items.Insert("OSEX.inc")
/// do items.Insert("OSEX.Export.cls")
/// do items.Insert("OSEX.IOP.Misc.Operations.CustomHttpRequest.cls")
/// 
/// do ##class(OSEX.Export).Export1(items, "/tmp")
/// </example>
ClassMethod Export1(
	list As %ListOfDataTypes,
	outDir As %String) [ Final ]
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

/// <p>Convert a file name to a path name:</p>
/// <p><code>"OSEX.Export.cls" -> "OSEX/Export.cls"</code></p>
ClassMethod FileToPathName(filename As %String) As %String [ Final ]
{
	set extLen = $find($reverse(filename),".")-2
	set extension = $extract(filename,$length(filename)-extLen,$length(filename))
	set path = $piece(filename, ".", 1, $length(filename, ".")-1)
	set path = $replace(path, ".", "/")
	return path_extension
}

/// <p>Import all class files recursively.</p>
ClassMethod ImportClasses(dir As %String) [ Final ]
{
	do $system.OBJ.ImportDir(dir,,"/compile=1",,1)
}

/// <p>Imports and compile a single InterSystems code file (that usually is
/// ObjectScript code file).</p>
/// <p>See: <a href="https://docs.intersystems.com/irislatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25SYSTEM.OBJ#Load">$SYSTEM.OBJ#Load</a></p>
ClassMethod ImportClass(filename As %String) [ Final ]
{
	do $system.OBJ.Load(filename, "/checkuptodate=1/compile=1/displayerror=1/displaylog=0/keepsource=1")
}

/// <p>Exports a single include file.</p>
/// <p><code>name</code> argument should NOT contain the <code>.inc</code> postfix.</p>
ClassMethod ExportInclude(
	name As %String,
	outDir As %String) [ Final ]
{
	set item = name_".inc"
	set filename = outDir_"/"_name_".inc"
	write !, "Exporting "_filename
	set status = $system.OBJ.ExportUDL(item, filename, "/diffexport=1/displaylog=0", .error, "UTF-8")
	if ($$$ISERR(status)) {
		do $system.Status.DisplayError(status)
	}
}

}
