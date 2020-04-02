# frozen_string_literal: true

require_relative './base_parser'

module VimDoc
  module Parsers
    class HeaderParser < BaseParser
      def parse(lines)
        header = separate_line(lines.first)

        {}.tap do |node|
          node[:name] = header.first.tr(TAG_WRAPPER, '')
          node[:description] = header[1..-1].join(' ')
        end
      end
    end
  end
end
