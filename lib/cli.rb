# frozen_string_literal: true

require 'optparse'

require_relative './parser'
require_relative './converters/json_converter'

module VimDoc
  class CLI
    USAGE = 'Converts vim help files to the different formats (markdown, json, yaml, ...)'
    DEFAULT_CONVERTER = Converters::JSONConverter

    def self.run(args)
      new.run(args)
    end

    def run(args)
      if args.empty?
        options_parser.parse(['--help'])
        exit
      end

      options_parser.parse(args)

      doc_file = doc_file(args)
      content = content(doc_file)
      @output_file ? File.write(@output_file, content) : puts(content)
    end

    private

    def options_parser
      OptionParser.new(USAGE) do |option|
        option.on('-o', '--output PATH', 'output to a file') do |path|
          @output_file = File.expand_path(path)
        end
        option.on_tail('--help', 'display a usage message') do
          puts option
          exit
        end
      end
    end

    def doc_file(args)
      return args.first unless @output_file

      args.reject { |arg| arg.start_with?('-') || arg == @output_file }.first
    end

    def content(doc_file)
      tree = Parser.parse(doc_file)
      DEFAULT_CONVERTER.convert(tree)
    end
  end
end
