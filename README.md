# objectscript-ex

InterSystems [IRIS](https://www.intersystems.com/data-platform/) and [ObjectScript](https://docs.intersystems.com/irislatest/csp/docbook/DocBook.UI.Page.cls?KEY=GCOS_intro) code snippets and examples.

See [doc/](doc/) directory for random notes about the language and the platform.

[docker/](docker/) directory contains Docker compose file to run InterSystems IRIS Community Edition.

## TODO

* Add ObjectScript Quality [scan](https://community.intersystems.com/node/488951). It's free for open source projects.
* Check I'm conforming IPM source code [naming rules](https://community.intersystems.com/post/objectscript-package-manager-naming-convention#comment-182406) here.

## `ipm` Directory

InterSystems Package Manager (IPM) examples. See [README.md](ipm/README.md) for the details.

## `OSEX.IOP.FileExport`

[Interoperability](https://www.intersystems.com/data-platform/interoperability/) (IOP) production file operation (`EnsLib.File.PassthroughOperation`) example.

Assumes the input file encoding is UTF-8 and writes the the content to `/tmp/out` using file name specifier `%f_%Q%!+(_a)` with CP-1252 encoding.

Input file example:
```
This is foo example #1.
Stranger things: ÆÇØ.
```

Expected output file hex dump:
```
$ xxd /tmp/out/<FILE>
00000000: 5468 6973 2069 7320 666f 6f20 6578 616d  This is foo exam
00000010: 706c 6520 2331 2e0a 5374 7261 6e67 6572  ple #1..Stranger
00000020: 2074 6869 6e67 733a 20c6 c7d8 2e0a        things: .....
```

Note the unix EOL (`0a`).

The production is triggered with external ObjectScript package `Runner`:
```
NAMESPACE>zw ##class(OSEX.IOP.FileExport.Runner).Run("/tmp/foo")
```

## `OSEX.IOP.Jokes`

[Interoperability](https://www.intersystems.com/data-platform/interoperability/) (IOP) production outbound HTTP REST example that uses different humorous APIs.

Relevant InterSystems documentation:
* [Introduction to Developing Productions](https://docs.intersystems.com/irislatest/csp/docbook/DocBook.UI.Page.cls?KEY=EGDV_intro)
* [Creating REST Operations in Productions](https://docs.intersystems.com/irislatest/csp/docbook/DocBook.UI.Page.cls?KEY=EREST_operation)

The production is triggered with external ObjectScript package `Runner`:
```
NAMESPACE>zw ##class(OSEX.IOP.Jokes.Runner).Run("simpsons")
```

Mermaid [sequence diagram](https://mermaid.js.org/syntax/sequenceDiagram.html): [osex-iop-jokes.svg](osex-iop-jokes.svg)

## `OSEX.IOP.Misc`

Miscellany Interoperability (IOP) stuff:

`Misc.Operations.CustomHttpRequest` how to use custom HTTP request with `EnsLib.REST.Operation`.

Have WireMock running:
```
java -jar wiremock-standalone.jar \
 --disable-gzip \
 --no-request-journal \
 --port 8080 \
 --print-all-network-traffic \
 --root-dir wiremock/ \
 --verbose
```

Call:
```
set request = ##class(Ens.Request).%New()
set response = ##class(Ens.Response).%New()
zwrite ##class(Ens.Director).CreateBusinessService("Misc.Services.Main",.service)
zwrite service.ProcessInput(request,.response)
```

## `OSEX.IOP.UniversalExports`

[Interoperability](https://www.intersystems.com/data-platform/interoperability/) (IOP) production outbound HTTP REST example that demonstrates:
* how to transfers arbitrary long string data from one HTTP API to another one in production using [streams](https://docs.intersystems.com/irislatest/csp/docbook/Doc.View.cls?KEY=GOBJ_propstream)
* business operations' configuration is separated from production to [external service registry](https://docs.intersystems.com/irislatest/csp/docbook/DocBook.UI.Page.cls?KEY=EESB_registry_admin)
* how to decide message routing target business operations runtime based on configuration in external service registry
* how to configure external service registry programmatically

After ObjectScript code installation configure external service registry:
```
NAMESPACE>zw ##class(OSEX.IOP.UniversalExports.Util).Configure("<DIR>/osex-iop-universalexports-conf.json")
```

You can check and modify the configuration in IRIS Management Portal:
```
Home
 > Interoperability
  > Configure
   > External-Service Registry
```

Two running instances of `server.py` are required. The default configuration expects the servers running in:
* `localhost:8080`
* `localhost:8081`

`server.py` expects file `~/pg7000.txt` that can be generated e.g. with:
```
$ curl -L -o ~/pg7000.txt https://www.gutenberg.org/ebooks/7000.txt.utf-8
```

The content and size of the file is not important as long as the size is "big enough". Here I'm using [Kalevala](https://en.wikipedia.org/wiki/Kalevala) by Elias Lönnrot that is ~600KB.

The production is triggered with external ObjectScript package `Runner`:
```
NAMESPACE>zw ##class(OSEX.IOP.UniversalExports.Runner).Run("kalevala", 10)
```