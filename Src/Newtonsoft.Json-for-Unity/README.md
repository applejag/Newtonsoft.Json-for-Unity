# Newtonsoft.Json for Unity

Json.NET is a popular high-performance JSON framework for .NET

This package is a fork of Newtonsoft.Json containing custom builds targeting
standalone, portable (UWP, WP8), and AOT targets such as all IL2CPP builds
(iOS, WebGL, Android, Windows, Mac OS X, et.al).

## Versioning format

_Staying with JamesNK's version syntax, but with a twist :dizzy:_

Based off JamesNK's versioning, but with the addition of two digits on the last
segment. This is for Newtonsoft.Json-for-Unity to be able to have independent
releases, at the same time still being easy to see which version of Json.NET
it's based of.

![explanation of version][version-explanation.png]

Where official Json.NET 12.0.1 becomes Newtonsoft.Json-for-Unity 12.0.1*xx*.

## Changelog

Please see the [CHANGELOG.md][changelog.md] file inside this package.

## Installation via [OpenUPM][openupm] ![OpenUPM icon][openupm-icon.png]

```sh
openupm add jillejr.newtonsoft.json-for-unity
```

## Other installation options

- [Installation via OpenUPM
  ![OpenUPM icon][openupm-icon.png]][wiki-installation-via-openupm]
  
- [Installation via pure UPM][wiki-installation-via-upm]

- [Installation via Git in UPM][wiki-installation-via-git-in-upm]

## Updating the package

### Updating via the UI

Open the Package Manager UI `Window > Package Manager`

![preview of where window button is](https://i.imgur.com/0FvA5W6.png)

Followed by pressing the update button on the `jillejr.newtonsoft.json-for-unity`
package

![preview of update button](https://i.imgur.com/H6LhK2n.png)

### Updating via the manifest file

Visit the wiki: [Installation via UPM][wiki-installation-via-upm]

---

This package is licensed under The MIT License (MIT)

Copyright (c) 2019 Kalle Jillheden (jilleJr)  
<https://github.com/jilleJr/Newtonsoft.Json-for-Unity>

See full copyrights in [LICENSE.md][license.md] inside repository

[license.md]: https://github.com/jilleJr/Newtonsoft.Json-for-Unity/blob/master/LICENSE.md
[changelog.md]: https://github.com/jilleJr/Newtonsoft.Json-for-Unity/blob/master/CHANGELOG.md
[version-explanation.png]: https://github.com/jilleJr/Newtonsoft.Json-for-Unity/raw/ce23d98230673744d73656b4c4f6bc1f9989c37a/Doc/version-explanation.png
[openupm]: https://openupm.com/packages/jillejr.newtonsoft.json-for-unity/
[openupm-icon.png]: https://github.com/jilleJr/Newtonsoft.Json-for-Unity/raw/c43046bc4763c0a5d3b0164a4f0a92e40de9d10e/Doc/icons/openupm-icon-16.png
[wiki-installation-via-openupm]: https://github.com/jilleJr/Newtonsoft.Json-for-Unity/wiki/Installation-via-OpenUPM
[wiki-installation-via-upm]: https://github.com/jilleJr/Newtonsoft.Json-for-Unity/wiki/Installation-via-UPM
[wiki-installation-via-git-in-upm]: https://github.com/jilleJr/Newtonsoft.Json-for-Unity/wiki/Installation-via-Git-in-UPM
