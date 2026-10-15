# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Long <me@kerricklong.com>
# SPDX-License-Identifier: AGPL-3.0-or-later
#++

require "bundler"

# A version's source, exported to a directory. It runs commands with the Ruby
# and bundle that version declares, so each version's docs build exactly as
# they did when it was released.
class SourceTree < Data.define(:path)
  def ruby
    mise_ruby || ruby_version_file || gemfile_ruby || RUBY_VERSION
  end

  def run(command, env = {})
    Bundler.with_unbundled_env do
      system(env, "mise", "exec", "ruby@#{ruby}", "--", "sh", "-c", command, chdir: path)
    end
  end

  def upgrade_rdoc_to(minimum)
    return if locked_rdoc && locked_rdoc >= Gem::Version.new(minimum)

    File.write(File.join(path, "Gemfile"), %(\ngem "rdoc", "#{minimum}"\n), mode: "a")
    run("bundle lock --update rdoc") or raise "Could not lock RDoc #{minimum} in #{path}"
  end

  private def locked_rdoc
    version = read("Gemfile.lock")&.[](/^    rdoc \(([^)]+)\)/, 1)
    Gem::Version.new(version) if version
  end

  private def mise_ruby
    read("mise.toml")&.[](/^ruby\s*=\s*"([^"]+)"/, 1)
  end

  private def ruby_version_file
    read(".ruby-version")&.strip&.then { |version| version unless version.empty? }
  end

  private def gemfile_ruby
    read("Gemfile")&.[](/^ruby\s+["']([^"']+)["']/, 1)
  end

  private def read(name)
    file = File.join(path, name)
    File.read(file) if File.exist?(file)
  end
end
