# frozen_string_literal: true

module VimDoc
  module Parsers
    class HeaderParser < BaseParser
      def parse(lines)
        header = split_line_by_whitespaces(lines.first)

        {}.tap do |node|
          node[:tag] = delete_tag_signs(header.first)
          node[:description] = header[1..-1].join(' ')
          node[:content] = lines[1..-1].map(&method(:delete_whitespaces))
        end
      end
    end
  end
end
