# frozen_string_literal: true

require 'optparse'

require_relative './parser'
require_relative './converters'

module VimDoc
  class CLI
    USAGE_MESSAGE = 'Converts vim help files to the different formats (markdown, json, ...)'

    CONVERTERS = {
      json: Converters::JSONConverter,
      yaml: Converters::YAMLConverter
    }.freeze
    DEFAULT_CONVERTER = CONVERTERS[:json].freeze

    FORMATS = {
      json: 'json',
      yaml: 'yaml'
    }.freeze
    DEFAULT_FORMAT = FORMATS[:json].freeze

    def initialize(args)
      @args = args
      @format = DEFAULT_FORMAT
      @output_file = nil
    end

    def run
      if args.empty?
        options_parser.parse(['--help'])
        exit
      end

      options_parser.parse(args)
      validate_options!

      output_file ? File.write(File.expand_path(output_file), content) : puts(content)
    end

    private

    attr_reader :args, :format, :output_file

    def options_parser
      OptionParser.new(USAGE_MESSAGE) do |option|
        option.on('-o', '--output PATH', 'output to a file') do |file|
          @output_file = file
        end
        option.on('-f',
          '--format FORMAT', "content format. Possible values: #{formats}, Default: #{DEFAULT_FORMAT}") do |format|
          @format = format
        end
        option.on_tail('--help', 'display a usage message') do
          puts option
          exit
        end
      end
    end

    def validate_options!
      raise "Format '#{format}' is not valid. Possible formats: #{formats}." unless FORMATS.values.include?(format)
    end

    def content
      tree = parser.parse(File.expand_path(args.first))
      converter.convert(tree)
    end

    def parser
      @parser ||= Parser.new
    end

    def converter
      @converter ||= CONVERTERS[format.to_sym] || DEFAULT_CONVERTER
    end

    def formats
      @formats ||= FORMATS.values.join(', ')
    end
  end
end
