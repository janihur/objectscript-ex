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

By default the community registry is used.

Useful commands:
* `help`
* `install`
* `list-installed -tree`
* `repo -list-modules`
* `search`
* `uninstall`

## The Registrys

* Community (i.e. public) registry, hosted by InterSystems
  * https://pm.community.intersystems.com
  * User interface frontend: https://openexchange.intersystems.com/ (covers also other sources than just the package manager)
* Self-hosted (a.k.a. private/local i.e. your own) registry
  * https://community.intersystems.com/post/setting-your-own-intersystems-objectscript-package-manager-registry

## Proxy

`<INSTALL_DIR>/zpm-registry.yaml`:
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

## Install Local Registry

* Developer Community:
  * [Setting Up Your Own InterSystems ObjectScript Package Manager Registry](https://community.intersystems.com/node/473661)

Note the ports in my setup:
* `52773` - used inside the container (i.e. in package manager shell)
* `52774` - exposed outside the container

Install the registry locally:
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

Publish a (random GitHub) package:
```bash
curl -i -X POST -H 'Content-Type:application/json' -d '{"repository":"https://github.com/psteiwer/ObjectScript-Math"}' http://localhost:52774/registry/package
```
List registry packages:
```
$ curl http://localhost:52774/registry/packages/-/all | jq '.'
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

Configure new _remote_ repository (named local) to be used in the namespace:
```
zpm:IPMTEST1>repo -name local -remote -publish 1 -url http://localhost:52773/registry/
```

Configure new _file system_ repository (named localfs) to be used in the namespace:
```
zpm:IPMTEST1>repo -name localfs -filesystem -depth 1 -path /home/irisowner/work/objectscript-ex/ipm/
```

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

### How to Create a Module

A module is nothing but predefined simple directory hierarchy and a (IPM manifest) (`module.xml`)  file in the top level. Here is an example of a simple `hello` module:
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

Load module from filesystem during development:
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

Only one _remote_ repo in the namespace can have publish attribute enabled. Currently the publish fails because missing authentication.

But _file system_ repository works fine.

Install:
```
zpm:IPMTEST1>install osex-ipm-demo
```
Configuration:
```
zpm:IPMTEST1>exec zw ^OSEX.ipm.demo

^OSEX.ipm.demo("settings","defaultName")="Joe Black"
^OSEX.ipm.demo("settings","numberGenerator")="OSEX.ipm.numbers.Fibonacci"
```
Usage:
```
IPMTEST1>set demo = ##class(OSEX.ipm.demo.Main).%New()
IPMTEST1>do demo.Run()
IPMTEST1>do demo.SetDefaultName("Jani Hur")
IPMTEST1>do demo.SetNumberGenerator("OSEX.ipm.numbers.Random")
```