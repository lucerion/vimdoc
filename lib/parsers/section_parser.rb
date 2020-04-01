# frozen_string_literal: true

require_relative './base_parser'

module VimDoc
  module Parsers
    class SectionParser < BaseParser
      TAG_LINE = /.*\*.*\*$/.freeze

      SectionNode = Struct.new(:title, :content, :tag)

      attr_reader :title, :content, :tag

      def initialize
        @node = SectionNode.new
      end

      def parse(lines)
        header = separate_line(lines.first)

        @node.tap do |node|
          node.title = header.first
          node.tag = header.last.tr(BaseParser::TAG_WRAPPER, '')
          node.content =
            lines[1..-1].each_with_object([]) do |line, content_lines|
              content_line = line.gsub(/\s+/, ' ').strip
              content_lines << content_line unless tag_line?(content_line)
            end
        end
      end

      private

      def tag_line?(line)
        TAG_LINE.match(line)
      end
    end
  end
end
