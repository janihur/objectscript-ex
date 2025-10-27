Include OSEX

/// <p>A random collection of different tools for working with code. Some 
/// might be useful and some not.</p>
Class OSEX.Tools.Code
{

/// <p>Check if a class exists in the namespace. The class should be compiled if we are going to call it's methods.</p>
ClassMethod ClassExists(
	className As %String,
	compiled As %Boolean = {$$$TRUE}) As %Boolean
{
  // https://docs.intersystems.com/iris20252/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&PRIVATE=1&CLASSNAME=%25Dictionary.CompiledClass#%25Exists
  return:(compiled) ##class(%Dictionary.CompiledClass).%Exists($listbuild(className))
  // https://docs.intersystems.com/iris20252/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25Dictionary.ClassDefinition#%25Exists
  return ##class(%Dictionary.ClassDefinition).%Exists($listbuild(className))
}

/// <p>Check if a class method exists in the namespace.</p> 
ClassMethod ClassMethodExists(
	className As %String,
	methodName As %String) As %Boolean
{
  // internal non-documented method
  // https://community.intersystems.com/post/check-if-class-exists#comment-96381
  return $system.CLS.IsMthd(className, methodName)
}

/// TODO: 1) delete all code in the namespace
/// TODO: 2) ImportDir()
/// 
/// Sync namespace code with the file system.
/// The sync is one way from the file system to the namespace.
ClassMethod Sync(
	path As %String,
	compile As %Boolean = {$$$FALSE},
	force As %Boolean = {$$$FALSE})
{
  // 1/2 import all code to the namespace -------------------------------------
  #dim qspec As %String = "/display=all"
  if (compile) {
    set qspec = qspec_"/compile=1"
  }
  do $system.OBJ.ImportDir(path,,qspec,,$$$TRUE)

  // 2/2 remove orphaned code objects from the namespace ----------------------

  #dim codeFilesMd // md
  do ..CollectCodeFiles(path, "*.cls;*.inc", .codeFilesMd)

  #dim codeObjectList as %ListOfDataTypes = ..CollectCodeObjects()

  // find code objects with no corresponding code file
  #dim deleteMd // md
  #dim deleteCount as %Integer = 0
  for i=1:1:codeObjectList.Count() {
    set codeObjectName = codeObjectList.GetAt(i)
    if ('$data(codeFilesMd(codeObjectName))) {
      do $increment(deleteCount)
      set deleteMd(codeObjectName) = ..GetFilenameExtension(codeObjectName)
    }
  }

  // safety check
  if (deleteCount/codeObjectList.Count() > 0.2) {
    write "Going to delete more than 20% of the code objects. Aborting.",!
    return
  }

  // delete all code objects with no corresponding code file
  set codeObjectName = $order(deleteMd(""))
  while (codeObjectName '= "") {
    #dim type as %String = deleteMd(codeObjectName)
    write "delete ",type," ",codeObjectName,!
    if (type = "cls") {
      #; do $system.OBJ.Delete(codeObjectName,"/displaylog=0")
    } else {
      #; do ##class(%Routine).Delete(codeObjectName,0,$$$TRUE)
    }
    set codeObjectName = $order(deleteMd(codeObjectName))
  }


  #; for i=1:1:codeObjectList.Count() {
  #;   set codeObjectName = codeObjectList.GetAt(i)
  #;   if ('$data(codeFilesMd(codeObjectName))) {
  #;     #dim extension as %String = ..GetFilenameExtension(codeObjectName)
  #;     if (extension = "cls") {
  #;       write "delete class ",codeObjectName,!
  #;       do $system.OBJ.Delete(codeObjectName,"/displaylog=0")
  #;     } elseif (extension = "inc") {
  #;       write "delete include ",codeObjectName,!
  #;       do ##class(%Routine).Delete(codeObjectName,0,$$$TRUE)
  #;     } 
  #;   }
  #; }
}

/// Return the file name extension - anything after the last dot.
/// May return an empty string.
ClassMethod GetFilenameExtension(filename As %String) As %String
{
  if ($find(filename,".") = 0) { // not dot - no extension
    return ""
  }
  return $piece(filename,".",*)
}

/// Compile the (top-level) package.
ClassMethod Compile(name As %String)
{
}

/// Collect code files from the file system.
ClassMethod CollectCodeFiles(
	path As %String,
	wildcards As %String = "",
	Output files)
{
  set action = ##class(OSEX.Tools.DirWalk.Action).%New()
  do ##class(OSEX.Tools.DirWalk).Walk(.action,path,wildcards, $$$TRUE)

  #dim fileList as %ListOfDataTypes = action.GetFilesList()

  for i=1:1:fileList.Count() {
    #dim fullname as %String = fileList.GetAt(i)
    #dim filename as %String = ##class(%File).GetFilename(fullname)
    set files(filename) = ""
  }
}

/// Collect code objects from the namespace.
/// https://community.intersystems.com/node/537546
/// https://docs.intersystems.com/irislatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25Library.RoutineMgr#StudioOpenDialog
ClassMethod CollectCodeObjects() As %ListOfDataTypes
{
  set list = ##class(%ListOfDataTypes).%New()

  set stmt = ##class(%SQL.Statement).%New()

  set status = stmt.%PrepareClassQuery("%RoutineMgr", "StudioOpenDialog")
  if $$$ISERR(status) {write "%Prepare failed:" do $SYSTEM.Status.DisplayError(status) quit}  

  // 1 Spec As %String(MAXLEN=512),
  // 2 Dir As %Integer,
  // 3 OrderBy As %Integer,
  // 4 SystemFiles As %Boolean,
  // 5 Flat As %Boolean,
  // 6 NotStudio As %Boolean = 0,
  // 7 ShowGenerated As %Boolean = 1,
  // 8 Filter As %String(MAXLEN=512),
  // 9 RoundTime As %Boolean = 0,
  // 10 Mapped As %Boolean = 1
  #dim rset as %SQL.StatementResult = stmt.%Execute("*.cls,*.inc",,,,1,,0,,,0)
  if (rset.%SQLCODE '= 0) {write "%Execute failed:", !, "SQLCODE ", rset.%SQLCODE, ": ", rset.%Message quit}

  // %Query(CONTAINID = 1, ROWSPEC = "Name:%String(MAXLEN=512):File Name/Ext,IsDirectory:%String,Type:%Integer:,Size:%Integer:Routine Size,Date:%TimeStamp:Date/Time last modified,Description:%String(MAXLEN=32767):Brief Description,IconType:%Integer")
  while rset.%Next()
  {
    do list.Insert(rset.%Get("Name"))
  }
  if (rset.%SQLCODE < 0) {write "%Next failed:", !, "SQLCODE ", rset.%SQLCODE, ": ", rset.%Message quit}

  return list
}

}
