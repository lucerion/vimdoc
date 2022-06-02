# frozen_string_literal: true

module VimDoc
  module Converters
    class BaseConverter
      def self.convert(convert)
        new.convert(convert)
      end

      def convert
        raise NotImplementedError
      end
    end
  end
end
