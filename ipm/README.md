# InterSystems Package Manager (IPM)

This is based on 0.7, but [0.9 is out soon](https://community.intersystems.com/node/576406). Switch to 0.9 asap.

The documentation:
* [ipm/README.md](https://github.com/intersystems/ipm/blob/master/README.md)
* [ipm/wiki](https://github.com/intersystems/ipm/wiki/)

An interesting commercial solution build on top of IPM: https://openexchange.intersystems.com/package/zpmhub

Worth checking later:
* https://openexchange.intersystems.com/package/iris-interoperability-template

## Client (ZPM)

### Installation

Download the client installation package:
```bash
curl -LO \
https://github.com/intersystems/ipm/releases/download/v0.7.3/zpm-0.7.3.xml
```
(0.7.3 is the latest version at the moment of writing.)

Import in any namespace:
```
NAMESPACE>do $system.OBJ.Load("/<PATH>/zpm-0.7.3.xml","ck",.errorlog)
NAMESPACE>zwrite errorlog
```

The tool will install itself into `%SYS` namespace and will be available for all namespaces in the instance.

### Usage

Start the package manager shell:
```
IPMTEST1>zpm

=============================================================================
|| Welcome to the Package Manager Shell (ZPM). version 0.7.3               ||
|| Enter q/quit to exit the shell. Enter ?/help to view available commands ||
|| Current registry https://pm.community.intersystems.com                  ||
=============================================================================
zpm:IPMTEST1>
```

By default the InterSystems hosted Community registry (https://pm.community.intersystems.com) is used.

Useful commands:
* `help`
* `install`
* `list-installed -tree`
* `repo -list-modules`
* `search`
* `uninstall`

## The Registrys

The IPM client supports two kinds of registries:
* remote
  * This is server software implementing de-facto IPM Registry REST API. The only known implementation [intersystems-community/zpm-registry](https://github.com/intersystems-community/zpm-registry) runs on IRIS.
* filesystem
  * A directory hierarchy available for the client. This could be e.g. a network file share or a cloned git repository.

There is three kinds of _remote_ registries:
* InterSystems IPM Registry
  * All packages are verified and approved by InterSystems.
  * One needs to be InterSystems' customer to get access.
  * User interface frontend: https://pm.intersystems.com
  * You probably don't need this but just use Community IPM Registry.
* Community IPM Registry
  * This is _the_ registry of InterSystems software ecosystem.
  * Hosted by InterSystems at https://pm.community.intersystems.com
  * User interface frontend: https://openexchange.intersystems.com/ (covers also other sources of code than just the IPM modules).
* Self-hosted IPM Registry
  * A.k.a. private/local, i.e. your own, IPM registry, hosted by you on your favorite IRIS server.
  * You need this only if you can't have direct access to Community IPM Registry (see _Proxy_ below) or you have private modules you'd like to share only privately.

## Proxy

How to use self-hosted registry as a (white-listed) Community registry proxy.

File `<INSTALL_DIR>/zpm-registry.yaml`:
```yaml
uplinks:
  pm:
    url: https://pm.community.intersystems.com
    allow_packages: dsw,mdx2json,testcoverage
```

where `<INSTALL_DIR>` could be e.g. `/usr/irissys`.

## Registry REST API

```
curl https://pm.community.intersystems.com/
curl https://pm.community.intersystems.com/_ping
curl https://pm.community.intersystems.com/_spec
curl https://pm.community.intersystems.com/packages/-/all
```

## How to Install Self-Hosted Remote Registry Server

* Developer Community:
  * [Setting Up Your Own InterSystems ObjectScript Package Manager Registry](https://community.intersystems.com/node/473661)

Note the ports in my Docker setup:
* `52773` - used inside the container (i.e. in package manager shell)
* `52774` - exposed outside the container

The remote registry server is implemented as an IPM module and can be installed locally with IPM client:
```
zpm:IPMTEST1>install zpm-registry
```

The packages are installed per namespace in:
```
$ ll /usr/irissys/mgr/.modules/IPMTEST1/
total 16
drwxrwxr-x 4 irisowner irisowner 4096 Oct 28 12:26 ./
drwxrwxr-x 3 irisowner irisowner 4096 Oct 28 12:26 ../
drwxrwxr-x 3 irisowner irisowner 4096 Oct 28 12:26 yaml-utils/
drwxrwxr-x 3 irisowner irisowner 4096 Oct 28 12:26 zpm-registry/
```

## Configure Self-Hosted Remote Registry

The server is a standard [%CSP.REST](https://docs.intersystems.com/irislatest/csp/documatic/%25CSP.Documatic.cls?LIBRARY=%25SYS&CLASSNAME=%25CSP.REST) web application with `/registry` basepath.

By default the web application has both _Unauthenticated_ and _Password_ authentication methods enabled.

However publishing always requires authentication (the registry server code has explicit check for that).

Create new (system) user with _password_ that will be used when publishing modules to the registry:
```
Management Portal
> System Administration
 > Security
  > Users
   > Button: Create New User
```

No other user details are needed.

Configure new _remote_ registry (named _local_) with the user just created above for the IRIS instance:
```
zpm:IPMTEST1>repo -name local -remote -publish 1 -url http://localhost:52773/registry/ -username <USERNAME> -password <PASSWORD>
```

### Self-Hosted Remote Registry REST API Example

Note the authentication is optional for all other operations except publishing.

Note this example uses a special path `/package` that requires no authentication.

Publish a (random GitHub) package:
```bash
curl http://localhost:52774/registry/package \
 --user <USERNAME>:<PASSWORD> --basic \
 -i -X POST -H 'Content-Type:application/json' -d '{"repository":"https://github.com/psteiwer/ObjectScript-Math"}'
```

List registry packages:
```bash
curl http://localhost:52774/registry/packages/-/all \
 --user <USERNAME>:<PASSWORD> --basic \
 | jq '.'
```
```json
[
  {
    "name": "objectscript-math",
    "description": "Math library for InterSystems ObjectScript",
    "repository": "https://github.com/psteiwer/ObjectScript-Math/",
    "origin": "",
    "versions": [
      "0.0.5"
    ],
    "is_owner": 0
  }
]
```

## Configure Filesystem Registry

This doesn't need the registry server at all (the filesystem is the server).

Configure new _filesystem_ registry (named _localfs_) for the IRIS instance:
```
zpm:IPMTEST1>repo -name localfs -filesystem -depth 1 -path /home/irisowner/work/objectscript-ex/ipm/
```

The above only supports one version (the latest) of any module (to keep this example simple). If you want to have multiple versions the modules (as you should) you have to add one extra level to the directory hierarchy:

```
<PATH>/<MODULE_NAME>/<MODULE_VERSION>/
```

and use `-depth 2` option.

## How to Write a Module

* Developer Community
  * https://community.intersystems.com/post/anatomy-zpm-module-packaging-your-intersystems-solution
  * https://community.intersystems.com/post/simplified-objectscript-source-folder-structure-package-manager
  * https://community.intersystems.com/post/objectscript-package-manager-naming-convention
  * https://community.intersystems.com/post/using-invoke-element-call-class-methods-objectscript-packages
* https://github.com/intersystems/ipm/wiki/03.-IPM-Manifest-(Module.xml)
* https://github.com/intersystems-community/objectscript-package-example
* Templates
  * https://github.com/intersystems-community/objectscript-package-template
  * https://github.com/intersystems-community/intersystems-iris-dev-template

### How to Create a Module

A module is nothing but a simple predefined directory hierarchy and a (IPM manifest) (`module.xml`) file in the top level. Here is an example of a simple `hello` module:
```
$ tree
.
├── hello
    ├── module.xml
    └── src
        └── OSEX
            └── ipm
                └── hello
                    └── Hello.cls
```

Load module from filesystem during development with `load` command:
```
zpm:IPMTEST1>list-installed -tree
zpm-registry 1.3.2
└──yaml-utils 0.1.4

zpm:IPMTEST1>load /home/irisowner/work/objectscript-ex/ipm/hello

[IPMTEST1|osex-ipm-hello]       Reload START (/home/irisowner/work/objectscript-ex/ipm/hello/)
[IPMTEST1|osex-ipm-hello]       Reload SUCCESS
[osex-ipm-hello]        Module object refreshed.
[IPMTEST1|osex-ipm-hello]       Validate START
[IPMTEST1|osex-ipm-hello]       Validate SUCCESS
[IPMTEST1|osex-ipm-hello]       Compile START
[IPMTEST1|osex-ipm-hello]       Compile SUCCESS
[IPMTEST1|osex-ipm-hello]       Activate START
[IPMTEST1|osex-ipm-hello]       Configure START
[IPMTEST1|osex-ipm-hello]       Configure SUCCESS
[IPMTEST1|osex-ipm-hello]       Activate SUCCESS

zpm:IPMTEST1>list-installed -tree
osex-ipm-hello 1.0.0
zpm-registry 1.3.2
└──yaml-utils 0.1.4

zpm:IPMTEST1>
```

### Manifest File (`module.xml`) Creation Helpers

Interactively:
```
zpm:IPMTEST1>generate

Enter module folder: /home/irisowner/work/foo1
Enter module name: osex.foo1
Enter module version: 1.0.0 =>
Enter module description: Lorem ipsum dolor sit amet.
Enter module keywords: ipm example
Enter module source folder: src =>

Existing Web Applications:
    /csp/healthshare/ipmtest1
    /csp/healthshare/ipmtest1/fhirconfig
    /csp/healthshare/ipmtest1/fhirconfig/api
    /csp/healthshare/ipmtest1/services
    /registry
    Enter a comma separated list of web applications or * for all:
Dependencies:
    Enter module:version or empty string to continue:
zpm:IPMTEST1>
```
Creates file `/home/irisowner/work/foo1/module.xml`

Template:
```
zpm:IPMTEST1>generate -t /home/irisowner/work/foo2
```

I don't show the export option (`generate -export`) as it is not the workflow I prefer.

## Publishing to Self-Hosted Remote Registry

Only one _remote_ registry can have publish attribute enabled. Run `repo -list` command and check `Deployment Enabled?` attribute.

You need to have the module loaded in the namespace (see above the use of `load` command).

Publish module to the "current" remote registry:
```
zpm:IPMTEST1>publish -verbose osex-ipm-hello
```

### Demo

An application `OSEX.ipm.demo` module that uses two library modules:
* `OSEX.ipm.hello`
* `OSEX.ipm.numbers`

Application uses global `^OSEX.ipm.demo` for installation and run time configuration.

How to export global definition (just to get the right file format):
```
IPMTEST1>do $system.OBJ.Export("OSEX.ipm.demo.GBL","OSEX.ipm.demo.GBL")

Exporting to XML started on 10/29/2024 18:20:39
Exporting global: ^OSEX.ipm.demo
Export finished successfully.
```

Later the file can be modified.
```
$ cat /iris/databases/IPMTEST1DB/OSEX.ipm.demo.GBL
```
```xml
<?xml version="1.0" encoding="UTF-8"?>
<Export generator="IRIS" version="26" zv="IRIS for UNIX (Ubuntu Server LTS for x86-64 Containers) 2022.1.2 (Build 574_0_22161U)" ts="2024-10-29 18:20:39">
<Global>
<Node><Sub>^OSEX.ipm.demo</Sub>
<Node><Sub>settings</Sub>
<Node><Sub>numberGenerator</Sub>
<Data>OSEX.ipm.numbers.Fibonacci</Data>
</Node>
</Node>
</Node>
</Global>
</Export>
```

Install:
```
zpm:IPMTEST1>install osex-ipm-demo
```
Configuration:
```
zpm:IPMTEST1>exec zw ^OSEX.ipm.demo

^OSEX.ipm.demo("settings","bar")="bar value from example.json"
^OSEX.ipm.demo("settings","defaultName")="Joe Black"
^OSEX.ipm.demo("settings","foo")="from manifest Resource attribute"
^OSEX.ipm.demo("settings","installDir")="/usr/irissys"
^OSEX.ipm.demo("settings","numberGenerator")="OSEX.ipm.numbers.Fibonacci"
```
Usage:
```
IPMTEST1>set demo = ##class(OSEX.ipm.demo.Main).%New()
IPMTEST1>do demo.Run()
IPMTEST1>do demo.SetDefaultName("Jani Hur")
IPMTEST1>do demo.SetNumberGenerator("OSEX.ipm.numbers.Random")
```