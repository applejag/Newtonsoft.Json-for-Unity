---
name: Bug report
about: Found something that doesn't work as documented or completely fails.
title: 'Bug: '
labels: bug
assignees: ''

---

<!--

If you have questions about how to use Json.NET, please read the Json.NET documentation or ask on Stack Overflow.

https://www.newtonsoft.com/json/help
https://stackoverflow.com/questions/tagged/json.net

There are thousands of Json.NET questions on Stack Overflow with the json.net tag.

These GitHub issues are only for reporting bugs with the package itself.

-->

### Source/destination types

```csharp
// Put the types you are serializing or deserializing here, if applicable
```

### Source/destination JSON

```javascript
{"message":"Place your serialized or deserialized JSON here, if applicable"}
```

### Expected behavior

<!-- What did you expect to happen? -->

### Actual behavior

<!-- What happened instead? -->

### Steps to reproduce

- New project
- Import `jillejr.newtonsoft.json-for-unity` via UPM
- Add following script to scene:

```csharp
void Start() {
    // Your calls to Newtonsoft.Json here
}
```

- Run the game

### Details

<!-- Windows/Mac/Linux? What dialect and version? -->
Host machine OS running Unity Editor 👉 SPECIFY

<!-- Unity build target. Windows/Mac/Linux/Android/iOS/WebGL/et.al -->
Target platform running build 👉 SPECIFY

<!-- Found in manifest.json & Package Manager window. -->
Newtonsoft.Json-for-Unity package version 👉 SPECIFY

<!-- Version of Unity where bug is found. Specify multiple if applicable -->
❗️ Problem found in Unity versions 👉 SPECIFY

<!-- Version of Unity where bug cannot be reproduced. Specify multiple if applicable -->
❕ Problem not found in Unity versions 👉 -

### Checklist

<!--
Fill in with "x" between the brackets to confirm you've completed the task. Like so:
- [x] Completed task
-->

- [ ] Shutdown Unity, deleted the /Library folder, opened project again in Unity, and problem still remains.
- [ ] Checked to be using latest minor Unity version, ex: 2019.1, 2019.2, 2019.3.
- [ ] Reproduced in new project with minimal required code and assets.
- [ ] Tested IL2CPP vs Mono on same platform, on example: Windows.
- [ ] Tested .NET 4.x Equivalent vs .NET Standard 2.x Equivalent on same platform, on example: Windows.
