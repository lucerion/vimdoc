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

      def delete_tag_signs(line)
        line.tr(self.class::TAG_SIGN, '')
      end
    end
  end
end
