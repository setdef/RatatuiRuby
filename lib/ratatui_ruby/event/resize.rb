# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Long <me@kerricklong.com>
# SPDX-License-Identifier: LGPL-3.0-or-later
#++

module RatatuiRuby
  class Event
    # Signals a change in terminal dimensions.
    #
    # The terminal window is dynamic, not static. The user changes its dimensions at will,
    # usually breaking a fixed layout.
    #
    # This event captures the new state. It delivers the updated +width+ and +height+
    # immediately after the change.
    #
    # Use these dimensions to drive your layout logic. Recalculate constraints. Reallocate space.
    # Fill the new canvas completely to maintain a responsive design.
    #
    # === Examples
    #
    # Using predicates:
    #--
    # SPDX-SnippetBegin
    # SPDX-SnippetCopyrightText: 2025 Kerrick Long
    # SPDX-License-Identifier: MIT-0
    #++
    #   if event.resize?
    #     puts "Resized to #{event.width}x#{event.height}"
    #   end
    #--
    # SPDX-SnippetEnd
    #++
    #
    # Using pattern matching:
    #--
    # SPDX-SnippetBegin
    # SPDX-SnippetCopyrightText: 2025 Kerrick Long
    # SPDX-License-Identifier: MIT-0
    #++
    #   case event
    #   in type: :resize, width:, height:
    #     puts "Resized to #{width}x#{height}"
    #   end
    #--
    # SPDX-SnippetEnd
    #++
    class Resize < Event
      # New terminal width in columns.
      #
      #--
      # SPDX-SnippetBegin
      # SPDX-SnippetCopyrightText: 2025 Kerrick Long <me@kerricklong.com>
      # SPDX-License-Identifier: MIT-0
      #++
      #   puts event.width # => 80
      #--
      # SPDX-SnippetEnd
      #++
      attr_reader :width

      # New terminal height in rows.
      #
      #--
      # SPDX-SnippetBegin
      # SPDX-SnippetCopyrightText: 2025 Kerrick Long <me@kerricklong.com>
      # SPDX-License-Identifier: MIT-0
      #++
      #   puts event.height # => 24
      #--
      # SPDX-SnippetEnd
      #++
      attr_reader :height

      # Returns true for Resize events.
      #
      #--
      # SPDX-SnippetBegin
      # SPDX-SnippetCopyrightText: 2025 Kerrick Long
      # SPDX-License-Identifier: MIT-0
      #++
      #   event.resize? # => true
      #   event.key?    # => false
      #   event.mouse?  # => false
      #--
      # SPDX-SnippetEnd
      #++
      def resize?
        true
      end

      # Creates a new Resize event.
      #
      # [width]
      #   New width (Integer).
      # [height]
      #   New height (Integer).
      def initialize(width:, height:)
        @width = width
        @height = height
      end

      # Deconstructs the event for pattern matching.
      #
      #--
      # SPDX-SnippetBegin
      # SPDX-SnippetCopyrightText: 2025 Kerrick Long
      # SPDX-License-Identifier: MIT-0
      #++
      #   case event
      #   in type: :resize, width:, height:
      #     puts "Resized to #{width}x#{height}"
      #   end
      #--
      # SPDX-SnippetEnd
      #++
      def deconstruct_keys(keys)
        { type: :resize, width: @width, height: @height }
      end

      ##
      # Converts the event to a Symbol representation.
      #
      # Always returns <tt>:resize</tt>.
      #
      # === Example
      #
      #--
      # SPDX-SnippetBegin
      # SPDX-SnippetCopyrightText: 2026 Kerrick Long
      # SPDX-License-Identifier: MIT-0
      #++
      #   event = Event::Resize.new(width: 80, height: 24)
      #   event.to_sym # => :resize
      #--
      # SPDX-SnippetEnd
      #++
      def to_sym
        :resize
      end

      ##
      # Compares the event with another object.
      #
      # - If +other+ is a +Symbol+, compares against #to_sym.
      # - If +other+ is a +Resize+, compares as a value object.
      # - Otherwise, returns +false+.
      #
      # === Example
      #
      #--
      # SPDX-SnippetBegin
      # SPDX-SnippetCopyrightText: 2026 Kerrick Long
      # SPDX-License-Identifier: MIT-0
      #++
      #   if event == :resize
      #     handle_resize(event)
      #   end
      #--
      # SPDX-SnippetEnd
      #++
      def ==(other)
        case other
        when Symbol then to_sym == other
        when Resize then width == other.width && height == other.height
        else false
        end
      end

      # Returns true. Unix <tt>SIGWINCH</tt> triggers terminal resize.
      #
      #--
      # SPDX-SnippetBegin
      # SPDX-SnippetCopyrightText: 2026 Kerrick Long <me@kerricklong.com>
      # SPDX-License-Identifier: MIT-0
      #++
      #   event.sigwinch? # => true
      #--
      # SPDX-SnippetEnd
      #++
      def sigwinch?
        true
      end

      alias winch? sigwinch?
      alias sig_winch? sigwinch?

      alias terminal_resize? resize?
      alias window_resize? resize?
      alias window_change? resize?
      alias viewport_resize? resize?
      alias viewport_change? resize?
      alias size_change? resize?
      alias resized? resize?

      VT100_WIDTH = 80 # :nodoc:
      VT100_HEIGHT = 24 # :nodoc:

      # Returns true if width exceeds height.
      #
      #--
      # SPDX-SnippetBegin
      # SPDX-SnippetCopyrightText: 2026 Kerrick Long <me@kerricklong.com>
      # SPDX-License-Identifier: MIT-0
      #++
      #   Event::Resize.new(width: 120, height: 24).landscape? # => true
      #--
      # SPDX-SnippetEnd
      #++
      def landscape?
        @width > @height
      end

      # Returns true if height exceeds or equals width.
      #
      #--
      # SPDX-SnippetBegin
      # SPDX-SnippetCopyrightText: 2026 Kerrick Long <me@kerricklong.com>
      # SPDX-License-Identifier: MIT-0
      #++
      #   Event::Resize.new(width: 40, height: 80).portrait? # => true
      #--
      # SPDX-SnippetEnd
      #++
      def portrait?
        @height >= @width
      end

      # Returns true if dimensions are exactly 80x24.
      #
      #--
      # SPDX-SnippetBegin
      # SPDX-SnippetCopyrightText: 2026 Kerrick Long <me@kerricklong.com>
      # SPDX-License-Identifier: MIT-0
      #++
      #   Event::Resize.new(width: 80, height: 24).vt100? # => true
      #--
      # SPDX-SnippetEnd
      #++
      def vt100?
        @width == VT100_WIDTH && @height == VT100_HEIGHT
      end

      # Returns true if both dimensions meet or exceed 80x24.
      #
      #--
      # SPDX-SnippetBegin
      # SPDX-SnippetCopyrightText: 2026 Kerrick Long <me@kerricklong.com>
      # SPDX-License-Identifier: MIT-0
      #++
      #   Event::Resize.new(width: 120, height: 40).at_least_vt100? # => true
      #--
      # SPDX-SnippetEnd
      #++
      def at_least_vt100?
        @width >= VT100_WIDTH && @height >= VT100_HEIGHT
      end

      # Returns true if both dimensions exceed 80x24.
      #
      #--
      # SPDX-SnippetBegin
      # SPDX-SnippetCopyrightText: 2026 Kerrick Long <me@kerricklong.com>
      # SPDX-License-Identifier: MIT-0
      #++
      #   Event::Resize.new(width: 81, height: 25).over_vt100? # => true
      #--
      # SPDX-SnippetEnd
      #++
      def over_vt100?
        @width > VT100_WIDTH && @height > VT100_HEIGHT
      end

      # Returns true if either dimension falls below VT100 standard.
      #
      #--
      # SPDX-SnippetBegin
      # SPDX-SnippetCopyrightText: 2026 Kerrick Long <me@kerricklong.com>
      # SPDX-License-Identifier: MIT-0
      #++
      #   Event::Resize.new(width: 60, height: 24).cramped? # => true
      #--
      # SPDX-SnippetEnd
      #++
      def cramped?
        @width < VT100_WIDTH || @height < VT100_HEIGHT
      end

      alias constrained? cramped?
    end
  end
end
