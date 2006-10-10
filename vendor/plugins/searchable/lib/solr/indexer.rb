require("builder")
require("net/http")

# Searchable backend that uses SOLR for index management.
module MojoDNA::Searchable::Solr
  # An indexer using SOLR's web service
  class Indexer
    def self.solr_host(host = nil)
      @@solr_host = host if host
      @@solr_host ||= ::Searchable::Info[:configuration]['solr_index_host']
    end
    
    def self.solr_port(port = nil)
      @@solr_port = port if port
      @@solr_port ||= ::Searchable::Info[:configuration]['solr_index_port']
    end
    
    # set the default analyzer for Searchable
    def self.default_analyzer(analyzer = nil)
      RAILS_DEFAULT_LOGGER.debug("default_analyzer not supported by SOLR backend")
    end
    
    # set the default index path for Searchable
    def self.default_index_path(path = nil)
      RAILS_DEFAULT_LOGGER.debug("default_index_path not supported by SOLR backend")
    end
    
    def self.optimize_index
      # trigger a SOLR optimize
      do_http do |http|
        http.post('/solr/update', '<optimize waitFlush="false" waitSearcher="false"/>')
      end
    end
    
    def self.delete_from_index( object )
      field = "_type-id"
      key = "#{object.class.to_s}-#{object.send(:id)}"

      do_http do |http|
         http.post('/solr/update', "<delete><id>#{key}</id></delete>")
         http.post('/solr/update', '<commit waitFlush="false" waitSearcher="false"/>')
       end
    rescue Object => e
      object.logger.warn "Problem removing #{object.class.to_s}-#{object.send(:id)} from index with SOLR on #{solr_host}:#{solr_port}: #{e}"
      false
    end
    
    def self.index( object )
      # create an xml doc representation and send to SOLR
      doc = ""
      xml = Builder::XmlMarkup.new(:target => doc, :indent => 2)
      xml.add do
        xml << create_document( object )
      end

      # send document to SOLR
      do_http do |http|
        http.post('/solr/update', doc)
        http.post('/solr/update', '<commit waitFlush="false" waitSearcher="false"/>')
      end
    rescue Object => e
      object.logger.warn "Problem indexing #{object.class.to_s}-#{object.send(:id)} with SOLR on #{solr_host}:#{solr_port}: #{e}"
      false
    end
    
    def self.index_all(klass)
      # TODO attempt to rescue http requests from:
      # these may be caused by SOLR not having enough memory allocated
      # /usr/lib/ruby/1.8/timeout.rb:54:in `rbuf_fill': execution expired (Timeout::Error)
      #         from /usr/lib/ruby/1.8/timeout.rb:56:in `timeout'
      #         from /usr/lib/ruby/1.8/timeout.rb:76:in `timeout'
      #         from /usr/lib/ruby/1.8/net/protocol.rb:132:in `rbuf_fill'
      #         from /usr/lib/ruby/1.8/net/protocol.rb:104:in `read_all'
      #         from /usr/lib/ruby/1.8/net/http.rb:2188:in `read_body_0'
      #         from /usr/lib/ruby/1.8/net/http.rb:2141:in `read_body'
      #         from /usr/lib/ruby/1.8/net/http.rb:841:in `post'
      #         from /usr/lib/ruby/1.8/net/http.rb:1049:in `request'
      #          ... 7 levels...
      #         from ./vendor/plugins/acts_as_searchable/lib/solr_searchable.rb:21:in `index_all'
      #         from (irb):1:in `irb_binding'
      #         from /usr/lib/ruby/1.8/irb/workspace.rb:52:in `irb_binding'
      #         from /usr/lib/ruby/1.8/irb/workspace.rb:52
      
      
      index_created = Time.now
      
      offset = 0
      quanta = 500
      include_ary = []
      logger = klass.logger
      
      begin
        include_ary = klass.searchable_fields.values.collect{|f| f.attr_name unless f.include.empty? or klass.reflections[f.attr_name.to_sym].nil?}.reject{|v| v.nil?}
      rescue NoMethodError
        # Rails 1.0 doesn't have klass.reflections, so assume everything is an association and not a method
        include_ary = klass.searchable_fields.values.collect{|f| f.attr_name unless f.include.empty?}.reject{|v| v.nil?}
      end
      
      # since we're updating all records, delete everything first
      do_http do |http|
        http.post('/solr/update', "<delete><query>_type:#{klass.to_s}</query></delete>")
        http.post('/solr/update', '<commit waitFlush="false" waitSearcher="false"/>')
      end
      
      # load the first set of objects
      while objects = klass.find(:all, :conditions => ["#{klass.table_name}.id > ?", offset], :limit => quanta, :include => include_ary) do
        break if objects.empty?

        # create an XML doc containing all docs in this batch
        doc = ""
        xml = Builder::XmlMarkup.new(:target => doc, :indent => 2)
        xml.add do
          objects.each do |obj|
            xml << create_document( obj )
          end
        end
        
        # send document to SOLR
        do_http do |http|
          http.post('/solr/update', doc)
          http.post('/solr/update', '<commit waitFlush="false" waitSearcher="false"/>')
        end

        logger.debug "#{Time.now}: Adding documents to index" if logger.debug?
        logger.debug "#{Time.now}: (#{offset})" if logger.debug?
        
        # set the offset for the next batch
        offset = objects.last.id
        
        logger.debug "#{Time.now}: Querying for objects" if logger.debug?
        objects = klass.find(:all, :conditions => ["#{klass.table_name}.id > ?", offset], :limit => quanta, :include => include_ary)
      end


      # index stuff that was updated since index_created (if we can figure out what it is)
      if klass.column_names.include?("updated_at")
        while objects = klass.find(:all, :conditions => ["#{klass.table_name}.updated_at > ?", index_created], :include => include_ary) do
          break if objects.empty?
          
          # update index_created for the next run
          index_created = Time.now
          
          # TODO create an XML doc containing all docs in this batch
          doc = ""
          xml = Builder::XmlMarkup.new(:target => doc, :indent => 2)
          xml.add do
            objects.each do |obj|
              xml << create_document( obj )
            end
          end
          
          # send document to SOLR
          do_http do |http|
            http.post('/solr/update', doc)
            http.post('/solr/update', '<commit waitFlush="false" waitSearcher="false"/>')
          end
        end
      end

      # optimize the index
      do_http do |http|
        http.post('/solr/update', '<optimize waitFlush="false" waitSearcher="false"/>')
      end
      
      logger.debug "#{Time.now}: Done." if logger.debug?
    end
    
    def self.create_document(object)
      id = object.send(:id).to_s
      klass = object.class.to_s
      
      doc = ""
      xml = Builder::XmlMarkup.new(:target => doc, :indent => 2)
      xml.doc do
        
        if object.class.searchable_fields or object.respond_to?(:to_doc)
          xml.field(id, :name => "_id" )
          xml.field(klass, :name => "_type" )
          xml.field("#{klass}-#{id}", :name => "_type-id")
        
          object.class.searchable_fields.values.each do |field|
            make_fields( xml, object.send( field.attr_name ), field )
          end
        
          # use to_search_fields to generate xml fields properly
          # check to make sure this is a StringIO
          more_fields = object.to_search_fields if object.respond_to?(:to_search_fields)
          more_fields.each do |f|
            xml.field(f[:value], :name => f[:name], :boost => f[:boost])
          end if more_fields
        else
          # no columns were specified, so default to all (excluding relations)
          object.class.content_columns.collect{|c| c.name}.each do |field|
            xml.field(object.send(field), :name => field)
          end
        end
        
      end
      # object.logger.debug "Indexing SOLR doc: \n#{doc}" if object.logger.debug?
      
      return doc
    end
    
    def self.make_fields(xml, value, field, stack = [] )
      if value.is_a?(Array)
        value.each do |v|
          make_fields( xml, v, field, stack )
        end
        return xml
      end
      
      # create basic field
      xml.field(value, :name => [stack + [field.indexed_name]].join("."), :boost => field.boost ) if field.include.empty? and value
      
      # create all appropriate subfields
      field.include.values.each do |subfield|
        make_fields( xml, value.send(subfield.attr_name), subfield, [stack + [field.indexed_name]] )
      end
      
      # create aliases
      field.aliases.each do |a|
        xml.field(value, :name => [stack + [a]].join("."), :boost => field.boost ) if field.include.empty? and value

        # create subfields for aliases
        field.include.values.each do |subfield|
          make_fields( xml, value, subfield, [stack + [a]] )
        end
      end
      
      # create sortable field
      xml.field(value, :name => "_sort-#{field.indexed_name}") if field.sortable?

      xml
    end
    
    private
      def self.do_http
        Net::HTTP.start(solr_host, solr_port) do |http|
          yield http
        end
      end
  end
end
