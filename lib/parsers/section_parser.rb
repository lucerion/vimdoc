# frozen_string_literal: true

require_relative './base_parser'

module VimDoc
  module Parsers
    class SectionParser < BaseParser
      TAG_LINE = /.*\*.*\*$/.freeze

      def parse(lines)
        header = separate_line(lines.first)

        {}.tap do |node|
          node[:title] = header.first
          node[:tag] = header.last.tr(TAG_WRAPPER, '')
          node[:content] = content(lines)
        end
      end

      private

      def content(lines)
        lines[1..-1].each_with_object([]) do |line, content_lines|
          content_line = line.gsub(/\s+/, ' ').strip
          content_lines << content_line unless tag_line?(content_line)
        end
      end

      def tag_line?(line)
        TAG_LINE.match(line)
      end
    end
  end
end
