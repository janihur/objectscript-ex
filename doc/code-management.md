# ObjectScript Code Management

Code management operations for ObjectScript classes are part of [`%SYSTEM.OBJ`](https://docs.intersystems.com/irislatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25SYSTEM.OBJ) class.

## ObjectScript Classes

Classes in Management Portal:
```
System Explorer > Classes
```

|Operation|Command|Details|
|---------|-------|-------|
|Import   |`do $system.OBJ.ImportDir("<DIR>",,"/compile=1",,1)`|Import and compile all code in `<DIR>` directory recursively to server.|
|Export   |`do ##class(OSEX.Export).ExportClasses("<REGEX>","<DIR>")`|Export all class code to `<DIR>` directory from server where `<REGEX>` have to match the whole class name. E.g. all classes of `OSEX`top level package: `OSEX\..*`.|
|Delete Package|`do $system.OBJ.DeletePackage("<PACKAGES>")`|Delete all classes of the specified `<PACKAGES>` from server. `<PACKAGES>` can be a single package name, a comma separated list of package names or `* ` to delete all classes.|
|Delete Class  |`do $system.OBJ.Delete("<CLASSES>")`|Delete a class or classes from server. `<CLASSES>` can be a single class name, a comma separated list of class names or a multidimensional array of class names. Accepts `?` and `*` wildcards and not operator `'` to exclude a class.|

|Operation|Command|Details|
|---------|-------|-------|
|Compile one or more classes|`zw $system.OBJ.Compile("<CLASSES>",,.errorlog)`|`<CLASSES>` can be a single class name, a comma separated list of class names or a multidimensional array of class names. Accepts `?` and `*` wildcards and not operator `'` to exclude a class.|
|Compile all classes in the current namespace|`zw $system.OBJ.CompileAll(,.errorlog)`||

## Routine Code

Routines can be managed with [`%Library.Routine`](https://docs.intersystems.com/irisforhealthlatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25Library.Routine) class.

Routines in Management Portal:
```
System Explorer > Routines
```

Delete a routine:
```
zwrite ##class(%Routine).Delete("<ROUTINE>")
```