#!/usr/bin/ruby

module XmlHelper
  class SaxParser
    attr_accessor :thing

    def initialize(xml)
      @parser = XML::SaxParser.new
      @parser.string = xml
      @parser.callbacks = Handler.new
    end

    def to_s
      @thing.to_s
    end

    def parse
      begin
        @parser.parse
        @thing = @parser.callbacks.thing
        return true
      rescue
        return false
      end
    end
  end

  class Node
    attr_accessor :parent, :element, :children, :attrs, :content

    #debugging
    def to_s(indent = "")
      string = indent + element + "\n" 
      attrses = []
      (@attrs || {}).each { |k, v|
        attrses << [k, v].join("=")
      }
      attrses.each {|attr|
        string += " " + indent + attr + "\n"
      }
      if @content && @content != nil && @content != "" && !@content.match("^[ ]+$")
        string += " " + indent + @content + "\n"
      end
      childs = []
      for child in @children
        string += child.to_s(indent + " ")
      end
      return string
    end

    def initialize
      @children = []
    end
  end

  class Handler
    attr_accessor :elements, :thing

    def add_node(element, attrs)
      oldnode = @thing
      @thing = Node.new
      @thing.element = element
      @thing.parent = oldnode
      @thing.attrs = attrs
      oldnode.children << @thing
    end

    def on_characters(characters = '')
      @thing.content = characters
    end

    def remove_node(element)
      #debugging
      #    (puts "OOPS: #{element}"; return) if @thing == nil
      #    (puts "OOPS: #{element} #{@thing.element}"; return) if @thing.element != element
      raise if @thing == nil || @thing.element != element
      oldnode = @thing
      @thing = oldnode.parent
    end

    def initialize
      @elements = []
      @special = Node.new
      @special.element = "I'm sooooo special!!!!"
      @thing = @special
    end

    def on_start_element(element, attributes)
      add_node(element, attributes)
    end

    def on_end_element(element)
      remove_node(element)
    end

    def on_end_document
      temp = @thing
      remove_node("I'm sooooo special!!!!")
      @thing = temp.children[0]
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

  def my_node
    @my_node
  end

  def load_xml(xml)
    require 'xml/libxml'

    @sax = SaxParser.new(xml)
    if @sax.parse
      @my_node = @sax.thing
      return @sax
    else
      puts "failed"
      exit 1
    end
  end
end

##########################
#test program starts here
##########################

include XmlHelper

if ARGV[0] == nil
  $stderr.puts "Usage: sax.rb file.xml"
  exit 1
end

f = open(ARGV[0], 'r')
load_xml(f.read)
f.close

puts my_node.to_s
