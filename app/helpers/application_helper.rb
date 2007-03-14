# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include DatebocksEngine

  def header_totals_id(options)
    "#{options[:scaffold_id]}_header_totals"
  end

  def anonymize_button_id(options)
    "#{options[:scaffold_id]}_anonymize"
  end

  def scaffold_form_tbody_id(options)
    "#{options[:scaffold_id]}_form_tbody"
  end

  # the object named "@#{obj_name}" must be able to respond to all the
  # fields listed below, or you should provide alternate fieldnames.
  def date_or_date_range_picker(obj_name, fields = {})
    @date_types = ['daily', 'monthly', 'arbitrary']
    #:TODO: scrub this first
    obj = eval( "@#{obj_name}" )
    fields = { :date => 'date',
      :start_date => 'start_date', :end_date => 'end_date',
      :month => 'month', :year => 'year',
      :date_type => 'date_type' }.merge(fields)

    # type choice
    display = %Q{ <div class="form-element"> %s %s </div> } %
      [ select( obj_name, fields[:date_type], @date_types ),
        observe_field( "#{obj_name}_#{fields[:date_type]}",
                       #:TODO: cleanify (and maybe learn js)
                       :function => "
if(value == 'monthly') {
  hide1 = 'arbitrary';
  hide2 = 'daily';
} else if(value == 'arbitrary') {
  hide1 = 'monthly';
  hide2 = 'daily';
} else if(value == 'daily') {
  hide1 = 'arbitrary';
  hide2 = 'monthly';
}
$('#{obj_name}_' + value + '_choice').show();
$('#{obj_name}_' + hide1 + '_choice').hide();
$('#{obj_name}_' + hide2 + '_choice').hide();",
                       :with => 'date_type' )]
    # daily
    display += %Q{ <div id="%s_daily_choice" class="form-element">%s</div> } %
      [ obj_name,
        datebocks_field(obj_name, fields[:date]) ]
    # monthly
    display += %Q{ <div id="%s_monthly_choice" style="display:none;">
      <div class="form-element">%s</div><div class="form-element">%s</div></div> } %
      [ obj_name,
        select_month(obj.send(fields[:month]), :prefix => obj_name),
        select_year(obj.send(fields[:year]), :prefix => obj_name) ]
    # arbitrary
    display += %Q{ <div id="%s_arbitrary_choice" style="display:none;" class="form-element">
      From: %s To: %s</div> } %
      [ obj_name,
        datebocks_field(obj_name, fields[:start_date]),
        datebocks_field(obj_name, fields[:end_date]) ]

    return display
  end

  def time_or_time_range_picker(obj_name, fields)
    #:TODO: ?
  end
end
