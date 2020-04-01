# frozen_string_literal: true

require_relative './base_parser'
require_relative './table_of_contents_parser'
require_relative './section_parser'

module VimDoc
  module Parsers
    class ContentParser < BaseParser
      SECTIONS_SEPARATOR = '='
      TABLE_OF_CONTENTS_TITLE = 'CONTENTS'

      Node = Struct.new(:sections, :table_of_contents)

      attr_reader :sections, :table_of_contents

      def initialize
        @block_starts = false
        @table_of_contents_starts = false
        @lines = []
        @node = Node.new
      end

      def parse(lines)
        lines[1..-1].each do |line|
          next if empty_line?(line)

          if block_ends?(line)
            end_block
            next
          end

          if block_starts?(line)
            @block_starts = true
            next
          end

          if table_of_contents_starts?(line)
            @table_of_contents_starts = true
            next
          end

          @lines << line if @block_starts
        end

        @node
      end

      private

      def block_starts?(line)
        block_separator?(line)
      end

      def block_ends?(line)
        block_separator?(line) && @block_starts
      end

      def end_block
        parse_block

        @table_of_contents_starts = false
        @lines = []
      end

      def parse_block
        @table_of_contents_starts ? parse_table_of_contents : parse_section
      end

      def parse_table_of_contents
        @node.table_of_contents = TableOfContentsParser.parse(@lines)
      end

      def parse_section
        section = SectionParser.parse(@lines)
        @node.sections ||= {}
        @node.sections[section.tag] = section
      end

      def table_of_contents_starts?(line)
        line.start_with?(TABLE_OF_CONTENTS_TITLE)
      end

      def block_separator?(line)
        line.start_with?(SECTIONS_SEPARATOR)
      end
    end
  end
end
