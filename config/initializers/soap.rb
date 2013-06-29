class SoapsBase
  include ApplicationHelper
  def initialize(router)
    @router = router
    add_methods
  end

  def add_method(name, *param)
    namespace = "urn:" + self.class.to_s.underscore.sub("soap_handler/", "").sub(/_api$/, "")
    puts "Adding soap method {#{namespace}}#{name}(#{param.join(", ")})"
    @router.send(:my_add_method, self, name, namespace, *param)
  end

  def error(e, msg = "")
    ret = save_exception_data(e)
    message = msg + e.message + " (crash id #{ret["crash_id"]})"
    SOAP::SOAPFault.new(SOAP::SOAPString.new("soaps"),
                        SOAP::SOAPString.new(message),
                        SOAP::SOAPString.new(self.class.name))
  end
end
