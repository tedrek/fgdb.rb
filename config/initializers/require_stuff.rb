require 'nokogiri'
require 'digest/sha1'
require 'ostruct'
require 'tempfile'
require 'gnuplot'
require 'bytes'
require 'json'
require 'ostruct'
require 'bluecloth'
require RAILS_ROOT + '/lib/fix_stupid_rails.rb'
require RAILS_ROOT + '/lib/model_modifications.rb'
require RAILS_ROOT + '/lib/ordered_hash.rb'
require_dependency RAILS_ROOT + '/lib/soap.rb'

module ActionView
  module Helpers
    module TextHelper
      Markdown = BlueCloth
    end
  end
end
