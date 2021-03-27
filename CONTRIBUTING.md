<sup>*Yes, this is the same content as the [How to contribute][wiki-contributing] page on the wiki.*</sup>

# How to contribute
Any help given on this project is massively appreciated! ❤

Contributing can be done by writing docs and code, or simply by asking a
question! If you find something questionable, then so will probably many others
as well. If you find something not working as expected, telling us or publish a
pull request that fixes it is the best way around this.

Before starting, please read the guidelines on the subject on which you wish to
dig into before contributing to Newtonsoft.Json-for-Unity.

## Table of content

- [How to contribute](#how-to-contribute)
  - [Table of content](#table-of-content)
  - [Got a Question or Problem?](#got-a-question-or-problem)
  - [Found an Issue?](#found-an-issue)
  - [Want a Feature?](#want-a-feature)
  - [Submitting a Pull Request](#submitting-a-pull-request)

## Got a Question or Problem?

The [Newtonsoft.Json-for-Unity wiki][wiki] is a great place to start looking for
information.

If you have questions about this package, Newtonsoft.Json-for-Unity, you can
try out the [help request][github-help-request] issue template on this repo.
GitHub issues are the optimal way to get in contact with the maintainers of this
repository, and we're all happy to help.

If you have questions about how to use Json.NET, please read the
[Json.NET documentation][documentation] or ask on
[Stack Overflow][stackoverflow]. There are thousands of Json.NET questions on
Stack Overflow with the [`json.net`][stackoverflow] tag.

See the below sections for [reporting bugs](#found-an-issue) and
[feature requests](#want-a-feature) if that more suits your case.

## Found an Issue?

If you find a bug in the source code or a mistake in the documentation, you can
help by submitting an issue to the [GitHub Repository][github]. Even better you
can submit a Pull Request with a fix.

When submitting an issue please include the following information:

- A description of the issue

- The JSON, classes, and Json.NET code related to the issue

- The exception message and stacktrace if an error was thrown

- Version of the Newtonsoft.Json-for-Unity package you were using (ex: 12.0.101)

- Version of the Unity Editor (ex: 2019.1.1f1)

- Does your issue only appear on certain build targets? (ex: Windows Standalone,
  Android, WebGL, even the Editor?)

- If possible, please include code that reproduces the issue. [Dropbox][dropbox]
  or GitHub's [Gist][gist] can be used to share large code samples, or you could
  [submit a pull request](#submitting-a-pull-request) with the issue reproduced
  in a new test.

- **When creating an issue use the
  [Bug Report issue template][github-bug-report].**

The more information you include about the issue, the more likely it is to be
fixed!

## Want a Feature?

You can request a new feature by submitting an issue to the
[GitHub Repository][github].

- **When suggesting a feature use the
  [Feature Request issue template][github-feature-request].**

## Submitting a Pull Request

When submitting a pull request to the [GitHub Repository][github] make sure to
do the following:

- Check that new and updated code follows Newtonsoft.Json-for-Unity's existing
  code formatting and naming standard at the [Code style][wiki-codestyle] wiki
  page.

- Run Newtonsoft.Json-for-Unity's unit tests to ensure no existing functionality
  has been affected. See the
  [Src/Newtonsoft.Json-for-Unity.Tests/README.md][github-tests-docs] for more
  info.

- Write new unit tests to test your changes. All features and fixed bugs must
  have tests to verify they work

Read [GitHub Help][pullrequesthelp] for more details about creating pull
requests.

[github]: https://github.com/jilleJr/Newtonsoft.Json-for-Unity
[github-bug-report]: https://github.com/jilleJr/Newtonsoft.Json-for-Unity/issues/new?assignees=&labels=bug&template=bug_report.md&title=Bug%3A+
[github-feature-request]: https://github.com/jilleJr/Newtonsoft.Json-for-Unity/issues/new?assignees=&labels=enhancement&template=feature_request.md&title=Suggestion%3A+
[github-help-request]: https://github.com/jilleJr/Newtonsoft.Json-for-Unity/issues/new?assignees=&labels=&template=not-working-as-expected.md&title=Help%3A+
[github-tests-docs]: https://github.com/jilleJr/Newtonsoft.Json-for-Unity/blob/master/Src/Newtonsoft.Json-for-Unity.Tests/README.md
[wiki]: https://github.com/jilleJr/Newtonsoft.Json-for-Unity/wiki
[wiki-codestyle]: https://github.com/jilleJr/Newtonsoft.Json-for-Unity/wiki/Code-style
[wiki-contributing]: https://github.com/jilleJr/Newtonsoft.Json-for-Unity/wiki/How-to-contribute
[documentation]: https://www.newtonsoft.com/json/help
[stackoverflow]: https://stackoverflow.com/questions/tagged/json.net
[dropbox]: https://www.dropbox.com
[gist]: https://gist.github.com
[pullrequesthelp]: https://help.github.com/articles/using-pull-requests
