# frozen_string_literal: true

module VimDoc
  module Parsers
    class BaseParser
      TAG_WRAPPER = '*'

      def parse(_lines)
        raise NotImplementedError
      end

      protected

      def separate_line(line)
        line.split(/\s/).delete_if(&method(:empty_line?))
      end

      def empty_line?(line)
        line.strip.empty?
      end
    end
  end
end
