# frozen_string_literal: true

module VimDoc
  module Parsers
    class TableOfContentsParser < BaseParser
      TAG_SIGN = '|'

      def parse(lines)
        title, tag = split_line_by_whitespaces(lines.first)

        content =
          lines[1..].map do |line|
            content_title, content_tag = split_line_by_whitespaces(line)
            { text: content_title, tag: delete_tag_signs(content_tag, TAG_SIGN) }
          end

        {
          title: title,
          tag: delete_tag_signs(tag),
          content: content
        }
      end
    end
  end
end
