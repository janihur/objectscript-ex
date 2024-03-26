Class OSEX.IOP.EnsConfigEx Extends %RegisteredObject
{

Parameter CONFIGITEM = "Jokes.Operations.ChuckNorris";

Parameter PRODUCTION = "OSEX.IOP.Production";

ClassMethod Ex1()
{
	// ------------------------------------------------------------------------
	// production
	
	#dim status As %Status
	#dim production As Ens.Config.Production = ##class(Ens.Config.Production).%OpenId(..#PRODUCTION,,.status)
	if ($$$ISERR(status)) {
		do $system.Status.DisplayError(status)
		return
	}
	
	// ------------------------------------------------------------------------
	// iterate all production items (business hosts)
	// and all business host settings set in production
	
	// production items
	#dim item As Ens.Config.Item
	#dim i As %Integer
	for i = 1 : 1 : production.Items.Count() {
		set item = production.Items.GetAt(i)
		write "business host #"_i_": "
		write "(Name "_item.Name_")"
		write "(Category "_item.Category_")"
		write "(Enabled "_item.Enabled_")"
		write !
		
		// settings of production item
		#dim setting as Ens.Config.Setting
		#dim j As %Integer
		for j = 1 : 1 : item.Settings.Count() {
			set setting = item.Settings.GetAt(j)
			write "  setting #"_j_": "
			write "(Target "_setting.Target_")"
			write "("_setting.Name_" "_setting.Value_")"
			write !
		}
	}
}

ClassMethod Ex2()
{
	// ------------------------------------------------------------------------
	// production
	
	#dim status As %Status
	#dim production As Ens.Config.Production = ##class(Ens.Config.Production).%OpenId(..#PRODUCTION,,.status)
	if ($$$ISERR(status)) {
		do $system.Status.DisplayError(status)
		return
	}

	// ------------------------------------------------------------------------
	// find production item by name
	
	#dim item as Ens.Config.Item
	set item = production.FindItemByConfigName(..#CONFIGITEM,.status,0)
	if ($$$ISERR(status)) {
		do $system.Status.DisplayError(status)
		return
	}
	
	// ------------------------------------------------------------------------
	// iterate all settings of item set in production
	
	#dim setting as Ens.Config.Setting
	#dim i as %Integer
	for i = 1 : 1 : item.Settings.Count() {
		set setting = item.Settings.GetAt(i)
		write "setting #"_i_": "
		write "(Target "_setting.Target_")"
		write "("_setting.Name_" "_setting.Value_")"
		write !
	}
	
	// ------------------------------------------------------------------------
	// find setting by name
	
	set setting = item.FindSettingByName("URL", "Adapter")
	if (setting = $$$NULLOREF) {
		write "ERROR: setting 'URL' was not found"
		return
	}

	// ------------------------------------------------------------------------
	// update setting
	// works but modifying code commented
	/*
	set setting.Value = "/jokes/random"
	set status = item.%Save() // make change permanent
	if ($$$ISERR(status)) {
		do $system.Status.DisplayError(status)
		return
	}
	*/
	
	// ------------------------------------------------------------------------
	// add new setting
	// works but modifying code commented
	/*
	set setting = ##class(Ens.Config.Setting).%New()
	set setting.Target = "Adapter"
	set setting.Name = "HTTPPort"
	set setting.Value = 8081
	
	do item.Settings.Insert(setting)
	set status = item.%Save()
	if ($$$ISERR(status)) {
		do $system.Status.DisplayError(status)
		return
	}
	*/
	// ------------------------------------------------------------------------
	// remove setting
	
	// find setting index
	#dim removeIndex as %String = 0
	for i = 1 : 1 : item.Settings.Count() {
		set setting = item.Settings.GetAt(i)
		/*
		write "setting #"_i_": "
		write "(Target "_setting.Target_")"
		write "("_setting.Name_" "_setting.Value_")"
		write !
		*/
		if ((setting.Target = "Host") && (setting.Name = "HTTPPort")) {
			set removeIndex = i
			quit
		}
	}
	
	if (removeIndex '= 0) {
		do item.Settings.RemoveAt(removeIndex)
		set status = item.%Save()
		if ($$$ISERR(status)) {
			do $system.Status.DisplayError(status)
			return
		}
	}
}

ClassMethod Ex3()
{
	// ------------------------------------------------------------------------
	// production
	
	#dim status As %Status
	#dim production As Ens.Config.Production = ##class(Ens.Config.Production).%OpenId(..#PRODUCTION,,.status)
	if ($$$ISERR(status)) {
		do $system.Status.DisplayError(status)
		return
	}
	
	// ------------------------------------------------------------------------
	// find settings of a single item
	
	#dim itemName as %String = ..#PRODUCTION_"||"_..#CONFIGITEM
	
	#dim settings // md
	set status = ##class(Ens.Director).GetItemSettings(itemName,"Adapter",.settings)
	zw settings

	// ------------------------------------------------------------------------
	// enable/disable item
	// enabling already enabled item is an error -> check first
	
	#dim enable as %Boolean = 1
	#dim disable as %Boolean = 0
	
	#dim isEnabled as %Boolean = ##class(Ens.Director).IsItemEnabled(itemName,status)
	if ($$$ISERR(status)) {
		do $system.Status.DisplayError(status)
		return
	}
	
	write "before: "
	write "(BusinessHost "_itemName_")"
	write "(Enabled "_isEnabled_")"
	write !

	if (isEnabled) {
		set status = ##class(Ens.Director).EnableConfigItem(itemName,disable)
		if ($$$ISERR(status)) {
			do $system.Status.DisplayError(status)
			return
		}
	}	

	set isEnabled = ##class(Ens.Director).IsItemEnabled(itemName,status)
	if ($$$ISERR(status)) {
		do $system.Status.DisplayError(status)
		return
	}
	
	write "after: "
	write "(BusinessHost "_itemName_")"
	write "(Enabled "_isEnabled_")"
	write !
}

ClassMethod Ex4()
{
	do ..EnableBusinessHost(..#PRODUCTION,..#CONFIGITEM,1)
	write !
}

/// possible failures ignored
ClassMethod EnableBusinessHost(prodName As %String, hostName As %String, enabled As %Boolean)
{
	#dim fullName as %String = prodName_"||"_hostName

	#dim status as %Status = $$$OK
	#dim currentEnabled as %Boolean = ##class(Ens.Director).IsItemEnabled(fullName,status)
	if ($$$ISERR(status)) {
		do $system.Status.DisplayError(status)
		return
	}
	
	if (currentEnabled '= enabled) {
		set status = ##class(Ens.Director).EnableConfigItem(fullName,enabled)
		if ($$$ISERR(status)) {
			do $system.Status.DisplayError(status)
			return
		}
	}
}

/// GetAdapterSettings == GetItemSettings(,"Adapter",)
/// GetHostSettings == GetItemSettings(,"Host",)
ClassMethod Ex5()
{
	#dim businessHostName as %String = ..#PRODUCTION_"||"_..#CONFIGITEM
	
	#dim status as %Status = $$$OK
	#dim hostSettings // md
	
	set status = ##class(Ens.Director).GetHostSettings(businessHostName,.hostSettings)
	if ($$$ISERR(status)) {
		do $system.Status.DisplayError(status)
		return
	}
	zw hostSettings

	write "---",!
	
	#dim adapterSettings // md
	set status = ##class(Ens.Director).GetAdapterSettings(businessHostName,.adapterSettings)
	if ($$$ISERR(status)) {
		do $system.Status.DisplayError(status)
		return
	}
	zw adapterSettings
}

}

