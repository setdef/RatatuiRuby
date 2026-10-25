<!--
SPDX-FileCopyrightText: 2026 Kerrick Long <me@kerricklong.com>
SPDX-License-Identifier: CC-BY-SA-4.0
-->

# Feature Request: Expose Block Title Rects

## Summary

`Block` computes the position of each title during rendering but does not expose this information. Interactive applications need title rects for mouse click hit-testing.

## The Problem

Building clickable TUI interfaces requires knowing where widgets render. When a block has multiple titles (e.g., a left-aligned title and a right-aligned toggle label), each title occupies a specific screen region. The application cannot query these regions.

Currently, the only options are:

1. **Recompute the layout manually.** Duplicate the logic from `render_left_titles`, `render_right_titles`, and `render_center_titles`. This is fragile—any upstream change breaks the user's code.
2. **Use coarse hit-testing.** Check if a click is anywhere in the block's top border row. This cannot distinguish between multiple titles.

Neither approach is satisfactory.

## Use Case

Consider a TUI with a tabbed interface where the block's title bar contains:

- A left-aligned title: `"Announce v0.7.3"`  
- A right-aligned toggle: `"emate"` (clickable to switch email clients)

<!-- SPDX-SnippetBegin -->
<!--
  SPDX-SnippetCopyrightText: 2026 Kerrick Long <me@kerricklong.com>
  SPDX-License-Identifier: MIT-0
-->
```
┌Announce v0.7.3───────────────────────────────emate┐
│ Preview Email  ▸  Preview Commit  ▸  Announce   │
│                                                   │
└───────────────────────────────────────────────────┘
```
<!-- SPDX-SnippetEnd -->

The application wants to:

1. Detect clicks on `"emate"` and toggle the email client
2. Detect clicks on tab names and switch tabs
3. Ignore clicks on the border characters

Without title rects, the application must manually compute where `"emate"` renders based on block width, borders, alignment, and title content. This duplicates private logic from `Block::render_right_titles`.

## Current State (v0.30.0)

`Block` has private methods that compute title areas:

<!-- SPDX-SnippetBegin -->
<!--
  SPDX-SnippetCopyrightText: 2026 Kerrick Long <me@kerricklong.com>
  SPDX-License-Identifier: MIT-0
-->
```rust
// Private - not accessible to users
fn titles_area(&self, area: Rect, position: Position) -> Rect { ... }
fn render_left_titles(&self, position: Position, area: Rect, buf: &mut Buffer) { ... }
fn render_center_titles(&self, position: Position, area: Rect, buf: &mut Buffer) { ... }
fn render_right_titles(&self, position: Position, area: Rect, buf: &mut Buffer) { ... }
```
<!-- SPDX-SnippetEnd -->

The `titles_area` method computes the general title region. The `render_*_titles` methods compute individual title rects during rendering but do not expose them.

## Proposed API

Following the pattern established by `Block::inner(area)`, add a pure computation method that takes an area and returns computed sub-rects without rendering:

<!-- SPDX-SnippetBegin -->
<!--
  SPDX-SnippetCopyrightText: 2026 Kerrick Long <me@kerricklong.com>
  SPDX-License-Identifier: MIT-0
-->
```rust
impl Block {
    /// Returns the bounding rect for each title given an area.
    ///
    /// The rects are returned in the same order as titles were added.
    /// Useful for hit-testing mouse clicks against specific titles.
    ///
    /// # Example
    ///
    /// ```rust
    /// let block = Block::bordered()
    ///     .title_top("Left Title")
    ///     .title_top(Line::from("Right").right_aligned());
    ///
    /// let rects = block.title_rects(area);
    /// if rects[1].contains(mouse_position) {
    ///     // Clicked on "Right"
    /// }
    /// ```
    pub fn title_rects(&self, area: Rect) -> Vec<Rect> { ... }
}
```
<!-- SPDX-SnippetEnd -->

Alternatively, expose the individual areas by alignment:

<!-- SPDX-SnippetBegin -->
<!--
  SPDX-SnippetCopyrightText: 2026 Kerrick Long <me@kerricklong.com>
  SPDX-License-Identifier: MIT-0
-->
```rust
/// Returns the rect for the title at the given index.
pub fn title_rect(&self, area: Rect, index: usize) -> Option<Rect> { ... }

/// Returns the titles area for a given position (top or bottom).
pub fn titles_area(&self, area: Rect, position: Position) -> Rect { ... }
```
<!-- SPDX-SnippetEnd -->

## Workaround

Without this API, users must replicate the title layout algorithm. Here is the current approach used in RatatuiRuby:

<!-- SPDX-SnippetBegin -->
<!--
  SPDX-SnippetCopyrightText: 2026 Kerrick Long <me@kerricklong.com>
  SPDX-License-Identifier: MIT-0
-->
```rust
// Manually compute right-aligned title position
let email_label_width = email_client.len() as u16;
let email_label_x = area.x + area.width - email_label_width - 2; // border + padding
let email_label_rect = Rect::new(email_label_x, area.y, email_label_width, 1);

if email_label_rect.contains(click_position) {
    toggle_email_client();
}
```
<!-- SPDX-SnippetEnd -->

This works for simple cases but breaks when:

- Borders are not all present (`Borders::LEFT` affects x offset)
- Multiple right-aligned titles exist (spacing affects position)
- Upstream layout logic changes

## Impact

This feature benefits any application with interactive block titles:

- Clickable tabs in title bars
- Toggle buttons in headers
- Breadcrumb navigation
- Window controls (minimize/maximize/close buttons in the title area)

Related discussion: [ratatui#738](https://github.com/ratatui/ratatui/issues/738) (title positioning behavior)

---

This issue includes creative contributions from Claude (Anthropic) via Antigravity (Google). [https://declare-ai.org/1.0.0/creative.html](https://declare-ai.org/1.0.0/creative.html)

*Discovered while implementing click handling for block title toggles in RatatuiRuby.*
