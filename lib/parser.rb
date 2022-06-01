# frozen_string_literal: true

require_relative './parsers/header_parser'
require_relative './parsers/content_parser'

module VimDoc
  class Parser
    def parse(file_path)
      lines = File.readlines(file_path)

      { header: Parsers::HeaderParser.new.parse(lines) }.merge!(Parsers::ContentParser.new.parse(lines))
    end
  end
end
