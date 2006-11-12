# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def global_indicator_small_tag
    image_tag "indicator-small.gif", 
      :style => "display:none; color: red; font-size: 10px; font-weight: bold;", 
      :id => 'global-indicator-small', 
      :alt => "active ", :class => "loading-indicator"
  end
end
