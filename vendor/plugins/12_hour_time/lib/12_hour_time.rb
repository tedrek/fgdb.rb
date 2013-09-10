class ActiveRecord::Base
  def instantiate_time_object_with_ampm(name, values)
    if values.length == 2 or values.length == 3
      values = [2000, 1, 1, *values] # this is really messed up but
#      fine...ruby represents times as seconds since epoch, so it can't
#      handle a time without having a date too. this will introduce
#      many, many bugs over the course of this app I'm sure.
#      We do it elsewhere anyway tho...it has to happen all over.
    end

    if values.last < 0
      ampm = values.pop
      if ampm == ActionView::Helpers::DateTimeSelector::AM and values[-2] == 12
        values[-2] = 0
      elsif ampm == ActionView::Helpers::DateTimeSelector::PM and values[-2] != 12
        values[-2] += 12
      end
    end

    instantiate_time_object_without_ampm(name, values)
  end

  alias_method_chain :instantiate_time_object, :ampm
end

module ActionView::Helpers
  class DateTimeSelector
    # Add the :ampm key to POSITION, as it is frozen we need to #dup first
    # then remove the constant to avoid a warning.  ReFreeze afterwards to
    # be explicit.
    p = POSITION.dup
    remove_const :POSITION
    p[:ampm] = 7
    POSITION = p.freeze

    # We give them negative values so can differentiate between normal
    # date/time values. The way the multi param stuff works, from what I
    # can see, results in a variable number of fields (if you tell it to
    # include seconds, for example). So we expect the AM/PM field, if
    # present, to be last and have a negative value.
    AM = -1
    PM = -2

    def select_hour_with_ampm
      unless @options[:twelve_hour]
        return select_hour_without_ampm
      end

      if @options[:use_hidden] || @options[:discard_hour]
        build_hidden(:hour, hour12)
      else
        build_options_and_select(:hour, hour12, :start => 1, :end => 12)
      end
    end

    alias_method_chain :select_hour, :ampm

    def select_ampm
      selected = hour.nil? ? hour : ((hour < 12) ? AM : PM)

      # XXX i18n? 
      label = { AM => 'AM', PM => 'PM' }
      ampm_options = []
      [AM, PM].each do |meridiem|
        option = { :value => meridiem }
        option[:selected] = "selected" if selected == meridiem
        ampm_options << content_tag(:option, label[meridiem], option) + "\n"
      end
      build_select(:ampm, ampm_options.join)
    end

    private

    def build_selects_from_types_with_ampm(order)
      order += [:ampm] if @options[:twelve_hour] and !order.include?(:ampm)
      build_selects_from_types_without_ampm(order)
    end

    alias_method_chain :build_selects_from_types, :ampm

    def hour12
      return hour if hour.nil?
      h12 = hour % 12
      h12 = 12 if h12 == 0
      return h12
    end
  end
end
