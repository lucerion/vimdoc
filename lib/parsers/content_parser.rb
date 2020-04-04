# frozen_string_literal: true

require_relative './base_parser'
require_relative './table_of_contents_parser'
require_relative './section_parser'

module VimDoc
  module Parsers
    class ContentParser < BaseParser
      SECTIONS_SEPARATOR = '='
      TABLE_OF_CONTENTS_TITLE = 'CONTENTS'

      def initialize
        @block_started = false
        @table_of_contents = false
        @lines = []
        @node = {}
      end

      def parse(lines)
        lines[1..-1].each(&method(:handle_line))
        @node
      end

      private

      def handle_line(line)
        case line
        when method(:empty_line?)
        when method(:block_ends?)
          parse_block
        when method(:block_starts?)
          @block_started = true
        when method(:table_of_contents_block?)
          @table_of_contents = true
        else
          @lines << line if @block_started
        end
      end

      def parse_block
        @table_of_contents ? parse_table_of_contents : parse_section
        @table_of_contents = false
        @lines = []
      end

      def parse_table_of_contents
        @node[:table_of_contents] = TableOfContentsParser.parse(@lines)
      end

      def parse_section
        section = SectionParser.parse(@lines)
        tag = section[:tag]

        @node[:sections] ||= {}
        @node[:sections][tag] = section
      end

      def block_starts?(line)
        block_separator?(line)
      end

      def block_ends?(line)
        block_separator?(line) && @block_started
      end

      def table_of_contents_block?(line)
        line.start_with?(TABLE_OF_CONTENTS_TITLE)
      end

      def block_separator?(line)
        line.start_with?(SECTIONS_SEPARATOR)
      end
    end
  end
end
