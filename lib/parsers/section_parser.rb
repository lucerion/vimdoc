# frozen_string_literal: true

module VimDoc
  module Parsers
    class SectionParser < BaseParser
      TAG_LINE = /.*\*.*\*$/.freeze
      CODE_BLOCK_START = '>'.freeze
      CODE_BLOCK_END = '<'.freeze

      def parse(lines)
        header = split_line_by_whitespaces(lines.first)

        {}.tap do |node|
          node[:title] = header.first
          node[:tag] = delete_tag_signs(header.last)
          node[:content] = content(lines[1..-1])
        end
      end

      private

      def content(lines)
        code_block = false
        code_block_lines = []

        lines.each_with_object([]) do |line, content|
          next if TAG_LINE.match(line)

          content_line = delete_whitespaces(line)

          if content_line == CODE_BLOCK_START
            code_block = true
            next # skip code block start line
          end

          if code_block == true && content_line == CODE_BLOCK_END
            content << code_block_lines
            code_block_lines = []
            code_block = false
            next # skip code block end line
          end

          (code_block ? code_block_lines : content) << content_line
        end
      end
    end
  end
end
