module MojoDNA
  module Searchable
    module RemoteSearchable
      @@searcher = nil
  
      def self.searcher
        if @@searcher.nil?
          DRb.start_service
          @@searcher = DRbObject.new(nil, 'druby://localhost:7778')
        end
        @@searcher
      end
  
      # Searchable class methods (remote implementation)
      module ClassMethods
        # Use the DRbSearchService to query for results
        def search(query, options = {} )
          MojoDNA::Searchable::RemoteSearchable::searcher.search( self.inspect.to_s, query, options )
        end
    
        def optimize_index
          logger.debug("optimize_index not implemented")
        end

        # index all instances of this model in batch mode
        # returns the job key, which can be used to query for status
        def index_all
          puts "Indexing everything"
          MojoDNA::Searchable::RemoteSearchable::searcher.push( [:index_all, self.inspect.to_s, nil] )
        end
      end

      # Searchable instance methods (remote implementation)
      module InstanceMethods
        def add_to_index
          # queue this object for indexing
          puts "Adding to index"
          MojoDNA::Searchable::RemoteSearchable::searcher.push( [:add, self.class.to_s, self.id] )
          true
        end

        def remove_from_index
          # queue this object for removal
          puts "Adding to index"
          MojoDNA::Searchable::RemoteSearchable::searcher.push( [:remove, self.class.to_s, self.id] )
          true
        end
      end
    end
  end
end