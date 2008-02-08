module AjaxScaffold # :nodoc:
  class ScaffoldColumn
    attr_reader :name, :eval, :sort_sql, :label, :class_name, :sanitize

    # Only options[:name] is required. It will infer the eval and sort values
    # based on the given class.
    def initialize(klass, options)
      @name = options[:name]
      @eval = options[:eval].nil? ? "#{Inflector.underscore(klass.to_s)}.#{@name}" : options[:eval]
      @label = options[:label].nil? ? Inflector.titleize(@name) : options[:label]
      @sortable = options[:sortable].nil? ? true : options[:sortable]
      @sort_sql = options[:sort_sql].nil? ? "#{klass.table_name}.#{@name}" : options[:sort_sql] unless !@sortable
      @class_name = options[:class_name].nil? ? "" : options[:class_name]
      @sanitize = options[:sanitize].nil? ? true : options[:sanitize]
    end

    def sanitize?
      @sanitize
    end

    def sortable?
      @sortable
    end

  end

  module Common
    def current_sort(params)
      session[params[:scaffold_id]][:sort]
    end

    def current_sort_direction(params)
      session[params[:scaffold_id]][:sort_direction]
    end

    def current_conditions(options)
      session[@scaffold_id][:conditions]
    end

  end

  module Controller
    include AjaxScaffold::Common

    def clear_flashes
      if request.xhr?
        flash.keys.each do |flash_key|
          flash[flash_key] = nil
        end
      end
    end

    def default_per_page
      25
    end

    def store_or_get_from_session(id_key, value_key)
      session[id_key][value_key] = params[value_key] if !params[value_key].nil?
      params[value_key] ||= session[id_key][value_key]
    end

    def update_params(options)
      @scaffold_id = params[:scaffold_id] ||= options[:default_scaffold_id]
      session[@scaffold_id] ||= {
        :sort => options[:default_sort],
        :sort_direction => options[:default_sort_direction],
        :page => 1
      }

      store_or_get_from_session(@scaffold_id, :sort)
      store_or_get_from_session(@scaffold_id, :sort_direction)
      store_or_get_from_session(@scaffold_id, :page)
    end

  end

  module Helper
    include AjaxScaffold::Common

    def format_column(column_value, sanitize = true)
      if column_empty?(column_value)
        empty_column_text
      elsif column_value.instance_of? Time
        format_time(column_value)
      elsif column_value.instance_of? Date
        format_date(column_value)
      else
        sanitize ? h(column_value.to_s) : column_value.to_s
      end
    end

    # This along with the two aliases below, will wrap all calls to
    # format_column and add commas to any string with a dollar amount
    # sign ($) in it.
    def format_column_with_commas(column_value, sanitize = true)
      if column_value.instance_of? String and column_value.include?('$')
        number_with_delimiter(column_value).to_s
      else
        format_column_without_commas(column_value, sanitize)
      end
    end

    alias_method :format_column_without_commas, :format_column
    alias_method :format_column, :format_column_with_commas

    def format_time(time)
      time.strftime("%m/%d/%Y %I:%M %p")
    end

    def format_date(date)
      date.strftime("%m/%d/%Y")
    end

    def column_empty?(column_value)
      column_value.nil? || (column_value.empty? rescue false)
    end

    def empty_column_text
      "-"
    end

    # Generates a temporary id for creating a new element
    def generate_temporary_id
      (Time.now.to_f*1000).to_i.to_s
    end

    def pagination_ajax_links(paginator, params)
      pagination_links_each(paginator, {}) do |n|
        link_to_remote n,
           { :url => params.merge(:page => n ),
           :loading => "Element.show('#{loading_indicator_id(params.merge(:action => 'pagination'))}');",
           :update => scaffold_content_id(params) },
           { :href => url_for(params.merge(:page => n )) }
      end
    end

    def loading_indicator_tag(options)
      image_tag "indicator.gif", :style => "display:none;", :id => loading_indicator_id(options), :alt => "loading indicator", :class => "loading-indicator"
    end

    # The following are a bunch of helper methods to produce the common scaffold view id's

    def scaffold_content_id(options)
      "#{options[:scaffold_id]}-content"
    end

    def element_row_id(options)
      "#{options[:scaffold_id]}-#{options[:action]}-#{options[:id]}-row"
    end

    def element_cell_id(options)
      "#{options[:scaffold_id]}-#{options[:action]}-#{options[:id]}-cell"
    end

    def element_form_id(options)
      "#{options[:scaffold_id]}-#{options[:action]}-#{options[:id]}-form"
    end

    def loading_indicator_id(options)
      if options[:id].nil?
        "#{options[:scaffold_id]}-#{options[:action]}-loading-indicator"
      else
        "#{options[:scaffold_id]}-#{options[:action]}-#{options[:id]}-loading-indicator"
      end
    end

    def element_messages_id(options)
      "#{options[:scaffold_id]}-#{options[:action]}-#{options[:id]}-messages"
    end
  end

  module Model
    module ClassMethods

    def build_scaffold_columns
      scaffold_columns = Array.new
      content_columns.each do |column|
        scaffold_columns << ScaffoldColumn.new(self, { :name => column.name })
      end
      scaffold_columns
    end

    def build_scaffold_columns_hash
      scaffold_columns_hash = Hash.new
      scaffold_columns.each do |scaffold_column|
        scaffold_columns_hash[scaffold_column.name] = scaffold_column
      end
        scaffold_columns_hash
      end
    end
  end
end

class ActiveRecord::Base
  extend AjaxScaffold::Model::ClassMethods

  @scaffold_columns = nil
  def self.scaffold_columns
    @scaffold_columns ||= build_scaffold_columns
  end

  @scaffold_columns_hash = nil
  def self.scaffold_columns_hash
    @scaffold_columns_hash ||= build_scaffold_columns_hash
  end
end
