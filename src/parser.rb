# frozen_string_literal: true

SECTIONS_SEPARATOR = '='
TAG_WRAPPER = '*'
TAG_LINK_WRAPPER = '|'
TABLE_OF_CONTENTS_TITLE = 'CONTENTS'
TAG_LINE = /.*\*.*\*$/.freeze

def empty_line?(line)
  line.strip.empty?
end

def tag_line?(line)
  TAG_LINE.match(line)
end

def section_separator?(line)
  line.start_with?(SECTIONS_SEPARATOR)
end

def table_of_contents?(line)
  line.start_with?(TABLE_OF_CONTENTS_TITLE)
end

def separate_line(line)
  line.split(/\s/).delete_if(&method(:empty_line?))
end

def parse_help_header(file_lines)
  header = separate_line(file_lines.first)
  title = header.first.tr(TAG_WRAPPER, '')
  description = header[1..-1].join(' ')

  { title: title, description: description }
end

def parse_table_of_contents_line(line)
  title, link = separate_line(line)
  link_text = link.tr(TAG_LINK_WRAPPER, '')

  {}.tap { |content_line| content_line[link_text] = title }
end

def parse_section_lines(lines)
  header = separate_line(lines.first)
  tag = header.last.tr(TAG_WRAPPER, '')

  content = lines[1..-1].each_with_object([]) do |line, content_lines|
    content_line = line.gsub(/\s+/, ' ').strip
    content_lines << content_line unless tag_line?(content_line)
  end

  {}.tap do |section|
    section[tag] = {
      title: header.first,
      content: content
    }
  end
end

def parse_sections(file_lines)
  initial_tree = {
    sections: {},
    table_of_contents: {}
  }

  section = false
  table_of_contents = false
  section_lines = []

  sections_lines = file_lines[1..-1].delete_if(&method(:empty_line?))
  sections_lines.each_with_object(initial_tree) do |line, tree|
    section_separator = section_separator?(line)

    section_start = section_separator && !section
    if section_start
      section = !section
      next
    end

    section_end = section_separator && section
    if section_end
      tree[:sections].merge!(parse_section_lines(section_lines)) unless table_of_contents

      section_lines = []
      table_of_contents = false

      next
    end

    next unless section

    if table_of_contents?(line)
      table_of_contents = true
      next
    end

    tree[:table_of_contents].merge!(parse_table_of_contents_line(line)) if table_of_contents

    section_lines << line
  end
end

def parse(file)
  file_lines = File.readlines(file)
  help_header = parse_help_header(file_lines)
  sections = parse_sections(file_lines)

  {}.tap do |tree|
    tree.merge!(help_header)
    tree.merge!(sections)
  end
end
