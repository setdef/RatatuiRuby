// SPDX-FileCopyrightText: 2026 Kerrick Long <me@kerricklong.com>
// SPDX-License-Identifier: LGPL-3.0-or-later

// Require SAFETY comments on all unsafe blocks
#![warn(clippy::undocumented_unsafe_blocks)]
// Enable pedantic lints for stricter code quality
#![warn(clippy::pedantic)]
// Allow certain pedantic lints that are too noisy for FFI code
#![allow(clippy::missing_errors_doc)]
#![allow(clippy::missing_panics_doc)]
#![allow(clippy::non_std_lazy_statics)]
