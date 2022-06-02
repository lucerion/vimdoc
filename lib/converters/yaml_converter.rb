# frozen_string_literal: true

require 'yaml'

module VimDoc
  module Converters
    class YAMLConverter < BaseConverter
      def convert(tree)
        tree.to_yaml
      end
    end
  end
end
