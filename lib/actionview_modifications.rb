ActionView::Helpers::PrototypeHelper.send :remove_method, :build_observer
# version of build_observer that gives access to event object
module ActionView
  module Helpers
    module PrototypeHelper
      def build_observer(klass, name, options = {})
        if options[:with] && !options[:with].include?("=")
          options[:with] = "'#{options[:with]}=' + value"
        else
          options[:with] ||= 'value' if options[:update]
        end

        callback = options[:function] || remote_function(options)

        fcn_prototype_str = "function(element, value) {"
        if options[:wantEvent]
          # klass = 'Form.localEventObserver'
          fcn_prototype_str = "function(element, value, evt) {"
        end

        javascript  = "new #{klass}('#{name}', "
        javascript << "#{options[:frequency]}, " if options[:frequency]
        javascript << fcn_prototype_str
        javascript << "#{callback}}"
        javascript << ", '#{options[:on]}'" if options[:on]
        javascript << ")"
        javascript_tag(javascript)
      end
    end
  end
end
