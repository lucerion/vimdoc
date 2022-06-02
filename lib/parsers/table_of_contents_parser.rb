# frozen_string_literal: true

module VimDoc
  module Parsers
    class TableOfContentsParser < BaseParser
      TAG_SIGN = '|'

      def parse(lines)
        lines.each_with_object({}) do |line, table_of_contents|
          title, tag = split_line_by_whitespaces(line)
          tag_text = delete_tag_signs(tag)
          table_of_contents[tag_text] = title
        end
      end
    end
  end
end
