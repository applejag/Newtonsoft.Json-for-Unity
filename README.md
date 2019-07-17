# ![Logo](Doc/icons/logo-with-unity.png) Newtonsoft.Json for Unity

Json.NET is a popular high-performance JSON framework for .NET

This repo is a **fork** of [Newtonsoft.Json][newtonsoft.json.git] containing custom builds
for regular standalone, but more importantly AOT targets such as all **IL2CPP builds**
**(WebGL, iOS, Android, Windows, Mac OS X)** and portable .NET **(UWP, WP8)**.

Available for installation with

- **Unity Package Manager (UPM)** `new!`
- ~~Unity Asset packages~~ _(coming soon)_
- ~~Unity Asset Store~~ _(coming soon)_

[newtonsoft.json.git]: https://github.com/JamesNK/Newtonsoft.Json

## Installation via UPM

> Requires Unity Editor `2018.1` or above, as UPM was first shipped with `2018.1`.

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

### Updating manually via the manifest file

> _(This is an alternative for updating. Following the guide above will suffice if your Package Manager is functional)_

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

## Alternative solutions

Using `2017.*` or below? Here are some alternative projects that may suffice for your Unity project:

- **Newtonsoft Json.NET for Unity3D** by SaladLab  
  [github.com/SaladLab/Json.Net.Unity3D](https://github.com/SaladLab/Json.Net.Unity3D#readme)

- **JSON .NET for Unity** by ParentElement  
  [parentelement.com/assets/json_net_unity](https://www.parentelement.com/assets/json_net_unity)  
  [assetstore.unity.com/packages/tools/input-management/json-net-for-unity](https://assetstore.unity.com/packages/tools/input-management/json-net-for-unity-11347)

## But why another solution

> SaladLab and ParentElement, among other unmentioned coders,
> have done great work in making Json.NET work in Unity. _So why do we need mine?_
>
> Both mentioned projects are discontinued, and outdated by some margin in result.
> SaladLab's latest release targets Json.NET 9, and ParentElement's Json.NET 8.
> We're at Json.NET 12 now! _(at time of writing)_
>
> Changeset, compared to SaladLabs and ParentElements solutions:
>
> - Json.NET version 12 _(let's see how long I can keep up with James repo)_
> - Release available via Unity Package Manager
> - Unit testing in Unity Editor
> - Unit testing in IL2CPP built platforms _(ex: StandaloneWindows)_
>
> A rework is in this case easier than jumping into SaladLabs project to update it. Sorry Salad champ.
>
> _Although, in the future this may also be old stuff too,
> with the upcoming new [System.Text.Json](https://devblogs.microsoft.com/dotnet/try-the-new-system-text-json-apis/)
> namespace and need to keep the project up-to-date with Newtonsoft.Json.
> But not for now!_

---

This package is licensed under The MIT License (MIT)

Copyright (c) 2019 Kalle Jillheden (jilleJr)  
<https://github.com/jilleJr/Newtonsoft.Json>

See full copyrights in [LICENSE.md][license.md] inside repository

[license.md]: https://github.com/jilleJr/Newtonsoft.Json-for-Unity/blob/master/LICENSE.md
