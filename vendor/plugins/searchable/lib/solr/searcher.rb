require("open-uri")
require("rexml/document")

module MojoDNA::Searchable::Solr
  class Searcher
    include REXML
    
    def self.solr_host(host = nil)
      @@solr_host = host if host
      @@solr_host ||= ::Searchable::Info[:configuration]['solr_search_host']
    end
    
    def self.solr_port(port = nil)
      @@solr_port = port if port
      @@solr_port ||= ::Searchable::Info[:configuration]['solr_search_port'] || 80
    end
    
    def search(klass, query, options = {})
      ::MojoDNA::Searchable::Solr::Searcher.search(klass, query, options)
    end
    
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
    def self.search(klass, query, options = {})
      options = { :load => true, :offset => 0, :limit => ::Searchable::MAX_RESULTS, :sort_by => nil, :reverse => false, :default_field => nil, :default_fields => [] }.update( options ) if options.is_a?(Hash)

      logger = klass.logger

      query = if query.blank?
        "+_type:#{klass.to_s}"
      else
        "+_type:#{klass.to_s} +(#{query})"
      end

      # TODO cheap QueryParsing

      url = "http://#{solr_host}:#{solr_port}/solr/select/?q=#{ERB::Util.url_encode(query)}&fl=#{ERB::Util.url_encode('_type-id,score')}&version=2.1&start=#{options[:offset]}&rows=#{options[:limit]}&indent=on"
      logger.debug "sending query to #{url}" if logger.debug?
      doc = open(url)
      doc = doc.to_io if doc.respond_to?(:to_io)
      doc = Document.new(doc)
      # logger.debug "received: \n#{doc.to_s}" if logger.debug?
      
      num_results = XPath.match(doc, "/response/result/@numFound").map(&:value).first
      num_results &&= num_results.to_i
      
      results = XPath.match(doc, '/response/result/doc/').map do |n|
        type, id = XPath.first(n, "str[contains(@name,'_type-id')]/text()").value.split("-")
        id = id.to_i
        id.score = XPath.first(n, "float[contains(@name,'score')]/text()").value.to_f
        logger.debug "Found #{type}(#{id}) with score #{id.score}" if logger.debug?
        [ type, id ]
      end
      
      if options[:load]
        # load all results if specified
        
        # handle resultsets with multiple returned types
        klasses = {}
        results.each do |r|
          type, id = r
          type = type.constantize
          klasses[type] ||= []
          klasses[type] << id
        end
      
        # reset the results and load everything
        results = []
        klasses.each do |k, v|
          class_results = k.find( v )
          class_results.each do |r|
            v.each do |id|
              r.id.score = id.score if r.id == id and r.id.respond_to?(:score)
            end
          end
          results += class_results
        end
        
        # re-sort the results by score to intermingle result types
        results.sort! {|x,y| y.id.score <=> x.id.score }
      end
      
      results.num_results = num_results
      results.offset = options[:offset]

      return results
    end
  end
end