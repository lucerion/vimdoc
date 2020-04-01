# frozen_string_literal: true

require_relative './base_parser'

module VimDoc
  module Parsers
    class HeaderParser < BaseParser
      Node = Struct.new(:name, :description)

      def initialize
        @node = Node.new
      end

      def parse(lines)
        header = separate_line(lines.first)

        @node.tap do |node|
          node.name = header.first.tr(BaseParser::TAG_WRAPPER, '')
          node.description = header[1..-1].join(' ')
        end
      end
    end
  end
end
