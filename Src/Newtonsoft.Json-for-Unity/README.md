# Newtonsoft.Json for Unity

Json.NET is a popular high-performance JSON framework for .NET

This package is a fork of Newtonsoft.Json containing custom builds targeting standalone, portable (UWP, WP8), and AOT targets such as all IL2CPP builds (iOS, WebGL, Android, Windows, Mac OS X, et.al).

## Versioning format

_Staying with JamesNK's version syntax, but with a twist :dizzy:_

Based off JamesNK's versioning, but with the addition of two digits on the last segment.
This is for Newtonsoft.Json-for-Unity to be able to have independent releases,
at the same time still being easy to see which version of Json.NET it's based of.

![explanation of version][version-explanation.png]

Where official Json.NET 12.0.1 becomes Newtonsoft.Json-for-Unity 12.0.1_xx_.

## Changelog

Please see the [CHANGELOG.md][changelog.md] file inside this package.

## Installation via Unity Package Manager

Open `<project>/Packages/manifest.json`, add scope for `jillejr`, then add the package in the list of dependencies.

À la:

```json
{
  "scopedRegistries": [
    {
      "name": "Packages from jillejr",
      "url": "https://npm.cloudsmith.io/jillejr/newtonsoft-json-for-unity/",
      "scopes": ["jillejr"]
    }
  ],
  "dependencies": {
    "jillejr.newtonsoft.json-for-unity": "12.0.101",

    "com.unity.modules.ai": "1.0.0",
    "com.unity.modules.animation": "1.0.0",
    "com.unity.modules.assetbundle": "1.0.0",
    "com.unity.modules.audio": "1.0.0",
    "com.unity.modules.cloth": "1.0.0",
    "com.unity.modules.director": "1.0.0",
    "com.unity.modules.imageconversion": "1.0.0"
  }
}
```

## Updating the package

### Updating via the UI

Open the Package Manager UI `Window > Package Manager`

![preview of where window button is](https://i.imgur.com/0FvA5W6.png)

Followed by pressing the update button on the `jillejr.newtonsoft.json-for-unity` package

![preview of update button](https://i.imgur.com/H6LhK2n.png)

### Updating via the manifest file

Change the version field. You have to know the new version beforehand.

> Example, with this as old:
>
> ```json
> {
>   "dependencies": {
>     "jillejr.newtonsoft.json-for-unity": "12.0.101"
>   }
> }
> ```
>
> New, updated:
>
> ```json
> {
>   "dependencies": {
>     "jillejr.newtonsoft.json-for-unity": "12.0.201"
>   }
> }
> ```
>
> _Omitted `scopedRegistries` and Unity packages for readability_

---

This package is licensed under The MIT License (MIT)

Copyright (c) 2019 Kalle Jillheden (jilleJr)  
<https://github.com/jilleJr/Newtonsoft.Json-for-Unity>

See full copyrights in [LICENSE.md][license.md] inside repository

[license.md]: https://github.com/jilleJr/Newtonsoft.Json-for-Unity/blob/master/LICENSE.md
[changelog.md]: https://github.com/jilleJr/Newtonsoft.Json-for-Unity/blob/master/LICENSE.md
[version-explanation.png]: https://github.com/jilleJr/Newtonsoft.Json-for-Unity/raw/ce23d98230673744d73656b4c4f6bc1f9989c37a/Doc/version-explanation.png
