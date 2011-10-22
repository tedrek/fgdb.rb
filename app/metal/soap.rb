# in rails three this will be a controller again and use the routing stuff

# Allow the metal piece to run in isolation
require(File.dirname(__FILE__) + "/../../config/environment") unless defined?(Rails)

module SoapMetal
  class Req
    def initialize(env, body)
      @env = env
      @body = body
    end

    def [](arg)
      @env[arg]
    end

    def meta_vars
      {'HTTP_SOAPACTION' => @env['HTTP_SOAPACTION']}
    end

    attr_reader :body
  end

  class Res
    def initialize
      @status = 200
      @headers = {}
      @body = ""
    end

    attr_reader :status, :headers, :body

    def status=(thing)
      @status = thing
    end
    def []=(a,b)
      @headers[a] = b
    end

    def body=(s)
      @body = s
    end

    class ActionController::CgiRequest
    end
  end
end

class Soap
  def self.call(env)
    if !env["HTTP_SOAPACTION"].nil?
      rq = SoapMetal::Req.new(env, env["rack.input"].read)
      rs = SoapMetal::Res.new
      SOAP::SoapHandler.new.handle(rq, rs)
      return [rs.status, rs.headers, [rs.body]]
    else
      return [404, {"Content-Type" => "text/html"}, ["Not Found"]] # falls through to rails
    end
  end
end
