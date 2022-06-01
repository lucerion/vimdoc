# frozen_string_literal: true

require_relative './base_parser'

module VimDoc
  module Parsers
    class HeaderParser < BaseParser
      def parse(lines)
        header_block = header_block(lines)
        header = separate_line(header_block.first)

        {}.tap do |node|
          node[:file] = header.first.tr(TAG_WRAPPER, '')
          node[:description] = header[1..-1].join(' ')
          node[:info] = header_block[1..-1]
        end
      end

      private

      def header_block(lines)
        header_lines = []
        lines.each do |line|
          break if block_separator?(line)
          header_lines << squish(line) unless empty_line?(line)
        end
        header_lines
      end
    end
  end
end
