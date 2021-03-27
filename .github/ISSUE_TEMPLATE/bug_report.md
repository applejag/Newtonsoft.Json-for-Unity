---
name: Bug report
about: Found something that doesn't work as documented or completely fails.
title: 'Bug: '
labels: bug
assignees: ''

---

## Expected behavior

<!-- Ex: To read this json on iOS: /followed by JSON code block/ -->

## Actual behavior

<!-- Crash at runtime? Did it work in the Editor? Fails to compile? -->

## Steps to reproduce

- New project
- Import `jillejr.newtonsoft.json-for-unity` via UPM
- Add following script to scene:

```csharp
void Start() {
    // Your calls to Newtonsoft.Json here
}
```

- Run the game

## Details

<!-- Windows/Mac/Linux? What dialect and version? -->
Host machine OS running Unity Editor 👉 SPECIFY

<!-- Windows/Mac/Linux/Android/iOS/WebGL/etc. -->
Unity build target 👉 SPECIFY

<!-- Found in manifest.json & Package Manager window. Ex: 12.0.101 -->
Newtonsoft.Json-for-Unity package version 👉 SPECIFY

<!-- Ex: 2019.1.11f1. Specify multiple if applicable. -->
I was using Unity version 👉 SPECIFY

## Checklist

<!--
Replace the space between the brackets with "x" to mark it as acknowledged. Like so:
- [x] Completed task
-->

- [ ] Shutdown Unity, deleted the /Library folder, opened project again in Unity, and problem still remains.
- [ ] Checked to be using latest version of the package.
