Include OSEX

/// https://docs.intersystems.com/irislatest/csp/docbook/DocBook.UI.Page.cls?KEY=GFILE_dirsdrives#GFILE_dirsdrives_filesetquery
Class OSEX.Tools.DirWalk
{

/// action should be an object implementing the Action() method
/// path is the directory to start the walk
/// wildcards is a list of string wildcards to match files. different wildcards are separated by ";"
/// recursive is a boolean to indicate if the walk should be recursive
ClassMethod Walk(
	ByRef action As %RegisteredObject,
	path As %String,
	wildcards As %String = "",
	recursive As %Boolean = {$$$FALSE})
{
  set stmt = ##class(%SQL.Statement).%New()

  set status = stmt.%PrepareClassQuery("%File", "FileSet")
  if $$$ISERR(status) {write "%Prepare failed:" do $SYSTEM.Status.DisplayError(status) quit}  

  set rset = stmt.%Execute(path,wildcards,,1)
  if (rset.%SQLCODE '= 0) {write "%Execute failed:", !, "SQLCODE ", rset.%SQLCODE, ": ", rset.%Message quit}

  while rset.%Next()
  {
    set name = rset.%Get("Name")
    set type = rset.%Get("Type")
    
    do action.Action(name,type)

    if ((recursive) && (type = "D")){
      do ..Walk(.action,name,wildcards,recursive)
    }
  }
  if (rset.%SQLCODE < 0) {write "%Next failed:", !, "SQLCODE ", rset.%SQLCODE, ": ", rset.%Message quit}

  do rset.%Close()
}

}
