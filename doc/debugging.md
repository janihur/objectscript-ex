# Debugging

Debugging is based on Visual Studio Code [debugging feature](https://code.visualstudio.com/docs/editor/debugging) and is supported by InterSystems ObjectScript extension pack.

Create [`launch.json`](../.vscode/launch.json). Example:
```json
{
    "version": "0.2.0",
    "configurations": [
        {
            "type": "objectscript",
            "request": "launch", // create a new process
            "name": "OSEX.Json.Transform",
            "program": "##class(OSEX.Json.Transform).Ex2()"
        },
        {
            "type": "objectscript",
            "request": "attach",
            "name": "Attach to a running process",
            "processId": "${command:PickProcess}",
            "system": true
        }
}
```