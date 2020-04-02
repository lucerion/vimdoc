# frozen_string_literal: true

require_relative './parsers/header_parser'
require_relative './parsers/content_parser'

module VimDoc
  class Parser
    def self.parse(path)
      new.parse(path)
    end

    def parse(path)
      lines = File.readlines(path)

      { header: Parsers::HeaderParser.parse(lines) }.merge!(Parsers::ContentParser.parse(lines))
    end
  end
end
