# frozen_string_literal: true

require_relative './parsers'

module VimDoc
  class Parser
    SECTIONS_SEPARATOR = '='
    TABLE_OF_CONTENTS_TITLE = 'CONTENTS'

    def initialize
      @tree = {}
    end

    def parse(file_path)
      block = []

      header_block = true
      table_of_contents_block = false
      section_block = false

      File.readlines(file_path).each do |line|
        next if empty_line?(line)

        if end_of_block?(line)
          if header_block
            @tree[:header] = VimDoc::Parsers::HeaderParser.parse(block)
            header_block = false
          end

          if table_of_contents_block
            @tree[:table_of_contents] = VimDoc::Parsers::TableOfContentsParser.parse(block)
            table_of_contents_block = false
          end

          if section_block
            @tree[:sections] ||= []
            @tree[:sections] << VimDoc::Parsers::SectionParser.parse(block)
          end

          block = []
          next # skip separator line
        end

        table_of_contents_block = true if table_of_contents_starts?(line)
        section_block = !header_block && !table_of_contents_block

        block << line
      end

      @tree
    end

    private

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
