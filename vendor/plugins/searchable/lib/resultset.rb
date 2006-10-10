module MojoDNA
  module Searchable
    # models a scrollable resultset
    module ResultSet
      attr_accessor :num_results, :offset
  
      def num_results
        @num_results || size
      end
    end
    
    # applied to objects that can have a score (a result, for example)
    module Scorable
      attr_accessor :score
    end
  end
end

class Array
  include MojoDNA::Searchable::ResultSet
  # when objects are not loaded, tuples containing the type and id are returned
  # instead, so they need to be scorable
  include MojoDNA::Searchable::Scorable
end

# add a score attribute to fixnum so we can return scores with ids
class Fixnum
  include MojoDNA::Searchable::Scorable
end
