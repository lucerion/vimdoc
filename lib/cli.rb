# frozen_string_literal: true

require_relative './parser'
require_relative './converters/json_converter'

module VimDoc
  class CLI
    USAGE = <<~USAGE
      Converts vim help files to the different formats (markdown, json, yaml, ...)

      Usage: ./bin/vimdoc FILE...
    USAGE

    DEFAULT_CONVERTER = Converters::JSONConverter

    def self.run(args)
      new.run(args)
    end

    def run(args)
      if args.empty?
        puts USAGE
        exit
      end

      args.each(&method(:print))
    end

    private

    def print(file)
      tree = Parser.parse(file)
      puts DEFAULT_CONVERTER.convert(tree)
    end
  end
end
