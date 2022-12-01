# frozen_string_literal: true

module VimDoc
  class Parser
    LINE_SEPARATOR = /[[:space:]]{2,}/.freeze

    LINE_TYPE_MATCHERS = {
      empty_line: /^[[:space:]]*$/,
      separator: /^={3,}$/,
      header: /^[A-Z0-9\ ]*$/,
      anchor: /^\*.*\*$/,
      link: /^\|.*\|$/,
      code_start: /^\s*>\s*/,
      code_end: /^\s*<\s*/
    }.freeze

    attr_reader :tree

    def initialize
      @tree = []
    end

    def parse(file_path)
      block = []
      File.readlines(file_path).each do |line|
        block << { origin: line, parsed: parse_line(line) }

        next unless block_end?(line)

        @tree << block
        block = []
      end
    end

    private

    def block_end?(line)
      !!(line =~ LINE_TYPE_MATCHERS[:separator])
    end

    def parse_line(origin_line)
      origin_line.split(LINE_SEPARATOR)
                 .delete_if(&:empty?)
                 .map { |line| { text: line.strip, type: line_type(line) } }
    end

    def line_type(line)
      case line
      when LINE_TYPE_MATCHERS[:empty_line]
        :empty_line
      when LINE_TYPE_MATCHERS[:separator]
        :separator
      when LINE_TYPE_MATCHERS[:header]
        :header
      when LINE_TYPE_MATCHERS[:anchor]
        :anchor
      when LINE_TYPE_MATCHERS[:link]
        :link
      when LINE_TYPE_MATCHERS[:code_start]
        :code_start
      when LINE_TYPE_MATCHERS[:code_end]
        :code_end
      else
        :text
      end
    end
  end
end
