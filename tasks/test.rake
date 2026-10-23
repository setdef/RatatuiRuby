# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2025 Kerrick Long <me@kerricklong.com>
# SPDX-License-Identifier: AGPL-3.0-or-later
#++

require "minitest/test_task"

# Clear the default test task created by Minitest::TestTask if it exists
Rake::Task["test"].clear if Rake::Task.task_defined?("test")

desc "Run all tests (Ruby and Rust)"
task test: %w[compile test:ruby test:rust]

namespace :test do
  desc "Run Rust tests"
  task :rust do
    Rake::Task["cargo:test"].invoke
  end

  # Create a specific Minitest task for Ruby tests
  Minitest::TestTask.create(:ruby) do |t|
    t.test_globs = ["test/**/*.rb", "examples/**/test_*.rb"]
    # Load test_helper before any test file, so SimpleCov starts before a test file
    # requires the library. test_helper requires minitest/autorun itself.
    t.framework = %(require "test_helper")
  end

  # Regenerate predicate tests before running Ruby tests
  Rake::Task["test:ruby"].enhance(["rbs:tests"])
end
