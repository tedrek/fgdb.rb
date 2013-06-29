class MyAPIPort
end

class MyAPIMiddleware < Soap4r::Middleware::Base
  def initialize(*args)
    puts "ONCE"
    super(*args)
  end

  setup do
    self.endpoint = %r{^/}
    servant = MyAPIPort.new
#    MyAPIPort::Methods.each do |definitions|
#      opt = definitions.last
#      if opt[:request_style] == :document
#        @router.add_document_operation(servant, *definitions)
#      else
#        @router.add_rpc_operation(servant, *definitions)
#      end
#    end
#    self.mapping_registry = UrnMyAPIMappingRegistry::EncodedRegistry
#    self.literal_mapping_registry = UrnMyAPIMappingRegistry::LiteralRegistry
  end
end

class SOAP::RPC::Router
  def my_add_method(obj, name, namespace, *param)
    qname = XSD::QName.new(namespace, name)
    soapaction = nil
    param_def = SOAP::RPC::SOAPMethod.derive_rpc_param_def(obj, name, *param)
    self.add_rpc_operation(obj, qname, soapaction, name, param_def)
  end
end

module SOAP

class SoapsBase
#  include ApplicationHelper
  def initialize(router)
    @router = router
    add_methods
  end
  def add_method(name, *param)
    namespace = "urn:" + self.class.to_s.underscore.sub("soap_handler/", "").sub(/_api$/, "")
#    puts "Adding soap method {#{namespace}}#{name}(#{param.join(", ")})"
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
end

# TODO
#Dir.glob(RAILS_ROOT + "/app/apis/*.rb").each{|x|
#  require_dependency x
#}

#module SOAP
#class SoapHandler
#  def handle(req, res)
#    @mysoaplet.do_POST(req, res)
#    res
#  end
#
#  def setup
#    router = SOAP::RPC::Router.new("Soaps")
#Dir.glob(RAILS_ROOT + "/app/apis/*.rb").each{|x|
#  require_dependency x
#}
#
#
##      puts "Loading api from " + x
##    Dir.glob(RAILS_ROOT + "/app/apis/*.rb").each{|x|
#    SOAP::SoapsBase.subclasses.map{|x| x.constantize}.each{|x|
#      x.new(router)
##      eval("SOAP::#{File.basename(x).capitalize.sub(/.rb$/, "")}API.new(router)")
#    }
#    SOAP::RPC::SOAPlet.new(router)
#  end
#
#  def initialize
#    # remember all of the stuff between requests if we are in production mode
#    @mysoaplet = setup
#  end
#end
#end
#
## might regain its usefulness with rails 3:
#
##class ActionController::CgiResponse
##  def status=(thing)
#    self.headers['Status'] = thing.to_s
#  end
#  def []=(a,b)
#    self.headers[a] = b
#  end
#end

#class ActionController::CgiRequest
#  def meta_vars
#    {'HTTP_SOAPACTION' => self.headers['Soapaction']}
#  end
#end

#class ActionController::Routing::RouteSet
#  def extract_request_environment_with_soap(req)
#    hash = extract_request_environment_without_soap(req)
#    hash[:soap] = !req.headers['Soapaction'].nil?
#    hash
#  end
#  alias_method_chain :extract_request_environment, :soap
#end

#class ActionController::Routing::Route
#  def recognition_conditions_with_soap
#    res = recognition_conditions_without_soap
#    res << "conditions[:soap] == env[:soap]" if conditions[:soap]
#    res
#  end
#  alias_method_chain :recognition_conditions, :soap
#end

#class SoapController < ActionController::Base
#  def index
#    SoapHandler.new.handle(request, response)
#    @performed_render = true
#  end
#end
