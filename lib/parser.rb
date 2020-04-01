# frozen_string_literal: true

require_relative './parsers/header_parser'
require_relative './parsers/content_parser'

module VimDoc
  class Parser
    Node = Struct.new(:header, :table_of_contents, :sections)

    def self.parse(path)
      new.parse(path)
    end

    def initialize
      @node = Node.new
    end

    def parse(path)
      lines = File.readlines(path)
      content = Parsers::ContentParser.parse(lines)

      @node.tap do |node|
        node.header = Parsers::HeaderParser.parse(lines)
        node.table_of_contents = content.table_of_contents
        node.sections = content.sections
      end
    end
  end
end
