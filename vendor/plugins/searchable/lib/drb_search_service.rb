#!/usr/bin/env ruby

require("drb")
require(File.dirname(__FILE__) + '/../../../../config/boot')
require("#{RAILS_ROOT}/config/environment")

require("ferret/searcher")

module MojoDNA::Searchable
  
  # A DRb-accessible, thread-pooling search service
  #
  # To use:
  #  DRb.start_service
  #  searcher = DRbObject.new(nil, 'druby://localhost:7778')
  #  searcher.search( klass.to_s, query, options )
  class DRbSearchService
    POOL_SIZE = 5
    
    def initialize
      @queue = []
      @mutex = Mutex.new
      
      @executor = PoolingExecutor.new do |handlers|
        POOL_SIZE.times do 
          handlers << MojoDNA::Searchable::Searcher.new
        end
      end
      puts "#{POOL_SIZE} Searchers initialized; waiting for requests..."
    end
    
    # tee up a search query to the pooled Searchers.  Queries will be
    # processed in the order in which they were received.
    def search(klass, query, options = {})
      results = []
      
      # this is slight abuse of PoolingExecutor, treating it only as a pool (DRb handles threading)
      thread = @executor.run do |searcher|
        results = searcher.search( klass.constantize, query, options )
      end
      
      # wait for the search to complete so results will contain results
      thread.join
      
      results
    end
    
    def next
      @mutex.synchronize {
        @queue.shift
      }
    end
    
    def push(val)
      @mutex.synchronize {
        @queue.push(val) unless @queue.include?(val)
      }
    end
    
    def size
      @mutex.synchronize {
        @queue.length
      }
    end
  end
end

if __FILE__ == $0
  begin
    DRb.start_service("druby://:7778", MojoDNA::Searchable::DRbSearchService.new)
    DRb.thread.join
  rescue
    puts "An exception occurred: #{$!}"
    puts $!.backtrace
  end
end
