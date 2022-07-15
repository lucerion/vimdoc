# frozen_string_literal: true

module VimDoc
  module Parsers
    class HeaderParser < BaseParser
      def parse(lines)
        header = split_line_by_whitespaces(lines.first)

        {}.tap do |node|
          node[:text] = header[1..].join(' ')
          node[:tag] = delete_tag_signs(header.first)
          node[:content] = lines[1..].map(&method(:delete_whitespaces))
        end
      end
    end
  end
end
