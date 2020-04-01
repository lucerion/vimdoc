# frozen_string_literal: true

require_relative './parser'

module VimDoc
  class CLI
    USAGE = <<~USAGE
      Usage: ./bin/vimdoc FILE...
    USAGE

    def self.run(args)
      new.run(args)
    end

    def run(args)
      if args.empty?
        puts USAGE
        exit
      end

      args.each(&method(:parse_and_print))
    end

    private

    def parse_and_print(file)
      pp Parser.parse(file)
    end
  end
end
