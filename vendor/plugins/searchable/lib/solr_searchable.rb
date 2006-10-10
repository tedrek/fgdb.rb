require("solr/indexer")
require("solr/searcher")

module MojoDNA
  module Searchable
    module SolrSearchable
      # Searchable class methods (SOLR implementation)
      module ClassMethods
        def search(query, options = {} )
          ::MojoDNA::Searchable::Solr::Searcher::search( self.inspect.constantize, query, options )
        end
    
        def optimize_index
          MojoDNA::Searchable::Solr::Indexer.optimize_index
        end

        # index all instances of this model in batch mode
        # returns the job key, which can be used to query for status
        def index_all
          logger.debug "Indexing everything"
          MojoDNA::Searchable::Solr::Indexer.index_all( self )
        end
      end

      # Searchable instance methods (SOLR implementation)
      module InstanceMethods
        def add_to_index
          # queue this object for indexing
          logger.debug "Adding to index"
          MojoDNA::Searchable::Solr::Indexer.index( self )
          true
        end

        def remove_from_index
          # queue this object for removal
          logger.debug "Removing from index"
          MojoDNA::Searchable::Solr::Indexer.delete_from_index( self )
          true
        end
      end
    end
  end
end