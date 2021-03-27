# Newtonsoft.Json for Unity changelog

## 13.0.102 (2021-03-24)

- ✨ New: Merged changes from
  [JamesNK/Newtonsoft.Json version `13.0.1`][json.net-13.0.1]

- 🗑 Deprecated: Removed the Portable build target. This package now only ships
  with the AOT and Editor builds.

## 12.0.302 (2021-02-19)

- ✨ New: Properly embed the link.xml into the DLLs. ([#54][#54])

- 🐛 Fix: Preserve `NullableAttribute` and `NullableContextAttribute`.
  ([#54][#54])

- 🐛 Fix: Preserve all JSON converters. ([#8][#8], [#65][#65])

## 12.0.301 (2020-01-19)

- ✨ New: Merged changes from
  [JamesNK/Newtonsoft.Json version `12.0.3`][json.net-12.0.3]

- 🔄 Change: Testing libraries are precompiled to be able to use the nullable
  reference types, as Unity does not yet support them. ([#37][#37])

## 12.0.201 (2020-01-03)

- ✨ New: Merged changes from
  [JamesNK/Newtonsoft.Json version `12.0.2`][json.net-12.0.2]

- ✨ New: Downgrade script for .asmdef to be able to test in Unity 2018.x.

- ✨ New: Now testing in both Unity 2019.x and 2018.x in CircleCI workflow.

- ✨ New: Added `System.Web.HttpUtility` polyfill to test project due to it's
  not included in IL2CPP builds.
  See <https://forum.unity.com/threads/solved-httputility-in-il2cpp.802368/#post-5333634>

- 🔄 Change: Custom StringAssert.StartsWith to get better error messages in
  tests.

- 🐛 Fix: AotHelper.EnsureDictionary was not generating constructor for
  `DefaultContractResolver.EnumerableDictionaryWrapper<TKey, TValue>`

## 12.0.102 (2019-12-30)

- ✨ New: Moved some documentation to the new wiki. All markdown files in the
  repository has been tidied.

- 🐛 Fix: Only use major version in assembly version (ex: `12.0.0.0`, instead of
  `12.0.1.0`) ([#18][#18])

- 🐛 Fix: Package targets .NET 4.5 & .NET 4.6.1 instead of recommended
  .NET Standard 2.0. Portable should still target the [PCL profile 259
  (`portable-net45+win8+wpa81+wp8`)][portable-class-library]. ([#29][#29])

- 🐛 Fix: Assembly not found due to unsigned and not strong named assembly.
  The packaged DLL's are now signed with the public key of Newtonsoft.Json.
  ([#7][#7], [#10][#10])

## 12.0.101 (2019-11-26)

- ✨ New: Setup CircleCI integration for build automation
  [![CircleCI badge][circleci-badge]][circleci-url]

- ✨ New: Setup Codacy integration for automated code reviews
  [![Codacy badge][codacy-badge]][codacy-url]

- 🔄 Change: Switched to [cloudsmith.com][cloudsmith-url] as registry provider
  instead of [npmjs.com][npmjs-url]
  [![Latest Version @ Cloudsmith][cloudsmith-badge]][cloudsmith-url]

- 🔄 Change: Better versioning format. For more info see
  [the wiki page][wiki-versioning]. Changes are based of off `12.0.1`
  version *(in previous format).*

- 🐛 Fix: Building on standalone causes plugin collision ([#3][#3])

## 12.0.1 (2019-07-18)

- ✨ New: Package published as an Unity Package Manager package on
  [npmjs.com][npmjs-url].
  ![npm badge][npmjs-badge]

- ✨ Initial release

- ✨ Based on [JamesNK/Newtonsoft.Json version `12.0.1`][json.net-12.0.1]

[#3]: https://github.com/jilleJr/Newtonsoft.Json-for-Unity/issues/3
[#7]: https://github.com/jilleJr/Newtonsoft.Json-for-Unity/issues/7
[#8]: https://github.com/jilleJr/Newtonsoft.Json-for-Unity/issues/8
[#10]: https://github.com/jilleJr/Newtonsoft.Json-for-Unity/issues/10
[#18]: https://github.com/jilleJr/Newtonsoft.Json-for-Unity/issues/18
[#29]: https://github.com/jilleJr/Newtonsoft.Json-for-Unity/pull/29
[#37]: https://github.com/jilleJr/Newtonsoft.Json-for-Unity/pull/37
[#54]: https://github.com/jilleJr/Newtonsoft.Json-for-Unity/issues/54
[#65]: https://github.com/jilleJr/Newtonsoft.Json-for-Unity/issues/65
[circleci-badge]: https://img.shields.io/circleci/build/gh/jilleJr/Newtonsoft.Json-for-Unity/master?logo=circleci&style=flat-square
[circleci-url]: https://circleci.com/gh/jilleJr/Newtonsoft.Json-for-Unity
[cloudsmith-badge]: https://api-prd.cloudsmith.io/badges/version/jillejr/newtonsoft-json-for-unity/npm/jillejr.newtonsoft.json-for-unity/latest/x/?render=true&badge_token=gAAAAABd0U7AyWhLGu6xjEAHz70w9zWbSk6ogsTrw3xvVpa2NXe7HJg_ua7r-G2cbWECxfM51y4uYgOdFOquHNoTQti080JM6w%3D%3D
[cloudsmith-url]: https://cloudsmith.io/~jillejr/repos/newtonsoft-json-for-unity/packages/detail/npm/jillejr.newtonsoft.json-for-unity/latest/#readme
[codacy-badge]: https://img.shields.io/codacy/grade/f91156e7066c484588f4dba263c8cf45?logo=codacy&style=flat-square
[codacy-url]: https://www.codacy.com/manual/jilleJr/Newtonsoft.Json-for-Unity?utm_source=github.com&utm_medium=referral&utm_content=jilleJr/Newtonsoft.Json-for-Unity&utm_campaign=Badge_Grade
[json.net-12.0.1]: https://github.com/JamesNK/Newtonsoft.Json/releases/12.0.1
[json.net-12.0.2]: https://github.com/JamesNK/Newtonsoft.Json/releases/12.0.2
[json.net-12.0.3]: https://github.com/JamesNK/Newtonsoft.Json/releases/12.0.3
[json.net-13.0.1]: https://github.com/JamesNK/Newtonsoft.Json/releases/13.0.1
[npmjs-badge]: https://img.shields.io/npm/v/jillejr.newtonsoft.json-for-unity?logo=npm&style=flat-square
[npmjs-url]: https://www.npmjs.com/package/jillejr.newtonsoft.json-for-unity
[portable-class-library]: https://docs.microsoft.com/en-us/dotnet/standard/net-standard#pcl-compatibility
[wiki-versioning]: https://github.com/jilleJr/Newtonsoft.Json-for-Unity/wiki/About-the-versioning
