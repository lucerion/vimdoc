# frozen_string_literal: true

module VimDoc
  module Parsers
    class BaseParser
      TAG_SIGN = '*'

      def self.parse(lines)
        new.parse(lines)
      end

      def parse(_lines)
        raise NotImplementedError
      end

      protected

      def split_line_by_whitespaces(line)
        delete_whitespaces(line).split(/[[:space:]]/)
      end

      def delete_whitespaces(line)
        line.gsub(/[[:space:]]+/, ' ').strip
      end

      def delete_tag_signs(line, tag_sign = TAG_SIGN)
        line.tr(tag_sign, '')
      end
    end
  end
end
