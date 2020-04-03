# frozen_string_literal: true

require 'json'
require_relative './base_converter'

module VimDoc
  module Converters
    class JSONConverter < BaseConverter
      def convert(tree)
        JSON.pretty_generate(tree)
      end
    end
  end
end
