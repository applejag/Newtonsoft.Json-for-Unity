# CI scripts for Newtonsoft.Json-for-Unity

> :warning: Please keep in mind that these scripts are out of date and some of
> them do not even work any more!
>
> You can follow the progress of fixing these scripts in issue
> [#113](https://github.com/jilleJr/Newtonsoft.Json-for-Unity/issues/113).
>
> I'm terribly sorry for anyone who needs to use them, but I have not gotten
> around to fixing them yet. // @jilleJr

The scripts in this directory are used to build and test the package using
Docker images.

## Prerequisites

- **Powershell**:

  For Linux users, install the `dotnet` CLI and then install the `powershell`
  tool:

  ```sh
  # This will install the command `pwsh`
  dotnet tool install --global powershell
  ```
  
- **Docker**

- **Unity3D ULF license file**:

  To run Unity inside Docker images, you need to supply it with a license.
  There's a small guide on how to obtain them in my other repository over here:
  <https://github.com/jilleJr/Newtonsoft.Json-for-Unity.Converters/blob/master/Build/CIRCLECI_SETUP.md#obtain-unity-license-ulf-files>

  :warning: It was a while since I (@jilleJr) used these files so they may not
  work any more. They are starting to show their age, so to speak.

## Building

``` sh
./ci/local_build_into_package.ps1
```

This script will compile the project into the
`Src/Newtonsoft.Json-for-Unity/Plugins` directory using Docker images.

## Testing

``` sh
./ci/local_test_in_unity_container.ps1
```

This script will compile the project and run the tests in a Unity3D Docker
container.
