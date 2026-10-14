<!--
  SPDX-FileCopyrightText: 2026 Kerrick Long <me@kerricklong.com>
  SPDX-License-Identifier: CC-BY-SA-4.0
-->

# The Ratatui Fork

RatatuiRuby builds on Ratatui from crates.io. Now and then a Ratatui bug breaks something RatatuiRuby promises its users, and no Ratatui release fixes it yet. Waiting would hold back every other upgrade. Working around the bug in our own code would mean reimplementing Ratatui's behavior beside it.

So RatatuiRuby carries the fix in a fork, [setdef/ratatui](https://github.com/setdef/ratatui), and builds against the forked crate until a Ratatui release includes the fix. Every patch in the fork is a deliberate departure from upstream Ratatui, which RatatuiRuby otherwise matches exactly, so keep the patches few and drop each one as soon as you can.

## What the Fork Carries

`ext/ratatui_ruby/Cargo.toml` replaces `ratatui-core` with the fork through `[patch.crates-io]`, pinned to the branch's last commit:

| Branch | Base | Commit | Change |
|--------|------|--------|--------|
| `ratatui-ruby/v0.30.2` | `ratatui-v0.30.2` | `e64d5e80` | Cherry-picked from upstream (ratatui/ratatui#2697): a symbol of several graphemes, such as an OSC 8 hyperlink, counts as one column. |
| | | `f241348f` | `TestBackend` resets the cells following a multi-width symbol, so stale characters don't appear in tests. |

The other Ratatui crates still come from crates.io. Patch only the crates the fork changes.

## Rules

- **Branch from a release tag.** Name the branch `ratatui-ruby/v<version>` after the Ratatui release it starts from.
- **One commit per fix.** A single focused commit cherry-picks cleanly onto the next release's branch, and you can leave it out once upstream fixes the bug.
- **Prefer upstream's own fix.** If Ratatui has merged a fix but not released it, cherry-pick it with `git cherry-pick -x` instead of writing your own.
- **Match Ratatui's style.** Write each fix the way Ratatui's maintainers would, and run `cargo +nightly fmt` and the crate's tests before pushing.
- **Pin an exact commit.** Use `rev = "<full sha>"` in `Cargo.toml`, never a branch name.
- **Only add commits on top.** A source install of any released gem fetches the fork at the commit that version pinned, so every pinned commit has to stay in its branch's history. Add new fixes at the tip. Never force-push, rebase, or delete a branch once `trunk` has pinned one of its commits.
- **Don't open pull requests upstream from AI-written patches.** Ratatui's contribution guidelines ask contributors to review every line of AI-generated code. Report the bug instead, and fix it in the fork.

## Upgrading Ratatui

1. Read the release's changelog and `BREAKING-CHANGES.md`.
2. Create `ratatui-ruby/v<new version>` from the new release tag.
3. Cherry-pick each fork commit that the release doesn't already fix, then format and test.
4. Push the branch and point the `rev` in `Cargo.toml` at its last commit.
5. Update the table above.

Leave the old branch in place. Released gems still fetch it.

## Removing the Fork

When a Ratatui release fixes everything the fork carries, delete the `[patch.crates-io]` block from `Cargo.toml` and empty the table above. Keep the fork's branches, since released gems still fetch them.
