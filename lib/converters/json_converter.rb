# frozen_string_literal: true

require 'json'
require_relative './base_converter'

module VimDoc
  module Converters
    class JSONConverter < BaseConverter
      def convert(tree)
        tree.to_json
      end
    end
  end
end
