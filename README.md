# ![Logo](Doc/icons/logo-with-unity.png) Newtonsoft.Json for Unity

[![Latest Version @ OpenUPM](https://img.shields.io/npm/v/jillejr.newtonsoft.json-for-unity?label=openupm&registry_uri=https://package.openupm.com&style=flat-square)](https://openupm.com/packages/jillejr.newtonsoft.json-for-unity/)
[![Latest Version @ Cloudsmith](https://api-prd.cloudsmith.io/badges/version/jillejr/newtonsoft-json-for-unity/npm/jillejr.newtonsoft.json-for-unity/latest/x/?render=true&badge_token=gAAAAABeClWC7DvHIyN1IvhxcvGYUIO8CFfs-PsrT973U91i_wmUiuhrzsGZgXqecxQgrEMj4p_-UUUz7XaWjxH3NB8DfA2kkQ%3D%3D)](https://cloudsmith.io/~jillejr/repos/newtonsoft-json-for-unity/packages/detail/npm/jillejr.newtonsoft.json-for-unity/latest/)
[![CircleCI](https://img.shields.io/circleci/build/gh/jilleJr/Newtonsoft.Json-for-Unity/master?logo=circleci&style=flat-square)](https://circleci.com/gh/jilleJr/Newtonsoft.Json-for-Unity)
[![Codacy grade](https://img.shields.io/codacy/grade/f91156e7066c484588f4dba263c8cf45?logo=codacy&style=flat-square)](https://www.codacy.com/manual/jilleJr/Newtonsoft.Json-for-Unity?utm_source=github.com&utm_medium=referral&utm_content=jilleJr/Newtonsoft.Json-for-Unity&utm_campaign=Badge_Grade)
[![Financial Contributors on Open Collective](https://opencollective.com/newtonsoftjson-for-unity/all/badge.svg?label=financial+contributors&style=flat-square)](https://opencollective.com/newtonsoftjson-for-unity) 
[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-v2.0%20adopted-ff69b4.svg?style=flat-square)](/CODE_OF_CONDUCT.md)

<abbr title="The names 'Json.NET' and 'Newtonsoft.Json' are interchangeable. They both refer to James Newton-King's JSON library.">
Json.<i></i>NET</abbr> is a popular high-performance JSON framework for .NET and
the most used framework throughout the whole .NET ecosystem.

This repo is a **fork** of [JamesNK/Newtonsoft.Json][newtonsoft.json.git]
containing custom builds for regular standalone, but more importantly AOT
targets such as all **IL2CPP builds (WebGL, iOS, Android, Windows, Mac OS X)**
and portable .NET **(UWP, WP8)**.

## Features

- *(🌟 new!)* [Newtonsoft.Json-for-Unity.Converters][json.net-4-unity.converters]
  package for converting Unity types, such as the Vector3, Quaternion, Color,
  and [many, many more!][json.net-4-unity.converters-compatability]

- Full support for IL2CPP builds

- Delivered via Unity Package Manager for easy updating and version switching

- Full Newtonsoft.Json.Tests test suite passes on Unity 2018.4.14f1 and
  2019.2.11f1 with Mono and IL2CPP as scripting backend.

- Precompiled as DLLs for faster builds

- [*Newtonsoft.Json.Utility*.**AotHelper**][wiki-fix-aot-using-aothelper]
  utility class for resolving common Ahead-Of-Time issues.
  [(Read more about AOT)][wiki-what-even-is-aot]

- Extensive [documentation of solving AOT issues with `link.xml`][wiki-fix-aot-using-link.xml]

## Installation

### Installation via [Package Installer][package-installer] *(experimental)*

1. [Click here to download `Install-jillejr.newtonsoft.json-for-unity-13.0.102.unitypackage`](https://package-installer.glitch.me/v1/installer/jilleJr/jillejr.newtonsoft.json-for-unity?registry=https%3A%2F%2Fnpm.cloudsmith.io%2Fjillejr%2Fnewtonsoft-json-for-unity)

2. Open the downloaded `.unitypackage` file in Unity. Easiestly done by
   drag'n'dropping the file into the Unity window.
   
3. Click "Import" to import it all.

4. Once the installer has successfully compiled, it will add the correct UPM
   registry and package to your project, followed by removing itself.

> The installer does not run until your project can successfully compile.
> Make sure to resolve all syntax- and other compiling errors, even just
> temporarily, so that the installer may execute.

Much love :heart: to [@needle-tools](https://github.com/needle-tools) for
making such a great tool!

### Installation via [OpenUPM][openupm] ![OpenUPM icon][openupm-icon.png]

```sh
openupm add jillejr.newtonsoft.json-for-unity
```

Full installation guide over at the wiki:
[Installation via OpenUPM
![OpenUPM icon][openupm-icon.png]][wiki-installation-via-openupm]

Much love :heart: to [@favoyang](https://github.com/favoyang) for making such a
great tool!

### Installation via pure UPM

Full installation guide over at the wiki:
[Installation via pure UPM][wiki-installation-via-upm]

### Installation via Git in UPM

You can also install via Git. This assumes you have Git installed on your
computer.

> This is the least recommended version (but works as a fallback) because:
>
> - You will not be able to update the package via the Package Manager
>   interface if you install via Git.
>
> - This requires you, your coworkers, and your CI/CD pipelines to have
>   Git installed for the project to build.
>
> - It takes a lot longer to install as UPM will in most version clone the
>   entire history of the project.

In later versions of Unity, you can import directly via the Package Manager
interface.

![UPM, add from Git URL dropdown](Doc/upm-via-git.png)

Supply the following URL:

```none
https://github.com/jilleJr/Newtonsoft.Json-for-Unity.git#upm
```

Full installation guide over at the wiki:
[Installation via Git in UPM][wiki-installation-via-git-in-upm]

## Newtonsoft.Json-for-Unity specific links

- Newtonsoft.Json-for-Unity Wiki: [Wiki of this fork](https://github.com/jilleJr/Newtonsoft.Json-for-Unity/wiki)
- Newtonsoft.Json-for-Unity release notes: [Release notes of this fork](https://github.com/jilleJr/Newtonsoft.Json-for-Unity/releases)
- Newtonsoft.Json-for-Unity package repo: [Cloudsmith package](https://cloudsmith.io/~jillejr/repos/newtonsoft-json-for-unity/packages/detail/npm/jillejr.newtonsoft.json-for-unity/latest/)
- Newtonsoft.Json-for-Unity QA: [GitHub discussions](https://github.com/jilleJr/Newtonsoft.Json-for-Unity/discussions/categories/q-a)

## Newtonsoft.Json links

- Newtonsoft.Json repo: [github.com/JamesNK/Newtonsoft.Json](https://github.com/JamesNK/Newtonsoft.Json)
- Newtonsoft.Json homepage: [www.newtonsoft.com/json](https://www.newtonsoft.com/json)
- Newtonsoft.Json documentation: [www.newtonsoft.com/json/help](https://www.newtonsoft.com/json/help)
- Newtonsoft.Json release notes: [Release Notes of source repository](https://github.com/JamesNK/Newtonsoft.Json/releases)
- Newtonsoft.Json QA: [Stack Overflow posts tagged with `json.net`](https://stackoverflow.com/questions/tagged/json.net)

## Contributing

Thankful that you're even reading this :)

If you want to contribute, here's what you can do:

- **Spread the word!** ❤ More users &rarr; more feedback &rarr; I get more
  will-power to work on this project. This is the best way to contribute!

- [Open an issue][issue-create]. Could be a feature request for a new converter,
  or maybe you've found a bug?

- [Tackle one of the unassigned issues][issue-list-unassigned]. If it looks like
  a fun task to solve and no one is assigned, then just comment on it and say
  that you would like to try it out.

  I realize that few of the issues are trivial, so if you wish to tackle
  something small then look at the list of unassigned issues over at the
  [Unity converters package][json.net-4-unity.converters] repoistory.

- Open a PR with some new feature or issue solved. Remember to ask before
  starting to work on anything, so no two are working on the same thing.

  Having a feature request or issue pop up and having the submitter suggesting
  themselves to later add a PR for a solution is the absolute greatest gift
  a repository maintainer could ever receive. 🎁

  I have this [CONTRIBUTING.md](/CONTRIBUTING.md) file that contains some
  guidelines. It may be good to read it beforehand.

## Development

### Edit code

Open the `Src/Newtonsoft.Json.sln` solution file in Visual Studio and start
hacking.

Rule of thumb: Don't commit edits of the `Src/Newtonsoft.Json/`,
`Src/Newtonsoft.Json.Tests/`, or `Src/Newtonsoft.Json.TestConsole/` folders
for forking reasons. Exception is when doing a new release, as explained in
a section little further down below.

### Prerequisites

- **Powershell**:

  For Linux users, install the `dotnet` CLI and then install the `powershell`
  tool:

  ```sh
  # This will install the command `pwsh`
  dotnet tool install --global powershell
  ```
  
- **Docker**

### Building

``` sh
./ci/local_build_into_package.ps1
```

This script will compile the project into the
`Src/Newtonsoft.Json-for-Unity/Plugins` directory using Docker images.

### Linting markdown

All pull requests must comply with the remark styling rules found in the
`.remarkrc` files within this repo. The `.md` files are linted automatically
by Codacy, but to run them locally you must first install some prerequisites:

1. Install NPM

2. Install `remark-cli` and some styling packages

   ```sh
   # You may need to add "sudo"
   npm install --global remark-cli

   # Intentionally not globally
   npm install remark-lint remark-preset-lint-markdown-style-guide remark-frontmatter
   ```

Then lint away! For example:

```sh
$ remark .github
.github/ISSUE_TEMPLATE/bug_report.md: no issues found
.github/ISSUE_TEMPLATE/feature_request.md: no issues found
.github/ISSUE_TEMPLATE/not-working-as-expected.md: no issues found
.github/ISSUE_TEMPLATE/question.md: no issues found
.github/PULL_REQUEST_TEMPLATE/code-update.md: no issues found
.github/PULL_REQUEST_TEMPLATE/docs-update.md: no issues found
```

### Merging changes from JamesNK/Newtonsoft.Json

Common enough occurrence that we have a wiki page for just this.

Read the [Working with branches, section "Merging changes from JamesNKs
repo"][wiki-workingwithbranches#merging] wiki page.

### Backporting changes

Most changes to this repo can be applied to all the different versions. For
example changes to the `link.xml` or bugfixes in the IL2CPP hotfixes should
be applied to all the different versions, 10.0.3, 11.0.2, 12.0.3, etc.

This repo has a `.backportrc.json` file that is used by the
[sqren/backport](https://github.com/sqren/backport) CLI to make this easier. It
is a tool that basically just does `git cherry-pick`, but with some other
features such as automatically create branches and PRs.

1. Install Node.js: <https://nodejs.org/en/download/>

2. Install the `backport` CLI globally

   ```sh
   npm install -g backport
   ```

3. Configure the `backport` tool. It needs a GitHub access token and username
   inside `~/.backport/config.json`.

   More info here: <https://github.com/sqren/backport/blob/master/docs/configuration.md#global-config-backportconfigjson>

4. After a PR merge, checkout `master` and pull the newly merged PR you want to
   backport, then run the `backport` CLI. It's interactive, so just follow the
   steps.

   ```sh
   git checkout master

   git pull

   # The tool is interactive. Choose the merge commit you want to backport
   # and it takes care of the rest.
   backport
   ```

## Shameless plug

This project, giving a stable Newtonsoft.Json experience to the Unity community,
is a hobby project for me and will always stay free.

If this tool gave you something you value, consider giving a coin back into this
tool. Sponsor me with a cup of coffee, I drink the cheap stuff! ☕

[![OpenCollective donar link][opencollective-img-induvidual]][opencollective-url]

---

This package is licensed under The MIT License (MIT)

Copyright &copy; 2019 Kalle Jillheden (jilleJr)  
<https://github.com/jilleJr/Newtonsoft.Json-for-Unity>

See full copyrights in [LICENSE.md][license.md] inside repository

[issue-create]: https://github.com/jilleJr/Newtonsoft.Json-for-Unity/issues/new/choose
[issue-list-unassigned]: https://github.com/jilleJr/Newtonsoft.Json-for-Unity/issues?q=is%3Aopen+is%3Aissue+no%3Aassignee
[json.net-4-unity.converters-compatability]: https://github.com/jilleJr/Newtonsoft.Json-for-Unity.Converters/blob/master/Doc/Compatability-table.md
[json.net-4-unity.converters]: https://github.com/jilleJr/Newtonsoft.Json-for-Unity.Converters
[license.md]: https://github.com/jilleJr/Newtonsoft.Json-for-Unity/blob/master/LICENSE.md
[newtonsoft.json.git]: https://github.com/JamesNK/Newtonsoft.Json
[opencollective-img-induvidual]: https://opencollective.com/newtonsoftjson-for-unity/individuals.svg?width=890
[opencollective-url]: https://opencollective.com/newtonsoftjson-for-unity
[openupm]: https://openupm.com/packages/jillejr.newtonsoft.json-for-unity/
[openupm-icon.png]: https://github.com/jilleJr/Newtonsoft.Json-for-Unity/raw/c43046bc4763c0a5d3b0164a4f0a92e40de9d10e/Doc/icons/openupm-icon-16.png
[package-installer]: https://package-installer.glitch.me/
[wiki-fix-aot-using-aothelper]: https://github.com/jilleJr/Newtonsoft.Json-for-Unity/wiki/Fix-AOT-using-AotHelper
[wiki-fix-aot-using-link.xml]: https://github.com/jilleJr/Newtonsoft.Json-for-Unity/wiki/Fix-AOT-using-link.xml
[wiki-installation-via-openupm]: https://github.com/jilleJr/Newtonsoft.Json-for-Unity/wiki/Installation-via-OpenUPM
[wiki-installation-via-upm]: https://github.com/jilleJr/Newtonsoft.Json-for-Unity/wiki/Installation-via-UPM
[wiki-installation-via-git-in-upm]: https://github.com/jilleJr/Newtonsoft.Json-for-Unity/wiki/Installation-via-Git-in-UPM
[wiki-what-even-is-aot]: https://github.com/jilleJr/Newtonsoft.Json-for-Unity/wiki/What-even-is-AOT
[wiki-workingwithbranches#merging]: https://github.com/jilleJr/Newtonsoft.Json-for-Unity/wiki/Working-with-branches#merging-changes-from-jamesnks-repo
[wiki-workingwithbranches]: https://github.com/jilleJr/Newtonsoft.Json-for-Unity/wiki/Working-with-branches
