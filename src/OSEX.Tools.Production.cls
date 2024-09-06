Include (OSEX, Ensemble)

/// Development tools for manipulating the running state of the namespace's IOP production.
/// Assumes the namespace runs only one predefined IOP production.
Class OSEX.Tools.Production
{

/// Restart the current production.
/// Simplified version, will become more complex later ...
/// For runClean option, see https://docs.intersystems.com/irislatest/csp/docbook/DocBook.UI.Page.cls?KEY=EGDV_testing#EGDV_prod_cleanProd
ClassMethod Restart(runClean As %Boolean = {$$$FALSE}) As %Status
{
    // status before restart --------------------------------------------------
    #dim name as %String = ""
    #dim state as %Integer = 0
    $$$CHECK(##class(Ens.Director).GetProductionStatus(.name,.state))
    write ..statusLine(name,state)

    // 1/3 stop the production ------------------------------------------------
    $$$CHECK(##class(Ens.Director).StopProduction(,$$$TRUE))

    // 2/3 optionally clean the production ------------------------------------
    if (runClean) {
        $$$CHECK(##class(Ens.Director).CleanProduction())
    }

    // 3/3 start the production -----------------------------------------------
    $$$CHECK(##class(Ens.Director).StartProduction())

    // status after restart ---------------------------------------------------
    $$$CHECK(##class(Ens.Director).GetProductionStatus(.name,.state))
    write !,..statusLine(name,state)

    return $$$OK
}

ClassMethod statusLine(name As %String, state As %Integer) As %String
{
    set stateMap($$$eProductionStateRunning)   = "RUNNING"   // 1
    set stateMap($$$eProductionStateStopped)   = "STOPPED"   // 2
    set stateMap($$$eProductionStateSuspended) = "SUSPENDED" // 3
    set stateMap($$$eProductionStateTroubled)  = "TROUBLED"  // 4

    return "Production '"_name_"' is "_stateMap(state)
}

}
