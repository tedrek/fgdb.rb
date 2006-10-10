module MojoDNA
  module Searchable
    module Ferret
    end
  end
end

require("resultset")
require("searchable_field")

# Example:
#  index_path "/path/to/index"
#  default_analyzer Analysis::StandardAnalyzer
# 
# Index the whole model.  (Presence of the to_doc method triggers indexing.)
#  def to_doc(doc)
#    doc << MojoDNA::Searchable::Indexer::create_field("make", make)
#    doc << MojoDNA::Searchable::Indexer::create_field("model", model)
#    doc << MojoDNA::Searchable::Indexer::create_field("vintage", year)
#    doc << MojoDNA::Searchable::Indexer::create_field("owner", "seth")
#    doc
#  end
# 
# Index specific attributes
#  index_attr :name # uses defaults
#  index_attr :login do |attr|
#    attr.indexed_name "login"
#    attr.aliases ["username", "handle"]
#    attr.boost 1.0
#    attr.indexed true
#    attr.stored false
#    attr.tokenized true
#    attr.sortable false
#    attr.include :something do |something|
#      something.indexed_name "somesuch"
#    end
#  end
module Searchable
  # vars intended for the model
  
  # add a score attribute
  attr_accessor :score

  MAX_RESULTS = 1000 unless defined?( MAX_RESULTS )
  @@backend = :local

  # Local vars
  Info = {} unless defined?(Info)
  
  def self.backend(backend, options = {})
    # TODO implement a scheme wherein backends can register themselves, perhaps as a class-level method that fills in some class attributes.
    @@backend = backend
  end
  
  # Force searchable to run in local mode (must be done before being included in a model)
  def self.local
    @@backend = :local
  end
  
  # Force searchable to run in remote mode against the DRb service (must be done before being included in a model)
  def self.remote
    @@backend = :remote
  end
  
  # Initialization of a class that includes Searchable
  def self.included(mod)
    if mod.ancestors.include?(ActiveRecord::Base)
      mod.extend(ClassMethods)
      Info[mod.name.to_sym] ||= {}
      
      # load the appropriate searchable module into this module
      if @@backend == :remote || @@backend == :local
        require("ferret/indexer")
        
        Info[mod.name.to_sym][:analyzer] = ::MojoDNA::Searchable::Ferret::Indexer::default_analyzer
        Info[mod.name.to_sym][:index_path] = ::MojoDNA::Searchable::Ferret::Indexer::default_index_path
        
        if @@backend == :remote
          require("remote_searchable")
          mod.extend(::MojoDNA::Searchable::RemoteSearchable::ClassMethods)
          mod.instance_eval do
            include ::MojoDNA::Searchable::RemoteSearchable::InstanceMethods
          end
        elsif @@backend == :local
          require("local_searchable")
          mod.extend(::MojoDNA::Searchable::LocalSearchable::ClassMethods)
          mod.instance_eval do
            include ::MojoDNA::Searchable::LocalSearchable::InstanceMethods
          end
        end
      elsif @@backend == :solr
        require("solr_searchable")
        
        Info[:configuration] ||= YAML::load(ERB.new(IO.read(File.join(::RAILS_ROOT, 'config', 'searchable.yml'))).result)[::RAILS_ENV] || {}
        
        mod.extend(::MojoDNA::Searchable::SolrSearchable::ClassMethods)
        mod.instance_eval do
          include ::MojoDNA::Searchable::SolrSearchable::InstanceMethods
        end
      end
    
      # add callbacks for index insertion and deletion
      mod.after_destroy :remove_from_index
      mod.after_save :add_to_index
    end
  end
  
  # Class methods to be mixed in to a class including Searchable
  module ClassMethods
    def searchable_configuration
      Info[:configuration]
    end
    
    # Set the default analyzer to use when analyzing fields.
    def default_analyzer(analyzer = nil)
      Info[searchable_classname(self)][:analyzer] = analyzer if analyzer
      Info[searchable_classname(self)][:analyzer]
    end
  
    # Index an attribute.
    def index_attr(attr_name, opts = {})
      Info[searchable_classname(self)][:fields] ||= {}
      field = ::MojoDNA::Searchable::SearchableField.new
      field.attr_name = attr_name.to_sym
      field.indexed_name = opts[:indexed_name].to_sym if opts[:indexed_name]
      field.aliases = opts[:aliases] if opts[:aliases]
      field.boost = opts[:boost] if opts[:boost]
      field.indexed = opts[:indexed] unless opts[:indexed].nil?
      field.stored = opts[:stored] unless opts[:stored].nil?
      field.tokenized = opts[:tokenized] unless opts[:tokenized].nil?
      field.sortable = opts[:sortable] unless opts[:sortable].nil?

      # override parameters if a block was provided
      yield field if block_given?
    
      Info[searchable_classname(self)][:fields][attr_name] = field
    
      field
    end
  
    # Set the index path for the class corresponding to this index.
    def index_path(index_path = nil)
      Info[searchable_classname(self)][:index_path] = index_path if index_path
      Info[searchable_classname(self)][:index_path]
    end
  
    # An array of all of the SearchableFields present for this class.
    def searchable_fields
      Info[searchable_classname(self)][:fields]
    end
  
    # The default collection of fields to use when searching an index.
    def field_names
      fields = []
      if searchable_fields
        searchable_fields.values.each do |f|
          fields += searchable_fieldnames( f )
        end
      end
      fields = column_names unless searchable_fields
      fields
    end
    
    def count_search(query, options = {})
      (options ||= {}).update({:limit => 0, :offset => 0, :load => false})
      search( query, options ).num_results
    end
    
    def paginate_search(query, options = {})
      limit = options[:limit] = Integer(options[:per_page] || options[:limit] || 10)
      return [ ::ActionController::Pagination::Paginator.new(nil, 0, limit, 1), [] ] if query.blank?
    
      page_number = Integer(options[:page] || 1)
      options[:offset] = (limit * (page_number - 1))
    
      results = search(query, options)
      page = ActionController::Pagination::Paginator.new(nil, results.num_results, limit, page_number)
      [ page, results ]
    end
    
    private
      # Figure out the name of the class that included Searchable (which may not be the class being passed in)
      def searchable_classname(klass)
        # climb hierarchy until we find the class that includes Searchable
        # this will return the top-level class if it doesn't, but that shouldn't be a problem
        while Info[klass.name.to_sym].nil?
          break if klass.superclass.nil?
          klass = klass.superclass
        end
        klass.name.to_sym
      end
    
      # A collection of fieldnames present for this class
      def searchable_fieldnames(field, stack = [])
        fieldnames = []
        fieldnames << [stack + [field.indexed_name.to_s]].join(".") if field.include.empty?
        field.include.values.each do |subfield|
          fieldnames += searchable_fieldnames( subfield, stack + [field.indexed_name.to_s] )
        end
        fieldnames
      end
  end
end
