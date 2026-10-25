# frozen_string_literal: true

#--
# SPDX-FileCopyrightText: 2026 Kerrick Long <me@kerricklong.com>
# SPDX-License-Identifier: LGPL-3.0-or-later
#++

module RatatuiRuby
  class TUI
    # Widget factory methods for Session.
    #
    # Provides convenient access to all Widgets::* classes without
    # fully qualifying the class names. This is the largest mixin,
    # covering all renderable UI components.
    #
    # All factories use DWIM hash coercion: both `tui.table(hash)` and
    # `tui.table(**hash)` work correctly.
    module WidgetFactories
      # Creates a Widgets::Block.
      def block(first = nil, **kwargs)
        Widgets::Block.coerce_args(first, kwargs)
      end

      # Creates a Widgets::Paragraph.
      def paragraph(first = nil, **kwargs)
        Widgets::Paragraph.coerce_args(first, kwargs)
      end

      # Creates a Widgets::List.
      def list(first = nil, **kwargs)
        Widgets::List.coerce_args(first, kwargs)
      end

      # Creates a Widgets::ListItem.
      def list_item(first = nil, **kwargs)
        Widgets::ListItem.coerce_args(first, kwargs)
      end

      # Creates a Widgets::ListItem (DWIM alias).
      #
      # Terse alias for list_item. Clear in list context.
      alias item list_item

      # Creates a Widgets::Table.
      def table(first = nil, **kwargs)
        Widgets::Table.coerce_args(first, kwargs)
      end

      # Creates a Widgets::Row (for Table rows).
      def row(first = nil, **kwargs)
        Widgets::Row.coerce_args(first, kwargs)
      end

      # Creates a Widgets::Row (alias for table row).
      def table_row(first = nil, **kwargs)
        Widgets::Row.coerce_args(first, kwargs)
      end

      # Creates a Widgets::Cell (for Table cells).
      def table_cell(first = nil, **kwargs)
        Widgets::Cell.coerce_args(first, kwargs)
      end

      # Creates a Widgets::Tabs.
      def tabs(first = nil, **kwargs)
        Widgets::Tabs.coerce_args(first, kwargs)
      end

      # Creates a Widgets::Gauge.
      def gauge(first = nil, **kwargs)
        Widgets::Gauge.coerce_args(first, kwargs)
      end

      # Creates a Widgets::LineGauge.
      def line_gauge(first = nil, **kwargs)
        Widgets::LineGauge.coerce_args(first, kwargs)
      end

      # Creates a Widgets::Sparkline.
      def sparkline(first = nil, **kwargs)
        Widgets::Sparkline.coerce_args(first, kwargs)
      end

      # Creates a Widgets::BarChart.
      def bar_chart(first = nil, **kwargs)
        Widgets::BarChart.coerce_args(first, kwargs)
      end

      # Creates a Widgets::BarChart::Bar.
      def bar(first = nil, **kwargs)
        Widgets::BarChart::Bar.coerce_args(first, kwargs)
      end

      # Creates a Widgets::BarChart::BarGroup.
      def bar_group(first = nil, **kwargs)
        Widgets::BarChart::BarGroup.coerce_args(first, kwargs)
      end

      # Creates a Widgets::BarChart::Bar (alias).
      def bar_chart_bar(first = nil, **kwargs)
        Widgets::BarChart::Bar.coerce_args(first, kwargs)
      end

      # Creates a Widgets::BarChart::BarGroup (alias).
      def bar_chart_bar_group(first = nil, **kwargs)
        Widgets::BarChart::BarGroup.coerce_args(first, kwargs)
      end

      # Creates a Widgets::Chart.
      def chart(first = nil, **kwargs)
        Widgets::Chart.coerce_args(first, kwargs)
      end

      # Creates a Widgets::Dataset.
      def dataset(first = nil, **kwargs)
        Widgets::Dataset.coerce_args(first, kwargs)
      end

      # Creates a Widgets::Axis.
      def axis(first = nil, **kwargs)
        Widgets::Axis.coerce_args(first, kwargs)
      end

      # Creates a Widgets::Scrollbar.
      def scrollbar(first = nil, **kwargs)
        Widgets::Scrollbar.coerce_args(first, kwargs)
      end

      # Creates a Widgets::Calendar.
      def calendar(first = nil, **kwargs)
        Widgets::Calendar.coerce_args(first, kwargs)
      end

      # Creates a Widgets::Canvas.
      def canvas(first = nil, **kwargs)
        Widgets::Canvas.coerce_args(first, kwargs)
      end

      # Creates a Widgets::Clear.
      def clear(first = nil, **kwargs)
        Widgets::Clear.coerce_args(first, kwargs)
      end

      # Creates a Widgets::Cursor.
      def cursor(first = nil, **kwargs)
        Widgets::Cursor.coerce_args(first, kwargs)
      end

      # Creates a Widgets::Overlay.
      def overlay(first = nil, **kwargs)
        Widgets::Overlay.coerce_args(first, kwargs)
      end

      # Creates a Widgets::Center.
      def center(first = nil, **kwargs)
        Widgets::Center.coerce_args(first, kwargs)
      end

      # Creates a Widgets::RatatuiLogo.
      def ratatui_logo(first = nil, **kwargs)
        Widgets::RatatuiLogo.coerce_args(first, kwargs)
      end

      # Creates a Widgets::RatatuiMascot.
      def ratatui_mascot(first = nil, **kwargs)
        Widgets::RatatuiMascot.coerce_args(first, kwargs)
      end

      # Creates a Widgets::Shape::Label.
      def shape_label(first = nil, **kwargs)
        Widgets::Shape::Label.coerce_args(first, kwargs)
      end

      # =====================================
      # Widget Dispatcher (TIMTOWTDI)
      # =====================================

      # Creates a widget by type symbol.
      #
      # Plugin systems and config-driven UIs need to instantiate widgets by name.
      # Without a dispatcher, you need tedious case statements or reflection.
      #
      # This method routes widget creation through a single entry point.
      # Pass the type as a symbol and the remaining parameters as kwargs.
      #
      # Use it for dynamic UI generation, dashboard builders, or plugin architectures.
      #
      # Also available as: <tt>tui.paragraph</tt>, <tt>tui.list</tt>, etc.
      #
      # === Examples
      #
      #--
      # SPDX-SnippetBegin
      # SPDX-SnippetCopyrightText: 2026 Kerrick Long
      # SPDX-License-Identifier: MIT-0
      #++
      #   tui.widget(:paragraph, text: "Hello World")
      #   tui.widget(:list, items: %w[One Two Three])
      #
      #   # Config-driven widget creation
      #   widgets_config.each do |cfg|
      #     frame.render_widget(tui.widget(cfg[:type], **cfg[:options]), area)
      #   end
      #--
      # SPDX-SnippetEnd
      #++
      #
      # [type] Symbol naming the widget, such as <tt>:paragraph</tt> or <tt>:list</tt>. An unknown
      #        type raises ArgumentError listing every valid one.
      def widget(type, first = nil, **attributes)
        case type
        when :block then block(first, **attributes)
        when :paragraph then paragraph(first, **attributes)
        when :list then list(first, **attributes)
        when :table then table(first, **attributes)
        when :tabs then tabs(first, **attributes)
        when :gauge then gauge(first, **attributes)
        when :line_gauge then line_gauge(first, **attributes)
        when :sparkline then sparkline(first, **attributes)
        when :bar_chart then bar_chart(first, **attributes)
        when :chart then chart(first, **attributes)
        when :scrollbar then scrollbar(first, **attributes)
        when :calendar then calendar(first, **attributes)
        when :canvas then canvas(first, **attributes)
        when :clear then clear(first, **attributes)
        when :cursor then cursor(first, **attributes)
        when :overlay then overlay(first, **attributes)
        when :center then center(first, **attributes)
        when :ratatui_logo then ratatui_logo(first, **attributes)
        when :ratatui_mascot then ratatui_mascot(first, **attributes)
        else
          raise ArgumentError, "Unknown widget type: #{type.inspect}. " \
            "Valid types: :block, :paragraph, :list, :table, :tabs, :gauge, :line_gauge, " \
            ":sparkline, :bar_chart, :chart, :scrollbar, :calendar, :canvas, :clear, " \
            ":cursor, :overlay, :center, :ratatui_logo, :ratatui_mascot"
        end
      end
    end
  end
end
