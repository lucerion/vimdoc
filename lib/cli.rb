# frozen_string_literal: true

require_relative './options'
require_relative './parser'
require_relative './converters'

module VimDoc
  class CLI
    CONVERTERS = {
      markdown: Converters::MarkdownConverter,
      json: Converters::JSONConverter,
      yaml: Converters::YAMLConverter
    }.freeze
    DEFAULT_CONVERTER = CONVERTERS[:json].freeze

    def initialize(args)
      @args = args
    end

    def run
      options.help if args.empty?
      options.parse!(args)
      options.validate!

      puts(content)
    end

    private

    attr_reader :args

    def content
      parser.parse(options.input_file)
      converter.convert(parser.tree)
    end

    def options
      @options ||= VimDoc::Options.new
    end

    def parser
      @parser ||= Parser.new
    end

    def converter
      @converter ||= CONVERTERS[options.format.to_sym] || DEFAULT_CONVERTER
    end
  end
end
