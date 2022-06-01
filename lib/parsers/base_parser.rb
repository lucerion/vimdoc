# frozen_string_literal: true

module VimDoc
  module Parsers
    class BaseParser
      SECTIONS_SEPARATOR = '='
      TAG_WRAPPER = '*'

      def parse(_lines)
        raise NotImplementedError
      end

      protected

      def separate_line(line)
        squish(line).split(/[[:space:]]/)
      end

      def empty_line?(line)
        line.strip.empty?
      end

      def block_separator?(line)
        line.start_with?(SECTIONS_SEPARATOR)
      end

      def squish(line)
        line.gsub(/[[:space:]]+/, ' ').strip
      end
    end
  end
end
