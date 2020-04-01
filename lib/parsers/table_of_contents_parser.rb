# frozen_string_literal: true

require_relative './base_parser'

module VimDoc
  module Parsers
    class TableOfContentsParser < BaseParser
      TAG_WRAPPER = '|'

      def parse(lines)
        lines.each_with_object({}) do |line, result|
          title, tag = separate_line(line)
          tag_text = tag.tr(TAG_WRAPPER, '')
          result[tag_text] = title
        end
      end
    end
  end
end
