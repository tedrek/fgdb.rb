#!/usr/bin/ruby

require 'xml/libxml'

#example from http://www.lucaguidi.com/2008/1/30/ruby-xml-parsing-with-sax

class SaxParser
  def initialize(xml)
    @parser = XML::SaxParser.new
    @parser.string = xml
    @parser.callbacks = Handler.new
  end

  def parse
    @parser.parse
    @parser.callbacks.elements
  end
end

class Handler
  attr_accessor :elements

  def initialize
    @elements = []
  end

  # The complete chain is:
  #   on_start_document
  #   on_processing_instruction(instruction, arguments)
  #   on_start_element(element, attributes)
  #   on_characters(characters = '')
  #   on_end_element(element)
  #   on_end_document
  def method_missing(method_name, *attributes, &block)
  end
end

if ARGV[0] == nil
  $stderr.puts "Usage: sax.rb file.xml"
  exit 1
end

#xml = open(ARGV[0], 'r').collect { |l| l }.join
xml = (f = open(ARGV[0], 'r')).read
f.close
puts SaxParser.new(xml).parse
