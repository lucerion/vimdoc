# frozen_string_literal: true

module VimDoc
  module Converters
    class BaseConverter
      def self.convert(tree)
        new.convert(tree)
      end

      def convert
        raise NotImplementedError
      end
    end
  end
end
