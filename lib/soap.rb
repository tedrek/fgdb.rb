require 'soap4r-middleware'

class MyAPIPort
  attr_reader :router

  def self.port
    @@port
  end

  def initialize(router)
    @router = router
    @@port = self
  end

  def add_method(obj, name, namespace, *param)
    qname = XSD::QName.new(namespace, name)
    soapaction = nil
    param_def = SOAP::RPC::SOAPMethod.derive_rpc_param_def(obj, name, *param)
    @router.add_rpc_operation(obj, qname, soapaction, name, param_def)
  end
end

class MyAPIMiddleware < Soap4r::Middleware::Base
  setup do
    self.endpoint = %r{^/}
    servant = MyAPIPort.new(@router)
#    MyAPIPort::Methods.each do |definitions|
#      opt = definitions.last
#      if opt[:request_style] == :document
#        @router.add_document_operation(servant, *definitions)
#      else
#        @router
#      end
#    end
#    self.mapping_registry = UrnMyAPIMappingRegistry::EncodedRegistry
#    self.literal_mapping_registry = UrnMyAPIMappingRegistry::LiteralRegistry
  end
end

#module SOAP
#class SoapHandler
#  def handle(req, res)
#    @mysoaplet.do_POST(req, res)
#    res
#  end
#
#  def setup
#    router = SOAP::RPC::Router.new("Soaps")
#Dir.glob(::Rails.root.to_s + "/app/apis/*.rb").each{|x|
#  require_dependency x
#}
#
#
##      puts "Loading api from " + x
##    Dir.glob(::Rails.root.to_s + "/app/apis/*.rb").each{|x|
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
