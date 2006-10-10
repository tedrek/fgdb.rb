module MojoDNA
  module Searchable
    class SearchableField
      def initialize
        @aliases = []
        @boost = 1.0
        @indexed = true
        @stored = false
        @tokenized = true
        @sortable = false
        @include = {}
      end
      
      def attr_name(name = nil)
        @attr_name = name.to_sym if name
        @indexed_name = @attr_name unless @indexed_name
        @attr_name
      end
      
      alias :attr_name= :attr_name
      
      # is method_name already listed in instance_methods with a signature lacking an arg, accept it
      # self.instance_methods
      
      def indexed_name(name = nil)
        @indexed_name = name.to_sym if name
        @indexed_name
      end
      
      alias :indexed_name= :indexed_name
      
      def aliases(a = nil)
        @aliases = a if a
        @aliases
      end
      
      alias :aliases= :aliases

      def boost(b = nil)
        @boost = b if b
        @boost
      end
      
      alias :boost= :boost

      def indexed(i = nil)
        @indexed = i unless i.nil?
        @indexed
      end
      
      alias :indexed= :indexed
      alias :indexed? :indexed

      def stored(s = nil)
        @stored = s unless s.nil?
        @stored
      end
      
      alias :stored= :stored
      alias :stored? :stored
      
      def tokenized(t = nil)
        @tokenized = t unless t.nil?
        @tokenized
      end
      
      alias :tokenized= :tokenized
      alias :tokenized? :tokenized

      def sortable(s = nil)
        @sortable = s unless s.nil?
        @sortable
      end
      
      alias :sortable= :sortable
      alias :sortable? :sortable

      def include(name = nil, opts = {})
        if name
          field = SearchableField.new
          field.attr_name = name.to_sym
          field.indexed_name = opts[:indexed_name].to_sym if opts[:indexed_name]
          field.aliases = opts[:aliases] if opts[:aliases]
          field.boost = opts[:boost] if opts[:boost]
          field.indexed = opts[:indexed] unless opts[:indexed].nil?
          field.stored = opts[:stored] unless opts[:stored].nil?
          field.tokenized = opts[:tokenized] unless opts[:tokenized].nil?
          field.sortable = opts[:sortable] unless opts[:sortable].nil?

          # override parameters if a block was provided
          yield field if block_given?

          @include[name.to_sym] = field
        end
        @include
      end
    end
  end
end
