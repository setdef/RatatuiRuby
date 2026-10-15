# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Long <me@kerricklong.com>
# SPDX-License-Identifier: AGPL-3.0-or-later
#++

# The Ruby versions a gemspec supports.
class SupportedRubies < Data.define(:requirement)
  def self.of(gemspec_path)
    new(requirement: Gem::Specification.load(gemspec_path).required_ruby_version)
  end

  def oldest
    _, version = requirement.requirements.find { |operator, _| operator == ">=" }
    version
  end
end
