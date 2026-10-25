<!--
SPDX-FileCopyrightText: 2026 Kerrick Long <me@kerricklong.com>
SPDX-License-Identifier: CC-BY-SA-4.0
-->

# Feature Request: Expose Tabs Title Rects

## Summary

`Tabs` computes the bounding rect for each tab title during rendering but does not expose this information. Interactive applications need these rects for mouse click hit-testing.

## The Problem

Building clickable tab interfaces requires knowing where each tab renders. When a user clicks within the tabs area, the application cannot determine which specific tab was clicked without duplicating the internal layout algorithm.

Currently, the only options are:

1. **Recompute the layout manually.** Duplicate the logic from `render_tabs`, accounting for padding, dividers, and title widths. This is fragile—any upstream change breaks the user's code.
2. **Use coarse hit-testing.** Check if a click is anywhere in the tabs area, then guess based on x-position. This breaks when titles have different widths or styled content.

Neither approach is satisfactory.

## Use Case

Consider a TUI with a tabbed interface:

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

The application wants to detect clicks on individual tab titles (`"Preview Email"`, `"Preview Commit"`, `"Announce"`) and switch to that tab.

Without title rects, the application must manually compute where each tab renders:

<!-- SPDX-SnippetBegin -->
<!--
  SPDX-SnippetCopyrightText: 2026 Kerrick Long <me@kerricklong.com>
  SPDX-License-Identifier: MIT-0
-->
```rust
// Manual calculation - fragile and duplicates internal logic
let divider_width = 3; // " ▸ " is 3 characters
let content_row = area.y + 1; // Skip top border
let mut x = area.x + 2; // Skip border + padding

let tab_rects: Vec<Rect> = titles.iter().map(|title| {
    let tab_width = title.len() as u16;
    let rect = Rect::new(x, content_row, tab_width, 1);
    x += tab_width + divider_width;
    rect
}).collect();
```
<!-- SPDX-SnippetEnd -->

This duplicates private logic from `Tabs::render_tabs` and breaks when:

- Padding is configured differently (`padding_left`, `padding_right`)
- Divider width changes
- Upstream layout logic changes
- A block is present (affects inner area calculation)

## Current State (v0.30.0)

`Tabs` has a private `render_tabs` method that computes title areas:

<!-- SPDX-SnippetBegin -->
<!--
  SPDX-SnippetCopyrightText: 2026 Kerrick Long <me@kerricklong.com>
  SPDX-License-Identifier: MIT-0
-->
```rust
// From src/widgets/tabs.rs - private rendering logic
fn render_tabs(&self, tabs_area: Rect, buf: &mut Buffer) {
    let mut x = tabs_area.left();
    for (i, title) in self.titles.iter().enumerate() {
        // ...padding and title rendering...
        
        // Title rect is computed here but not exposed
        if Some(i) == self.selected {
            buf.set_style(
                Rect {
                    x,
                    y: tabs_area.top(),
                    width: pos.0.saturating_sub(x),
                    height: 1,
                },
                self.highlight_style,
            );
        }
        // ...
    }
}
```
<!-- SPDX-SnippetEnd -->

The rect is computed for applying `highlight_style` but is not accessible to users.

## Proposed API

Following the pattern established by `Block::inner(area)`, add a pure computation method that takes an area and returns computed sub-rects without rendering:

<!-- SPDX-SnippetBegin -->
<!--
  SPDX-SnippetCopyrightText: 2026 Kerrick Long <me@kerricklong.com>
  SPDX-License-Identifier: MIT-0
-->
```rust
impl Tabs {
    /// Returns the bounding rect for each tab title given an area.
    ///
    /// The rects are returned in the same order as titles were added.
    /// Useful for hit-testing mouse clicks against specific tabs.
    ///
    /// # Example
    ///
    /// ```rust
    /// let tabs = Tabs::new(["Tab 1", "Tab 2", "Tab 3"])
    ///     .divider(" | ");
    ///
    /// let rects = tabs.title_rects(area);
    /// for (i, rect) in rects.iter().enumerate() {
    ///     if rect.contains(mouse_position) {
    ///         selected_tab = i;
    ///         break;
    ///     }
    /// }
    /// ```
    pub fn title_rects(&self, area: Rect) -> Vec<Rect> { ... }
}
```
<!-- SPDX-SnippetEnd -->

Alternatively, a single-lookup method:

<!-- SPDX-SnippetBegin -->
<!--
  SPDX-SnippetCopyrightText: 2026 Kerrick Long <me@kerricklong.com>
  SPDX-License-Identifier: MIT-0
-->
```rust
/// Returns the rect for the tab at the given index.
pub fn title_rect(&self, area: Rect, index: usize) -> Option<Rect> { ... }
```
<!-- SPDX-SnippetEnd -->

## Workaround

Without this API, users must replicate the tab layout algorithm. Here is the current approach used in RatatuiRuby:

<!-- SPDX-SnippetBegin -->
<!--
  SPDX-SnippetCopyrightText: 2026 Kerrick Long <me@kerricklong.com>
  SPDX-License-Identifier: MIT-0
-->
```rust
// Manually compute tab title positions
let divider_width = 3; // " ▸ " is 3 characters  
let content_row = area.y + 1; // Skip top border
let mut x = area.x + 2; // Skip left border + padding

let tab_rects: Vec<Rect> = TABS.iter().map(|title| {
    let tab_width = title.len() as u16;
    let rect = Rect::new(x, content_row, tab_width, 1);
    x += tab_width + divider_width;
    rect
}).collect();

// Hit testing
for (i, rect) in tab_rects.iter().enumerate() {
    if rect.contains(click_position) {
        current_tab = i;
        break;
    }
}
```
<!-- SPDX-SnippetEnd -->

This works for simple cases but breaks when:

- `padding_left` or `padding_right` are non-default
- The divider is styled (Span width differs from string length)
- A block wraps the tabs (inner area differs)
- Title text is styled (Line width differs from string length)

## Impact

This feature benefits any application with clickable tabs:

- Tab-based navigation interfaces
- Multi-panel applications with panel selectors
- Mode switchers (edit/view/preview)
- Category selectors

The `Tabs` widget is commonly used for navigation. Mouse interaction is a natural expectation for TUI applications running in modern terminals with mouse support.

---

This issue includes creative contributions from Claude (Anthropic) via Antigravity (Google). [https://declare-ai.org/1.0.0/creative.html](https://declare-ai.org/1.0.0/creative.html)

*Discovered while implementing click handling for tab navigation in RatatuiRuby.*
