# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  class Column
    def initialize(klass, opts)
      raise "bad constructor: needs a name" unless opts.has_key? :name
      @klass = klass
      @opts = opts
    end

    def eval
      @opts[:eval] || "#{Inflector.underscore(@klass)}.#{@opts[:name]}"
    end

    def name
      @opts[:name]
    end

    def class_name
      @klass.to_s
    end

    def sanitize?
      true
    end

    def sortable?
      @opts[:sortable] || false
    end

    def label
      @opts[:label] || Inflector.titleize(@opts[:name])
    end
  end

  def num_columns(context)
    scaffold_columns(context).length + 1
  end

  def contact_searchbox_id(options)
    "#{options[:scaffold_id]}_contact_searchbox"
  end

  def searchbox_display_id(options)
    'searchbox_display_id'
  end

  def contact_search_box
    render :partial => 'contacts/lookup'
  end

  def header_totals_id(options)
    "#{options[:scaffold_id]}_header_totals"
  end

  def anonymize_button_id(options)
    "#{options[:scaffold_id]}_anonymize"
  end

  def content_id(options)
    'content'
  end

  def scaffold_form_tbody_id(options)
    "#{options[:scaffold_id]}_form_tbody"
  end

  # due to prototype suckness, 'extend' may not be used as a choice name.
  def select_visibility(obj_name, method_name, choices = {})
    #:TODO: scrub this first
    obj = eval( "@#{obj_name}" )

    js_observe_fuct = 'var choices = new Array("%s");' % choices.keys.map {|k| k.to_s}.join('", "')
    js_observe_fuct += "for( var i = 0; i < choices.length; i++)"
    js_observe_fuct += "{var choice = choices[i]; if(choice == 'extend') {}"
    js_observe_fuct += "else if(choice == value) {$('#{obj_name}_' + choice + '_choice').show();}"
    js_observe_fuct += "else {$('#{obj_name}_' + choice + '_choice').hide();} }"

    # type choice
    display = %Q{ <div class="form-element"> %s %s </div> } %
      [ select( obj_name, method_name, choices.keys.map {|k| k.to_s} ),
        observe_field( "#{obj_name}_#{method_name}",
                       :function => js_observe_fuct,
                       :with => method_name )]

    this_choice = obj.send(method_name)
    choices.each {|choice, content|
      if this_choice.to_s == choice.to_s
        visibility = ''
      else
        visibility = 'style="display:none;"'
      end
      display += %Q{ <div id="%s_%s_choice" class="form-element" %s>%s</div> } % [ obj_name, choice.to_s, visibility, content ]
    }

    return display
  end

  # the object named "@#{obj_name}" must be able to respond to all the
  # fields listed below, or you should provide alternate fieldnames.
  def date_or_date_range_picker(obj_name, fields = {})
    date_types = {}
    obj = eval( "@#{obj_name}" )
    fields = { :date => 'date',
      :start_date => 'start_date', :end_date => 'end_date',
      :month => 'month', :year => 'year',
      :date_type => 'date_type' }.merge(fields)

    # daily
    date_types['daily'] = calendar_box(obj_name, fields[:date])
    date_types['monthly'] = select_month(obj.send(fields[:month]), :prefix => obj_name) +
      select_year(obj.send(fields[:year]), :prefix => obj_name)
    # arbitrary
    date_types['arbitrary'] = "From: %s To: %s" %
      [ calendar_box(obj_name, fields[:start_date]),
        calendar_box(obj_name, fields[:end_date]) ]

    return select_visibility(obj_name, fields[:date_type], date_types)
  end

  def time_or_time_range_picker(obj_name, fields)
    #:TODO: ?
  end

  def contact_query_id(options)
    'contact_query'
  end

  def search_results_id(params)
    'search_results_id'
  end

  def scaffold_content_id(options)
    "#{options[:scaffold_id]}-content"
  end

  def scaffold_messages_id(options)
    "#{options[:scaffold_id]}-messages"
  end

  def empty_message_id(options)
    "#{options[:scaffold_id]}-empty-message"
  end

  def column_class(column_name, column_value, sort_column, class_name = nil)
    class_attr = String.new
    class_attr += "empty " if column_empty?(column_value)
    class_attr += "sorted " if (!sort_column.nil? && column_name == sort_column)
    class_attr += "#{class_name} " unless class_name.nil?
    class_attr
  end

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

    def column_empty?(column_value)
      column_value.nil? || (column_value.empty? rescue false)
    end

    def empty_column_text
      "-"
    end

  def column_sort_direction(column_name, params)
    if column_name && column_name == current_sort(params)
      current_sort_direction(params) == "asc" ? "desc" : "asc"
    else
      "asc"
    end
  end

  def current_sort(params)
    if session[params[:scaffold_id]]
      session[params[:scaffold_id]][:sort]
    else
      'asc'
    end
  end

  def scaffold_column_header_id(options)
    "#{options[:scaffold_id]}-#{options[:column_name]}-column"
  end

  def scaffold_tbody_id(options)
    "#{options[:scaffold_id]}-tbody"
  end

end
