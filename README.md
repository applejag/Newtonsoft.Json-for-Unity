# ![Logo](Doc/icons/logo-with-unity.png) Newtonsoft.Json for Unity

[![Latest Version @ Cloudsmith](https://api-prd.cloudsmith.io/badges/version/jillejr/newtonsoft-json-for-unity/npm/jillejr.newtonsoft.json-for-unity/latest/x/?render=true&badge_token=gAAAAABeClWC7DvHIyN1IvhxcvGYUIO8CFfs-PsrT973U91i_wmUiuhrzsGZgXqecxQgrEMj4p_-UUUz7XaWjxH3NB8DfA2kkQ%3D%3D)](https://cloudsmith.io/~jillejr/repos/newtonsoft-json-for-unity/packages/detail/npm/jillejr.newtonsoft.json-for-unity/latest/)
[![Financial Contributors on Open Collective](https://opencollective.com/newtonsoftjson-for-unity/all/badge.svg?label=financial+contributors&style=flat-square)](https://opencollective.com/newtonsoftjson-for-unity) 
[![CircleCI](https://img.shields.io/circleci/build/gh/jilleJr/Newtonsoft.Json-for-Unity/master?logo=circleci&style=flat-square)](https://circleci.com/gh/jilleJr/Newtonsoft.Json-for-Unity)
[![Codacy grade](https://img.shields.io/codacy/grade/f91156e7066c484588f4dba263c8cf45?logo=codacy&style=flat-square)](https://www.codacy.com/manual/jilleJr/Newtonsoft.Json-for-Unity?utm_source=github.com&utm_medium=referral&utm_content=jilleJr/Newtonsoft.Json-for-Unity&utm_campaign=Badge_Grade)
[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-v2.0%20adopted-ff69b4.svg?style=flat-square)](/CODE_OF_CONDUCT.md)

Json.<i></i>NET is a popular high-performance JSON framework for .NET and the
most used framework throughout the whole .NET ecosystem.

This repo is a **fork** of [JamesNK/Newtonsoft.Json][newtonsoft.json.git]
containing custom builds for regular standalone, but more importantly AOT
targets such as all **IL2CPP builds (WebGL, iOS, Android, Windows, Mac OS X)**
and portable .NET **(UWP, WP8)**.

## Features

- Expected always up-to-date fork of Newtonsoft.Json

- Full Newtonsoft.Json.Tests test suite passes on Unity 2018.4.14f1 and
  2019.2.11f1 with Mono and IL2CPP as scripting backend.

- Precompiled as DLLs for faster builds

- Full support for IL2CPP builds

- Delivered via Unity Package Manager for easy updating and version switching

- [_Newtonsoft.Json.Utility_.**AotHelper**][wiki-fix-aot-using-aothelper]
  utility class for resolving common Ahead-Of-Time issues.
  [(Read more about AOT)][wiki-what-even-is-aot]

- Extensive
  [documentation of solving AOT issues with
  `link.xml`][wiki-fix-aot-using-link.xml]

## [Installation guide](https://github.com/jilleJr/Newtonsoft.Json-for-Unity/wiki/Installation-via-UPM)

Click the header. It goes to the Wiki where the guide is now located. Here is
the raw url:

- [Installation via UPM][wiki-installation-via-upm]

- [Installation via OpenUPM
  ![OpenUPM icon](Doc/icons/openupm-icon-16.png)][wiki-installation-via-openupm]

## Newtonsoft.Json-for-Unity specific links

- [Wiki about this project](https://github.com/jilleJr/Newtonsoft.Json-for-Unity/wiki)
- [Release Notes on GitHub from this repository](https://github.com/jilleJr/Newtonsoft.Json-for-Unity/releases)
- [Cloudsmith package](https://cloudsmith.io/~jillejr/repos/newtonsoft-json-for-unity/packages/detail/npm/jillejr.newtonsoft.json-for-unity/latest/)

## Official Json.<i></i>NET links

- [Source repository (github.com/JamesNK/Newtonsoft.Json)](https://github.com/JamesNK/Newtonsoft.Json)
- [Homepage (www.newtonsoft.com/json)](https://www.newtonsoft.com/json)
- [Documentation (www.newtonsoft.com/json/help)](https://www.newtonsoft.com/json/help)
- [Release Notes on GitHub from source repository](https://github.com/JamesNK/Newtonsoft.Json/releases)
- [Stack Overflow posts tagged with `json.net`](https://stackoverflow.com/questions/tagged/json.net)

## Contributing

To contribute please read the [CONTRIBUTING.md](/CONTRIBUTING.md)
guidelines. It contains info about

- How to edit the Src/Newtonsoft.Json projects to remain the ability to merge
  from JamesNKs repository without difficulties.

- Coding style.

- Naming style.

- Our level of usage of "git-flow".

- Keep the repo clean, both code & branches.

## Development

### Edit code

Open the `Src/Newtonsoft.Json.sln` solution file in Visual Studio and start
hacking.

Rule of thumb: Don't commit edits of the `Src/Newtonsoft.Json/`,
`Src/Newtonsoft.Json.Tests/`, or `Src/Newtonsoft.Json.TestConsole/` folders
for forking reasons. Exception is when doing a new release, as explained in
a section little further down below.

### Build

When using Visual Studio, open the `Src/Newtonsoft.Json.sln` solution and just
<kbd>Ctrl+Shift+B</kbd> 😜

When using command line, recommended to use MSBuild.exe for building and not the
dotnet CLI.

```powershell
PS> MSBuild.exe -t:build -restore .\Src\Newtonsoft.Json -p:Configuration=Debug
```

### Run tests

Run the Newtonsoft.Json.Tests normally via the Test Runner inside Visual Studio.

For testing inside Unity locally, look inside the
[Src/Newtonsoft.Json-for-Unity.Tests/README.md](/Src/Newtonsoft.Json-for-Unity.Tests/README.md)
for more information.

### Merging changes from JamesNK/Newtonsoft.Json

Common enough occurrence that we have a wiki page for just this.

Read the [Working with branches, section "Merging changes from JamesNKs
repo"][wiki-workingwithbranches#merging] wiki page.

---

This package is licensed under The MIT License (MIT)

Copyright &copy; 2019 Kalle Jillheden (jilleJr)  
<https://github.com/jilleJr/Newtonsoft.Json>

See full copyrights in [LICENSE.md][license.md] inside repository

[license.md]: https://github.com/jilleJr/Newtonsoft.Json-for-Unity/blob/master/LICENSE.md
[newtonsoft.json.git]: https://github.com/JamesNK/Newtonsoft.Json
[wiki-workingwithbranches]: https://github.com/jilleJr/Newtonsoft.Json-for-Unity/wiki/Working-with-branches
[wiki-workingwithbranches#merging]: https://github.com/jilleJr/Newtonsoft.Json-for-Unity/wiki/Working-with-branches#merging-changes-from-jamesnks-repo
[wiki-fix-aot-using-aothelper]: https://github.com/jilleJr/Newtonsoft.Json-for-Unity/wiki/Fix-AOT-using-AotHelper
[wiki-fix-aot-using-link.xml]: https://github.com/jilleJr/Newtonsoft.Json-for-Unity/wiki/Fix-AOT-using-link.xml
[wiki-what-even-is-aot]: https://github.com/jilleJr/Newtonsoft.Json-for-Unity/wiki/What-even-is-AOT
[wiki-installation-via-upm]: https://github.com/jilleJr/Newtonsoft.Json-for-Unity/wiki/Installation-via-UPM
[wiki-installation-via-openupm]: https://github.com/jilleJr/Newtonsoft.Json-for-Unity/wiki/Installation-via-OpenUPM

## Contributors

### Code Contributors

This project exists thanks to all the people who contribute. [[Contribute](CONTRIBUTING.md)].
<a href="https://github.com/jilleJr/Newtonsoft.Json-for-Unity/graphs/contributors"><img src="https://opencollective.com/newtonsoftjson-for-unity/contributors.svg?width=890&button=false" /></a>

### Financial Contributors

Become a financial contributor and help us sustain our community. [[Contribute](https://opencollective.com/newtonsoftjson-for-unity/contribute)]

#### Individuals

<a href="https://opencollective.com/newtonsoftjson-for-unity"><img src="https://opencollective.com/newtonsoftjson-for-unity/individuals.svg?width=890"></a>

#### Organizations

Support this project with your organization. Your logo will show up here with a link to your website. [[Contribute](https://opencollective.com/newtonsoftjson-for-unity/contribute)]

<a href="https://opencollective.com/newtonsoftjson-for-unity/organization/0/website"><img src="https://opencollective.com/newtonsoftjson-for-unity/organization/0/avatar.svg"></a>
<a href="https://opencollective.com/newtonsoftjson-for-unity/organization/1/website"><img src="https://opencollective.com/newtonsoftjson-for-unity/organization/1/avatar.svg"></a>
<a href="https://opencollective.com/newtonsoftjson-for-unity/organization/2/website"><img src="https://opencollective.com/newtonsoftjson-for-unity/organization/2/avatar.svg"></a>
<a href="https://opencollective.com/newtonsoftjson-for-unity/organization/3/website"><img src="https://opencollective.com/newtonsoftjson-for-unity/organization/3/avatar.svg"></a>
<a href="https://opencollective.com/newtonsoftjson-for-unity/organization/4/website"><img src="https://opencollective.com/newtonsoftjson-for-unity/organization/4/avatar.svg"></a>
<a href="https://opencollective.com/newtonsoftjson-for-unity/organization/5/website"><img src="https://opencollective.com/newtonsoftjson-for-unity/organization/5/avatar.svg"></a>
<a href="https://opencollective.com/newtonsoftjson-for-unity/organization/6/website"><img src="https://opencollective.com/newtonsoftjson-for-unity/organization/6/avatar.svg"></a>
<a href="https://opencollective.com/newtonsoftjson-for-unity/organization/7/website"><img src="https://opencollective.com/newtonsoftjson-for-unity/organization/7/avatar.svg"></a>
<a href="https://opencollective.com/newtonsoftjson-for-unity/organization/8/website"><img src="https://opencollective.com/newtonsoftjson-for-unity/organization/8/avatar.svg"></a>
<a href="https://opencollective.com/newtonsoftjson-for-unity/organization/9/website"><img src="https://opencollective.com/newtonsoftjson-for-unity/organization/9/avatar.svg"></a>
