# frozen_string_literal: true

module VimDoc
  module Converters
    class MarkdownConverter < BaseConverter
      NEW_LINE = "\n"
      EMPTY_LINE = nil
      CODE_BLOCK = '```'

      LINE_TYPES = %i[
        empty_line
        separator
        header
        anchor
        link
        code_start
        code_end
        text
      ].freeze

      def convert(tree)
        content = []

        tree.each do |block|
          block.each do |line|
            parsed_line = line[:parsed]

            next if empty_line?(parsed_line.first)
            next if separator?(parsed_line.first)
            next if anchor_line?(parsed_line)

            if doc_header?(tree, line)
              content << h1(parsed_line.first[:text].gsub('*', '').gsub('.txt', ''))
              content << EMPTY_LINE
              content << parsed_line.last[:text]
              content << EMPTY_LINE
              next
            end

            if header?(parsed_line.first)
              content << h2(parsed_line.first[:text])
              content << EMPTY_LINE
              next
            end

            if link?(parsed_line.last)
              content << list_item(link(parsed_line))
              next
            end

            if code_start?(parsed_line.first) || code_end?(parsed_line.first)
              content << CODE_BLOCK
              content << EMPTY_LINE
              next
            end

            if text_line?(parsed_line)
              content << text_line(parsed_line)
              content << EMPTY_LINE
            end
          end
        end

        content.join(NEW_LINE)
      end

      private

      def anchor_line?(parsed_line)
        parsed_line.one? && anchor?(parsed_line.last)
      end

      def doc_header?(tree, line)
        first_file_line = tree.first.first[:origin] == line[:origin]
        first_file_line && anchor?(line[:parsed].first)
      end

      def text_line?(parsed_line)
        parsed_line.all? { |subline| text?(subline) }
      end

      def text_line(parsed_line)
        parsed_line.map { |subline| subline[:text] }.join(' ')
      end

      LINE_TYPES.each do |line_type|
        define_method("#{line_type}?") do |line|
          line[:type] == line_type
        end
      end

      def h1(text)
        "# #{text}"
      end

      def h2(text)
        "## #{text}"
      end

      def link(line)
        text = line.first[:text]
        link = text.downcase.gsub(' ', '-')

        "[#{text}](#{link})"
      end

      def list_item(text)
        "* #{text}"
      end
    end
  end
end
