# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Long <me@kerricklong.com>
# SPDX-License-Identifier: AGPL-3.0-or-later
#++

require_relative "../rdoc_config"
require_relative "source_tree"

class VersionedDocumentation
  # Earlier releases locked RDoc 6.15 or 7.0, which render some markup wrongly
  # and predate the Aliki theme the site relies on. 7.2.0 is the oldest RDoc
  # whose output the site accepts; a version locking a newer one builds with
  # its own.
  RDOC_FLOOR = "7.2.0"

  def initialize(version)
    @version = version
  end

  def publish_to(path, project_name:, globs:, assets: [])
    puts "Building documentation for #{@version.name}..."

    absolute_path = File.absolute_path(path)
    custom_css_path = File.absolute_path("doc/custom.css")

    @version.checkout(globs:) do |source_path|
      # Each version builds with its own Ruby, bundle, and tasks, so upgrading
      # RDoc or the doc tasks on trunk never changes an earlier version's docs.
      tree = SourceTree.new(path: source_path)
      tree.upgrade_rdoc_to(RDOC_FLOOR)

      Dir.chdir(source_path) do
        title = "#{project_name} #{@version.name}"
        title = "#{project_name} (trunk)" if @version.edge?

        # Use rake rerdoc to ensure copy_examples runs
        # Set environment variables to override rdoc settings
        success = tree.run(
          "bundle install --quiet && bundle exec rake rerdoc",
          {
            "RDOC_OUTPUT" => absolute_path,
            "RDOC_TITLE" => title,
            "RDOC_CUSTOM_CSS" => custom_css_path,
          }
        )

        # Fall back to direct rdoc call if rake fails for any reason
        unless success
          puts "  Rake task failed, falling back to direct rdoc call..."
          files = globs.flat_map { |glob| Dir[glob] }.uniq
          tree.run(
            "bundle exec rdoc -o #{absolute_path} --main #{RDocConfig::MAIN} --title '#{title}' --template-stylesheets \"#{custom_css_path}\" #{files.join(' ')}"
          )
        end

        # Copy generated documentation to target path if it was generated elsewhere
        # This handles cases where RDOC_OUTPUT wasn't respected (evaluated at load time)
        temp_output_paths = ["tmp/rdoc", "doc"]
        temp_output_paths.each do |temp_path|
          # Check if this looks like generated rdoc (has index.html)
          if Dir.exist?(temp_path) && !Dir.empty?(temp_path) && File.exist?(File.join(temp_path, "index.html"))
            puts "  Copying generated docs from #{temp_path} to #{absolute_path}..."
            FileUtils.mkdir_p(absolute_path)
            FileUtils.cp_r Dir["#{temp_path}/*"], absolute_path
            break
          end
        end

        copy_assets_to(absolute_path, assets)
      end
    end
  end

  private def copy_assets_to(path, assets)
    assets.each do |asset_dir|
      if Dir.exist?(asset_dir)
        destination = File.join(path, asset_dir)
        FileUtils.mkdir_p(destination)
        FileUtils.cp_r Dir["#{asset_dir}/*"], destination
      end
    end
  end
end
