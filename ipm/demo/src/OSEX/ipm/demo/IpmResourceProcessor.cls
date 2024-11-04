/// <p>IPM Resource Processor example. Note IPM version 0.7 compatible only.</p>
Class OSEX.ipm.demo.IpmResourceProcessor Extends %ZPM.PackageManager.Developer.Processor.Abstract
{

Parameter DESCRIPTION As STRING = "A dummy IPM resource processor example.";

/// <p>A comma separated list of XML Resource tag attributes that are copied to corresponding class properties.</p>
Parameter ATTRIBUTES As STRING = "Name,Foo,Bar";

Property Name As %String;

Property Foo As %String;

Property Bar As %String;

/// <p>The standard hook method the resource processor is expected to implement.</p>
Method OnBeforePhase(
	pPhase As %String,
	ByRef pParams) As %Status
{
	write !
	write $classname(), ": OnBeforePhase(): phase: ", pPhase
	write !
	#; write $classname(), ": OnBeforePhase(): pParams: ", ..mdToString(.pParams)
	#; write !
	#; write $classname(), ": OnBeforePhase(): properties: ", ..propertiesToString()
	#; write !

	if (pPhase = "Configure") {
		// value from the IPM manifest file attribute
		do ##class(OSEX.ipm.demo.Main).SetSetting("foo", ..Foo)
		// value from the json file
		#dim filename as %String = ##class(%File).NormalizeFilename($get(pParams("RootDirectory"))_"/"_..Name)
		#dim fileExists as %Boolean = ##class(%File).Exists(filename)
		if ('fileExists) {
			return $$$ERROR(5001, "File not found: "_filename)
		}
		set stream = ##class(%Stream.FileCharacter).%New()
		do stream.LinkToFile(filename)
		#dim json as %DynamicObject = {}.%FromJSON(stream)
		do ##class(OSEX.ipm.demo.Main).SetSetting("bar", json.bar)
	}

	return $$$OK
}

/// <p>The standard hook method the resource processor is expected to implement.</p>
/// <p>Note this method is called only for Reload and Compile phases.</p>
Method OnPhase(
	pPhase As %String,
	ByRef pParams,
	Output pResourceHandled As %Boolean = 0) As %Status
{
	write !
	write $classname(), ": OnPhase(): phase: ", pPhase
	write !
	#; write $classname(), ": OnPhase(): pParams: ", ..mdToString(.pParams)
	#; write !
	#; write $classname(), ": OnPhase(): properties: ", ..propertiesToString()
	#; write !
	// set pResourceHandled = 1 // TODO: ???
	return $$$OK
}

/// <p>The standard hook method the resource processor is expected to implement.</p>
Method OnAfterPhase(
	pPhase As %String,
	ByRef pParams) As %Status
{
	write !
	write $classname(), ": OnAfterPhase(): phase: ", pPhase
	write !
	#; write $classname(), ": OnAfterPhase(): pParams: ", ..mdToString(.pParams)
	#; write !
	#; write $classname(), ": OnAfterPhase(): properties: ", ..propertiesToString()
	#; write !
	return $$$OK
}

/// <p>Just for demonstration purposes.</p>
Method propertiesToString() As %String [ Private ]
{
	return "(Name """_..Name_""")(Foo """_..Foo_""")(Bar """_..Bar_""")"
}

/// <p>Just for demonstration purposes.</p>
ClassMethod mdToString(ByRef md) As %String [ Private, PublicList = md ]
{
	#dim accu as %String = ""

	set ref = $query(md(""))
	while (ref '= "") {
		set accu = accu_"("_ref_" "_@ref_")"
		set ref = $query(@ref)
	}

	return accu
}

}
