# frozen_string_literal: true

module VimDoc
  module Converters
    class MarkdownConverter < BaseConverter
      NEW_LINE = "\n"
      EMPTY_LINE = nil
      CODE_BLOCK_SIGN = '```'

      def convert(tree)
        [
          header(tree[:header]),
          EMPTY_LINE,
          table_of_contents(tree[:table_of_contents]),
          EMPTY_LINE,
          sections(tree[:sections])
        ].join(NEW_LINE)
      end

      private

      attr_accessor :content

      def header(header)
        [
          h1(header[:tag]),
          EMPTY_LINE,
          header[:text]
        ].join(NEW_LINE)
      end

      def table_of_contents(table_of_contents)
        items = table_of_contents[:content].map { |line| link(line[:text]) }
        list(items).join(NEW_LINE)
      end

      def sections(sections)
        sections.map do |section|
          [
            h2(section[:title]),
            EMPTY_LINE,
            section_content(section[:content]).join(NEW_LINE),
            EMPTY_LINE
          ].join(NEW_LINE)
        end
      end

      def h1(text)
        "# #{text}"
      end

      def h2(text)
        "## #{text}"
      end

      def link(text, link = nil)
        "[#{text}](##{link || convert_to_link(text)})"
      end

      def list(items)
        items.map { |item| "* #{item}" }
      end

      def code_block(lines)
        [
          CODE_BLOCK_SIGN,
          lines.join(NEW_LINE),
          CODE_BLOCK_SIGN
        ].join(NEW_LINE)
      end

      def convert_to_link(text)
        text.downcase.gsub(/[[:punct:]]/, '').gsub(' ', '-')
      end

      def section_content(content)
        content.map { |line| line.is_a?(Array) ? code_block(line) : line }
      end
    end
  end
end
