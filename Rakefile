# frozen_string_literal: true

# SPDX-FileCopyrightText: 2025 Kerrick Long <me@kerricklong.com>
# SPDX-License-Identifier: AGPL-3.0-or-later

require "bundler/gem_tasks"
require "ratatui_ruby/devtools"

RatatuiRuby::Devtools.install_gem_tasks!(
  snippet_paths: %w[examples/widget_ examples/verify_ sig/examples/widget_ sig/examples/verify_]
)

# Import all tasks from the tasks/ directory
Dir.glob("tasks/*.rake").each { |r| import r }

task default: %w[lint:fix reuse:fix test lint license:new reuse steep]
