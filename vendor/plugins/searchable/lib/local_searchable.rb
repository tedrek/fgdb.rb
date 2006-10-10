require("ferret/indexer")
require("ferret/searcher")

# Searchable class methods (local implementation)
module MojoDNA::Searchable::LocalSearchable
  module ClassMethods
    # if :load is set to false, an array of model ids will be returned rather than an array of objects
    # set :offset to the initial offset in the resultset
    # set :limit to the number of desired results returned from the resultset
    # Ferret provides these, but does not provide metadata about the total number of results
    # set :sort_by to the fields that the results should be sorted by (in order).  Alternately, pass a Ferret::Search::Sort
    # set :reverse to true if you'd like the results in reverse order (only if a sorted field is provided)
    # TODO support paginator (pagination_helper.rb:find_collection_for_pagination would need to be overwritten to not only use find_all)
    #   conditions (option), order_by (option), paginator
    #     paginator.items_per_page paginator.current.offset
    # TODO returned stored fields as part of ResultSet
    # set :default_fields to be an array of fields that should be used as default fields
    def search(query, options = {} )
      ::MojoDNA::Searchable::Ferret::Searcher::search( self.inspect.constantize, query, options )
    end

    def optimize_index
      ::MojoDNA::Searchable::Ferret::Indexer::optimize_index( index_path )
    end

    # index all instances of this model in batch mode
    def index_all
      ::MojoDNA::Searchable::Ferret::Indexer::index_all( self )
    end
  end

  # Searchable instance methods (local implementation)
  module InstanceMethods
    def add_to_index
      ::MojoDNA::Searchable::Ferret::Indexer::index( self )
      true
    end

    def remove_from_index
      ::MojoDNA::Searchable::Ferret::Indexer::delete_from_index( self )
      true
    end
  end
end