# How to run tests

This folder, `Newtonsoft.Json-for-Unity.Tests`, contains the folder structure of a Unity project (`v2018.3.13f1`).

## Setup

**Copy** all files, except the `bin` and `obj` folders, from `Newtonsoft.Json.Tests` into its folder inside the Assets folder. À la:

```ps
# Powershell
> Copy-Item -Recurse $REPO\Src\Newtonsoft.Json.Tests\. $REPO\Src\Newtonsoft.Json-for-Unity.Tests\Assets\Newtonsoft.Json.Tests\

> Remove-Item -Recurse -Force $REPO\Src\Newtonsoft.Json-for-Unity.Tests\Assets\Newtonsoft.Json.Tests\bin
> Remove-Item -Recurse -Force $REPO\Src\Newtonsoft.Json-for-Unity.Tests\Assets\Newtonsoft.Json.Tests\obj

# Bash/Shell/POSIX
$ cp -a $REPO/Src/Newtonsoft.Json.Tests/. $REPO/Src/Newtonsoft.Json-for-Unity.Tests/Assets/Newtonsoft.Json.Tests/

$ rm -rf $REPO/Src/Newtonsoft.Json-for-Unity.Tests/Assets/Newtonsoft.Json.Tests/bin
$ rm -rf $REPO/Src/Newtonsoft.Json-for-Unity.Tests/Assets/Newtonsoft.Json.Tests/obj
```

**Build** the Unity package by running the script

```ps
# Powershell
> &$REPO\ci\Scripts\local_build_into_package.ps1

# Bash/Shell/POSIX
$ $REPO/ci/Scripts/local_build_into_package.ps1
```

## Running from command line

```ps
> $PATH_TO_YOUR_PROJECT=$REPO/Src/Newtonsoft.Json-for-Unity.Tests

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
