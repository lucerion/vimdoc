# frozen_string_literal: true

module VimDoc
  module Converters
    class BaseConverter
      def convert
        raise NotImplementedError
      end
    end
  end
end
