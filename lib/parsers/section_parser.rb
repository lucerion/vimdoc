# frozen_string_literal: true

module VimDoc
  module Parsers
    class SectionParser < BaseParser
      TAG_LINE = /.*\*.*\*$/.freeze

      def parse(lines)
        header = split_line_by_whitespaces(lines.first)

        {}.tap do |node|
          node[:title] = header.first
          node[:tag] = delete_tag_signs(header.last)
          node[:content] = content(lines[1..-1])
        end
      end

      private

      def content(lines)
        lines.each_with_object([]) do |line, content_lines|
          content_line = delete_whitespaces(line)
          content_lines << content_line unless TAG_LINE.match(line)
        end
      end
    end
  end
end
