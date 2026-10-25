# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Long <me@kerricklong.com>
# SPDX-License-Identifier: LGPL-3.0-or-later
#++

module RatatuiRuby
  module Widgets
    # Displays the Ratatui mascot.
    #
    # Interfaces without personality feel clinical and dry. Users appreciate a friendly face in their terminal.
    #
    # This widget renders the Ratatui mascot (a mouse).
    #
    # Use it to add charm to your application, greet users on startup, or as a decorative element in sidebars.
    #
    # {rdoc-image:/doc/images/widget_ratatui_mascot.png}[link:/examples/widget_ratatui_mascot/app_rb.html]
    #
    # === Example
    #
    # Run the interactive demo from the terminal:
    #
    #--
    # SPDX-SnippetBegin
    # SPDX-SnippetCopyrightText: 2026 Kerrick Long <me@kerricklong.com>
    # SPDX-License-Identifier: MIT-0
    #++
    #   ruby examples/widget_ratatui_mascot/app.rb
    #--
    # SPDX-SnippetEnd
    #++
    class RatatuiMascot < Data.define(:block)
      include CoerceableWidget

      ##
      # :method: new
      # :call-seq: new(block: nil) -> RatatuiMascot
      #
      # Creates a new RatatuiMascot.
      #
      # [block] Block (nullable) to wrap the widget in.
      def initialize(block: nil)
        super
      end
    end
  end
end
