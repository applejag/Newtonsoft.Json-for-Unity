---
name: Not working as expected
about: Cant get this package to build or serialize properly, and I need help to get
  my project going.
title: 'Help: '
labels: ''
assignees: ''

---

<!--

If you have questions about how to use Json.NET, please read the Json.NET documentation or ask on Stack Overflow.

https://www.newtonsoft.com/json/help
https://stackoverflow.com/questions/tagged/json.net

There are thousands of Json.NET questions on Stack Overflow with the json.net tag.

These GitHub issues are only for reporting issues with the package itself. Try evaluate if the problem relates to Newtonsoft.Json or this fork that delivers it for Unity. If it is, report it at JamesNK's repository:
https://github.com/JamesNK/Newtonsoft.Json/issues

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

<!-- Easiest taken from window header -->
Using Unity version 👉 SPECIFY

### Checklist

<!--
Fill in with "x" between the brackets to confirm you've completed the task. Like so:
- [x] Completed task
-->

- [ ] Shutdown Unity, deleted the /Library folder, opened project again in Unity, and problem still remains.
- [ ] Checked to be using latest version of the package.
