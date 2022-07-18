# frozen_string_literal: true

require_relative './parsers'

module VimDoc
  class Parser
    SECTIONS_SEPARATOR = '='
    TABLE_OF_CONTENTS_TITLE = 'CONTENTS'

    attr_reader :tree

    def initialize
      @tree = {}
      @block = []
      @header_block = true
      @table_of_contents_block = false
      @section_block = false
    end

    def parse(file_path)
      File.readlines(file_path).each do |line|
        next if empty_line?(line)

        if end_of_block?(line)
          parse_block
          @block = []
          next # skip separator line
        end

        detect_block(line)

        @block << line
      end
    end

    private

    def parse_block
      parse_header_block if @header_block
      parse_table_of_contents_block if @table_of_contents_block
      parse_section_block if @section_block
    end

    def detect_block(line)
      @table_of_contents_block = true if table_of_contents_starts?(line)
      @section_block = !@header_block && !@table_of_contents_block
    end

    def parse_header_block
      @tree[:header] = VimDoc::Parsers::HeaderParser.parse(@block)
      @header_block = false
    end

    def parse_table_of_contents_block
      @tree[:table_of_contents] = VimDoc::Parsers::TableOfContentsParser.parse(@block)
      @table_of_contents_block = false
    end

    def parse_section_block
      @tree[:sections] ||= []
      @tree[:sections] << VimDoc::Parsers::SectionParser.parse(@block)
    end

    def table_of_contents_starts?(line)
      line.start_with?(TABLE_OF_CONTENTS_TITLE)
    end

    def end_of_block?(line)
      line.start_with?(SECTIONS_SEPARATOR)
    end

    def empty_line?(line)
      line.strip.empty?
    end
  end
end
