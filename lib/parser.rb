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
            section = VimDoc::Parsers::SectionParser.parse(block)
            section_tag = section[:tag]

            @tree[:sections] ||= {}
            @tree[:sections][section_tag] = section
          end

          block = []
          next # skip separator line
        end

        if table_of_contents_starts?(line)
          table_of_contents_block = true
          next # skip table of contents header
        end

        section_block = !header_block && !table_of_contents_block

        block << line unless empty_line?(line)
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
