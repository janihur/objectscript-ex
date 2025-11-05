/// <p>How to manage extra properties.</p>
Class OSEX.IOP.Production.ExtraProperties.Tools
{

Parameter PRODUCTION = "OSEX.IOP.Production.ExtraProperties";

/// <p>List only non-default extra property values.</p>
ClassMethod List()
{
	set prodconf = ##class(Ens.Config.Production).%OpenId(..#PRODUCTION,,.status)
	set status = prodconf.PopulateVirtualSettings()
	for i=1:1:prodconf.Settings.Count() {
		set obj = prodconf.Settings.GetAt(i)
		zwrite obj
	}
}

/// <p>Set extra property value.</p>
/// <p>Use only with existing properties.</p>
ClassMethod Set(
	name As %String,
	value As %String) As %Status
{
	set prodconf = ##class(Ens.Config.Production).%OpenId(..#PRODUCTION,,.status)
	do prodconf.PopulateVirtualSettings()
	
	if (value = "") {
		return ..clearValue(name, prodconf)
	}

	set updated = 0
	for i=1:1:prodconf.Settings.Count() {
		set setting = prodconf.Settings.GetAt(i)
		if setting.Name = name {
			set setting.Value = value
			set updated = 1
			quit
		}
	}

	if ('updated) {
		set newSetting = ##class(Ens.Config.Setting).%New()
		set newSetting.Name = name
		set newSetting.Value = value
		do prodconf.Settings.Insert(newSetting)
	}
	
	return prodconf.%Save()
}

ClassMethod clearValue(
	name As %String,
	prodconf As Ens.Config.Production) As %Status [ Private ]
{
	set modified = 0
	for i=1:1:prodconf.Settings.Count() {
		set setting = prodconf.Settings.GetAt(i)
		if setting.Name = name {
			do prodconf.Settings.RemoveAt(i)
			set modified = 1
			quit
		}
	}

	return:(modified) prodconf.%Save()
	return 1
}

ClassMethod Get(name As %String) As %String
{
	set prodconf = ##class(Ens.Config.Production).%OpenId(..#PRODUCTION,,.status)
	do prodconf.PopulateVirtualSettings()

	for i=1:1:prodconf.VirtualSettings.Count() {
		set setting = prodconf.VirtualSettings.GetAt(i)
		if ($list(setting,2) = name) {
			return $list(setting,3)
		}
	}
	
	return ""
}

ClassMethod Remove(name As %String) As %Status
{
	set prodconf = ##class(Ens.Config.Production).%OpenId(..#PRODUCTION,,.status)
	do prodconf.PopulateVirtualSettings()
	
	set modified = 0
	for i=1:1:prodconf.Settings.Count() {
		set setting = prodconf.Settings.GetAt(i)
		if setting.Name = name {
			do prodconf.Settings.RemoveAt(i)
			set modified = 1
			quit
		}
	}
	
	return:(modified) prodconf.%Save()
	return $$$OK
}

/// <p>Check if the extra property is defined in the production class.</p>
ClassMethod HasProperty(name As %String) As %Boolean
{
	// unnecessary complex but is an example of IRIS APIs
	set prodExists = ##class(%Dictionary.CompiledClass).%Exists($listbuild(..#PRODUCTION))
	return:('prodExists) 0

	set def = ##class(%Dictionary.PropertyDefinition).%OpenId(..#PRODUCTION_"||"_name)
	return $isobject(def)
}

}
