# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Long <me@kerricklong.com>
# SPDX-License-Identifier: LGPL-3.0-or-later
#++

module RatatuiRuby
  class TUI
    # Layout factory methods for Session.
    #
    # Provides convenient access to Layout::Rect, Layout::Constraint,
    # and Layout::Layout without fully qualifying the class names.
    module LayoutFactories
      # Creates a Layout::Rect.
      def rect(...)
        Layout::Rect.new(...)
      end

      # Creates a Layout::Constraint, with optional type-based dispatch.
      #
      # When called with a type symbol as the first argument, dispatches to
      # the appropriate constraint factory (TIMTOWTDI pattern).
      #
      # Also available as: <tt>tui.percent(50)</tt>, <tt>tui.flex(1)</tt>
      #
      # === Examples
      #
      #--
      # SPDX-SnippetBegin
      # SPDX-FileCopyrightText: 2026 Kerrick Long
      # SPDX-License-Identifier: MIT-0
      #++
      #   tui.constraint(:length, 10)     # => Constraint.length(10)
      #   tui.constraint(:percentage, 50) # => Constraint.percentage(50)
      #   tui.constraint(:min, 5)         # => Constraint.min(5)
      #   tui.constraint(:fill, 2)        # => Constraint.fill(2)
      #   tui.constraint(:ratio, 1, 3)    # => Constraint.ratio(1, 3)
      #--
      # SPDX-SnippetEnd
      #++
      def constraint(type_or_arg = nil, arg1 = nil, arg2 = nil, **)
        # Type-based dispatch when first arg is a symbol
        if type_or_arg.is_a?(Symbol)
          case type_or_arg
          when :length, :fixed
            constraint_length(arg1 || raise(ArgumentError, "#{type_or_arg} requires a value"))
          when :percentage, :percent
            constraint_percentage(arg1 || raise(ArgumentError, "#{type_or_arg} requires a value"))
          when :min
            constraint_min(arg1 || raise(ArgumentError, "min requires a value"))
          when :max
            constraint_max(arg1 || raise(ArgumentError, "max requires a value"))
          when :fill, :flex, :fr
            constraint_fill(arg1 || 1)
          when :ratio, :aspect
            n = arg1 || raise(ArgumentError, "ratio requires numerator")
            d = arg2 || raise(ArgumentError, "ratio requires denominator")
            constraint_ratio(n, d)
          else
            # Use to_s since type_or_arg must be a Symbol here
            raise ArgumentError, "Unknown constraint type: :#{type_or_arg}. " \
              "Valid types: :length, :percentage, :min, :max, :fill, :ratio"
          end
        elsif type_or_arg.nil? && arg1.nil?
          Layout::Constraint.new(**)
        else
          Layout::Constraint.new(type_or_arg, arg1, arg2, **)
        end
      end

      # Creates a Layout::Constraint.length.
      def constraint_length(n)
        Layout::Constraint.length(n)
      end

      # Creates a Layout::Constraint.percentage.
      def constraint_percentage(n)
        Layout::Constraint.percentage(n)
      end

      # Creates a Layout::Constraint.min.
      def constraint_min(n)
        Layout::Constraint.min(n)
      end

      # Creates a Layout::Constraint.max.
      def constraint_max(n)
        Layout::Constraint.max(n)
      end

      # Creates a Layout::Constraint.fill.
      def constraint_fill(n = 1)
        Layout::Constraint.fill(n)
      end

      # Creates a Layout::Constraint.ratio.
      def constraint_ratio(numerator, denominator)
        Layout::Constraint.ratio(numerator, denominator)
      end

      # Creates a Layout::Layout.
      def layout(...)
        Layout::Layout.new(...)
      end

      # Splits an area using Layout::Layout.split.
      # Returns an Array of Layout::Rect.
      def layout_split(area, direction: :vertical, constraints:, flex: :legacy)
        Layout::Layout.split(area, direction:, constraints:, flex:)
      end

      # Alias for #layout_split — shorter, more ergonomic.
      # Returns an Array of Layout::Rect.
      def split(area, direction: :vertical, constraints:, flex: :legacy)
        layout_split(area, direction:, constraints:, flex:)
      end

      # Alias for #constraint_length — CSS-inspired "fixed" sizing.
      def fixed(n)
        constraint_length(n)
      end

      # Alias for #constraint_percentage — CSS-inspired percent sizing.
      def percent(n)
        constraint_percentage(n)
      end

      # Alias for #constraint_fill — CSS Flexbox-inspired flexible sizing.
      def flex(n = 1)
        constraint_fill(n)
      end

      # Alias for #constraint_fill — CSS Grid-inspired "fr" (fraction) unit.
      def fr(n = 1)
        constraint_fill(n)
      end
    end
  end
end
