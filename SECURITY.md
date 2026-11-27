<!--
  SPDX-FileCopyrightText: 2026 Kerrick Long <me@kerricklong.com>
  SPDX-License-Identifier: CC-BY-SA-4.0
-->

# Security policy

## Report a vulnerability privately

Report a vulnerability in RatatuiRuby through GitHub's private vulnerability reporting, never on the [forum](https://forum.setdef.com/c/ratatui-ruby/6), in an email thread, or anywhere else others can read it:

1. Open [the repository's Security tab](https://github.com/setdef/RatatuiRuby/security) and choose **Report a vulnerability**, or go straight to [a new private advisory](https://github.com/setdef/RatatuiRuby/security/advisories/new).
2. Fill in the form. Only the project's maintainers can see what you send.

If you aren't sure that a problem is a vulnerability, report it privately anyway.

## What to include

- The RatatuiRuby version, from `bundle info ratatui_ruby`.
- Your system: its operating system and processor, and the output of `ruby -v`.
- How to reproduce the problem: the code you ran and what happened.

## Which versions get fixes

[The README's Compatibility section](README.md#compatibility) lists the systems and Ruby versions RatatuiRuby supports. It makes no promise that an earlier release gets a fix. A fix ships in a new release, so install [the latest release](https://rubygems.org/gems/ratatui_ruby).
