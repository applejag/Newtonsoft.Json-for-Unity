# How to run tests

This folder, `Newtonsoft.Json-for-Unity.Tests`, contains the folder structure of a Unity project (`v2018.3.13f1`).

## Setup

**Copy** all files, except the `bin` and `obj` folders, from the source .NET projects into their folders inside the Assets folder. À la:

```none
<repo>/Src/Newtonsoft.Json/*
=> <repo>/Src/Newtonsoft.Json-for-Unity.Tests/Assets/Newtonsoft.Json/*

<repo>/Src/Newtonsoft.Json.Tests/*
=> <repo>/Src/Newtonsoft.Json-for-Unity.Tests/Assets/Newtonsoft.Json.Tests/*
```

## Running from command line

```ps
> Unity.exe -runTests -projectPath $PATH_TO_YOUR_PROJECT -testResults results.xml -testPlatform editmode
```

`testPlatform` values:

- `editmode` _(default)_
- `playmode`
- `StandaloneWindows`
- `StandaloneWindows64`
- `StandaloneOSXIntel`
- `StandaloneOSXIntel64`
- `iOS`
- `tvOS`
- `Android`
- `PS4`
- `XboxOne`

More info: <https://docs.unity3d.com/Manual/CommandLineArguments.html>
