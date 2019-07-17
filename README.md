# ![Logo](Doc/icons/logo-with-unity.png) Newtonsoft.Json for Unity

Json.NET is a popular high-performance JSON framework for .NET

This repo is a **fork** of [Newtonsoft.Json][newtonsoft.json.git] containing custom builds
for regular standalone, but more importantly AOT targets such as all **IL2CPP builds**
**(WebGL, iOS, Android, Windows, Mac OS X)** and portable .NET **(UWP, WP8)**.

Available for installation with

- **Unity Package Manager** `new!`
- Unity Asset packages
- ~~Unity Asset Store~~ _(coming soon)_.

[newtonsoft.json.git]: https://github.com/JamesNK/Newtonsoft.Json

## Installation via Unity Package Manager

Open `<project>/Packages/manifest.json`, add scope for `jillejr`, then add the package in the list of dependencies.

À la:

```json
{
  "scopedRegistries": [
    {
      "name": "Packages from jillejr",
      "url": "https://registry.npmjs.org/",
      "scopes": ["jillejr"]
    }
  ],
  "dependencies": {
    "jillejr.json-for-unity": "12.0.1",

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

Followed by pressing the update button on the `jillejr.json-for-unity` package

![preview of update button](https://i.imgur.com/H6LhK2n.png)

### Updating via the manifest file

Change the version field. You have to know the new version beforehand.

> Example, with this as old:
>
> ```json
> {
>   "dependencies": {
>     "jillejr.json-for-unity": "12.0.1"
>   }
> }
> ```
>
> New, updated:
>
> ```json
> {
>   "dependencies": {
>     "jillejr.json-for-unity": "12.0.3"
>   }
> }
> ```
>
> _Omitted `scopedRegistries` and Unity packages for readability_

## Official Json.NET links

- [Homepage](https://www.newtonsoft.com/json)
- [Documentation](https://www.newtonsoft.com/json/help)
- [Release Notes](https://github.com/JamesNK/Newtonsoft.Json/releases)
- [Contributing Guidelines](CONTRIBUTING.md)
- [License](LICENSE.md)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/json.net)

---

This package is licensed under The MIT License (MIT)

Copyright (c) 2019 Kalle Jillheden (jilleJr)  
<https://github.com/jilleJr/Newtonsoft.Json>

See full copyrights in [LICENSE.md][license.md] inside repository

[license.md]: https://github.com/jilleJr/Newtonsoft.Json-for-Unity/blob/master/LICENSE.md
