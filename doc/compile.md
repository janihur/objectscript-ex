# Compile

Compilation options (used in `.vscode/settings.json` too):
```
b - Includes subclasses and classes that reference the current class in SQL usage.
c - Compiles the class definitions after loading.
k - Keep source. When this flag is set, source code of generated routines will be kept.
r - Recursive. Compiles all the classes that are dependency predecessors.
u - Update only. Skip compilation of classes that are already up-to-date.
TODO: replace flags (deprecated) with qualifiers
```

See [system qualifiers](https://docs.intersystems.com/irislatest/csp/docbook/Doc.View.cls?KEY=RCOS_vsystem_flags_qualifiers) and [`system-qualifiers.txt`](system-qualifiers.txt).