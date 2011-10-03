require 'nokogiri'
require 'digest/sha1'
require 'ostruct'
require 'tempfile'
require 'gnuplot'
require 'bytes'
require 'json'
require 'ostruct'
require 'bluecloth'

module ActionView
  module Helpers
    module TextHelper
      Markdown = BlueCloth
    end
  end
end
