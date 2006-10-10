#!/usr/bin/env ruby

require("drb")
require File.dirname(__FILE__) + '/../../../../config/boot'
require "#{RAILS_ROOT}/config/environment"

# this must be declared before any of the models are loaded, otherwise they
# will be set up to be indexed remotely
MojoDNA::Searchable::local

module MojoDNA::Searchable::DRbIndexer
  attr_accessor :indexes_to_optimize
  
  def initialize
    DRb.start_service
    @queue = DRbObject.new(nil, 'druby://localhost:7778')
    @indexes_to_optimize = []
    puts "DRbIndexer initialized; waiting for requests..."
  end
  
  def run
    while true
      begin
        info = @queue.next
        if info.nil?
          # housekeeping
          while path = indexes_to_optimize.shift do
            puts "Optimizing #{path}"
            ::MojoDNA::Searchable::Indexer::optimize_index(path)
          end
          sleep 5
        else
          action, klass, id = info
          klass = klass.constantize
          case action
          when :add
            puts "Indexing #{klass}##{id}"
            ::MojoDNA::Searchable::Indexer::index( klass.find(id) )
            indexes_to_optimize << klass.index_path unless indexes_to_optimize.include?(klass.index_path)
          when :remove
            puts "Removing #{klass}##{id}"
            ::MojoDNA::Searchable::Indexer::delete_from_index( klass.find(id) )
            indexes_to_optimize << klass.index_path unless indexes_to_optimize.include?(klass.index_path)
          when :index_all
            puts "Indexing everything"
            ::MojoDNA::Searchable::Indexer::index_all( klass )
          end
        end
      rescue DRb::DRbConnError
        puts "Unable to connect to DRb; waiting 60 seconds to retry"
        sleep 60
      end
    end
  end
end

if __FILE__ == $0
  indexer = MojoDNA::Searchable::DRbIndexer.new
  indexer.run
end