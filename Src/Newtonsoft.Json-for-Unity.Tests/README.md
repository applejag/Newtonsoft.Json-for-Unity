# How to run tests

This folder, `Newtonsoft.Json-for-Unity.Tests`, contains the folder structure of
a Unity project (`v2019.2.11f1`).

## Setup

**Copy** all files, except the `bin` and `obj` folders, from `Newtonsoft.Json.Tests`
into its folder inside the Assets folder. À la:

```ps1
# Powershell
Copy-Item -Recurse Src\Newtonsoft.Json.Tests\. Src\Newtonsoft.Json-for-Unity.Tests\Assets\Newtonsoft.Json.Tests\

Remove-Item -Recurse -Force Src\Newtonsoft.Json-for-Unity.Tests\Assets\Newtonsoft.Json.Tests\bin
Remove-Item -Recurse -Force Src\Newtonsoft.Json-for-Unity.Tests\Assets\Newtonsoft.Json.Tests\obj
```

**Build** the Unity package by running the script

> Make sure to have a Docker machine running.
> Installation: [docker.com](https://docs.docker.com/docker-for-windows/install/)

```ps1
# Powershell
ci\local_build_into_package.ps1 -VolumeSource $(pwd)
```

## Run tests

### Alt. 1: Using docker image

Runs the tests in a Linux container using [Docker](https://www.docker.com/).

```ps1
# Powershell
ci\local_test_in_unity_container.ps1 -VolumeSource $(pwd)
```

### Alt. 2: Running using Unity Editor

- Open the folder `Src\Newtonsoft.Json-for-Unity.Tests` using your installed
  Unity Editor.

- Then open the Test Runner panel, via menu
  **Window** > **General** > **Test Runner**.

- Enter the **PlayMode** tab

- Press **"Run All"**

### Alt. 3: Running via command line

Find your Unity.exe.
Usually at: `C:\Program Files\Unity\Hub\Editor\2019.2.11f1\Editor\Unity.exe`

```ps1
# Powershell
$Unity = "C:\Program Files\Unity\Hub\Editor\2019.2.11f1\Editor\Unity.exe"
&$Unity -runTests -batchmode -projectPath Src\Newtonsoft.Json-for-Unity.Tests -testResults results.xml -testPlatform playmode | Out-Default
```

`testPlatform` parameter values:

- `editmode` *(default)*
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
