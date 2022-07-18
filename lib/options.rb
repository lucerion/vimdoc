# frozen_string_literal: true

require 'optparse'

module VimDoc
  class Options
    USAGE_MESSAGE = 'Usage: ./bin/vimdoc [OPTIONS] FILE'

    FORMATS = {
      markdown: 'markdown',
      json: 'json',
      yaml: 'yaml'
    }.freeze
    DEFAULT_FORMAT = FORMATS[:json].freeze

    attr_reader :format

    def initialize
      @input_file = nil
      @format = DEFAULT_FORMAT
    end

    def parse!(args)
      args_without_options = args.dup
      build_parser.parse!(args_without_options)
      @input_file = args_without_options.first
    end

    def help
      parse!(['--help'])
    end

    def input_file
      @input_file && File.expand_path(@input_file)
    end

    def validate!
      raise "File '#{input_file}' not found" unless File.exist?(input_file)
      raise "Format '#{format}' is not valid. Possible formats: #{formats}." unless FORMATS.values.include?(format)
    end

    private

    def build_parser
      format_option
      help_option
    end

    def format_option
      option_parser.on('-f',
                       '--format FORMAT',
                       "content format. Possible values: #{formats}. Default: #{DEFAULT_FORMAT}") do |format|
        @format = format
      end
    end

    def help_option
      option_parser.on_tail('--help', 'display a usage message') do
        puts option_parser
        exit
      end
    end

    def option_parser
      @option_parser ||= ::OptionParser.new(USAGE_MESSAGE)
    end

    def formats
      @formats ||= FORMATS.values.join(', ')
    end
  end
end
