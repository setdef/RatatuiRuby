# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Long <me@kerricklong.com>
# SPDX-License-Identifier: AGPL-3.0-or-later
#++

# The gems Bundler locked for this project.
#
# CI installs the lockfile on every supported Ruby, but Bundler only checks
# gems against the Ruby that resolves it. A lockfile resolved on the newest
# Ruby can hold gems the oldest one can't install.
class GemLockfile < Data.define(:specs)
  def gems_too_new_for(ruby)
    specs.reject { |spec| spec.required_ruby_version.satisfied_by?(ruby) }
  end

  def verify(ruby)
    too_new = gems_too_new_for(ruby)
    return if too_new.empty?

    abort <<~MESSAGE
      These locked gems need a newer Ruby than #{ruby}, the oldest the gemspec supports:
      #{too_new.map { |spec| "  #{spec.full_name} (Ruby #{spec.required_ruby_version})" }.join("\n")}
      Resolve them with that Ruby instead:
        mise x ruby@#{ruby} -- bundle lock --update #{too_new.map(&:name).join(' ')}
    MESSAGE
  end
end
