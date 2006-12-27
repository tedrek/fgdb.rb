# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include DatebocksEngine

  def global_indicator_small_tag
    image_tag "indicator-small.gif", 
      :style => "display:none; color: red; font-size: 10px; font-weight: bold;", 
      :id => 'global-indicator-small', 
      :alt => "active ", :class => "loading-indicator"
  end

  def header_totals_id(options)
    "#{options[:scaffold_id]}_header_totals"
  end
  def submit_choice_buttons_id(options)
    "#{options[:scaffold_id]}_submit_choice_buttons"
  end
  def anonymize_button_id(options)
    "#{options[:scaffold_id]}_anonymize"
  end

  def scaffold_form_tbody_id(options)
    "#{options[:scaffold_id]}_form_tbody"
  end
end
