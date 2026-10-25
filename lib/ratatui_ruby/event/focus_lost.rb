# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Long <me@kerricklong.com>
# SPDX-License-Identifier: LGPL-3.0-or-later
#++

module RatatuiRuby
  class Event
    # Signals that the application is in the background.
    #
    # The user has switched context. Your application is no longer the primary focus.
    #
    # This event warns of inactivity. It fires when the terminal window loses focus.
    #
    # Respond by conserving resources. Pause animations. Stop heavy polling. dim the UI to
    # indicate a background state.
    #
    # Only supported by some terminals (e.g. iTerm2, Kitty, newer xterm).
    #
    # === Example
    #
    #--
    # SPDX-SnippetBegin
    # SPDX-SnippetCopyrightText: 2025 Kerrick Long
    # SPDX-License-Identifier: MIT-0
    #++
    #   if event.focus_lost?
    #     puts "Focus lost"
    #   end
    #--
    # SPDX-SnippetEnd
    #++
    class FocusLost < Event
      # Returns true for FocusLost events.
      #
      #--
      # SPDX-SnippetBegin
      # SPDX-SnippetCopyrightText: 2025 Kerrick Long
      # SPDX-License-Identifier: MIT-0
      #++
      #   event.focus_lost? # => true
      #   event.key?        # => false
      #--
      # SPDX-SnippetEnd
      #++
      def focus_lost?
        true
      end

      # Deconstructs the event for pattern matching.
      #
      #--
      # SPDX-SnippetBegin
      # SPDX-SnippetCopyrightText: 2025 Kerrick Long
      # SPDX-License-Identifier: MIT-0
      #++
      #   case event
      #   in type: :focus_lost
      #     puts "Application lost focus"
      #   end
      #--
      # SPDX-SnippetEnd
      #++
      def deconstruct_keys(keys)
        { type: :focus_lost }
      end

      ##
      # Compares this event with another for equality.
      def ==(other)
        other.is_a?(FocusLost)
      end

      # =========================================================================
      # DWIM Predicates
      # =========================================================================

      # Returns true. The terminal has lost focus (blur).
      #
      #--
      # SPDX-SnippetBegin
      # SPDX-SnippetCopyrightText: 2026 Kerrick Long <me@kerricklong.com>
      # SPDX-License-Identifier: MIT-0
      #++
      #   event.blur? # => true
      #--
      # SPDX-SnippetEnd
      #++
      def blur?
        true
      end
      alias blurred? blur?

      # Returns true. The application lost focus.
      #
      #--
      # SPDX-SnippetBegin
      # SPDX-SnippetCopyrightText: 2026 Kerrick Long <me@kerricklong.com>
      # SPDX-License-Identifier: MIT-0
      #++
      #   event.lost? # => true
      #--
      # SPDX-SnippetEnd
      #++
      def lost?
        true
      end
      alias unfocused? lost?

      # Returns false. This is not a focus gained event.
      #
      #--
      # SPDX-SnippetBegin
      # SPDX-SnippetCopyrightText: 2026 Kerrick Long <me@kerricklong.com>
      # SPDX-License-Identifier: MIT-0
      #++
      #   event.focus? # => false
      #--
      # SPDX-SnippetEnd
      #++
      def focus?
        false
      end
      alias focused? focus?

      # Returns false. This is not a gained event.
      #
      #--
      # SPDX-SnippetBegin
      # SPDX-SnippetCopyrightText: 2026 Kerrick Long <me@kerricklong.com>
      # SPDX-License-Identifier: MIT-0
      #++
      #   event.gained? # => false
      #--
      # SPDX-SnippetEnd
      #++
      def gained?
        false
      end

      # Returns true. The application is inactive.
      #
      #--
      # SPDX-SnippetBegin
      # SPDX-SnippetCopyrightText: 2026 Kerrick Long <me@kerricklong.com>
      # SPDX-License-Identifier: MIT-0
      #++
      #   event.inactive? # => true
      #--
      # SPDX-SnippetEnd
      #++
      def inactive?
        true
      end
      alias background? inactive?

      # Returns false. The application is not active.
      #
      #--
      # SPDX-SnippetBegin
      # SPDX-SnippetCopyrightText: 2026 Kerrick Long <me@kerricklong.com>
      # SPDX-License-Identifier: MIT-0
      #++
      #   event.active? # => false
      #--
      # SPDX-SnippetEnd
      #++
      def active?
        false
      end
      alias foreground? active?
    end
  end
end
