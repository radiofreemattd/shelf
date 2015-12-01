require 'rack'

module Shelf
  class Router
    def self.call(env)

      # require all controllers in controller directory
      Dir.glob('./controllers/*.rb').each { |file| require file }

      # determine requested class#method(args)
      request = Rack::Request.new(env)

      class_name  = request.path_info.split('/')[1].capitalize
      method_name = request.path_info.split('/')[2].downcase
      arguments   = request.params

      # try to create class and send #method(arguments)
      begin
        object_instance = Object.const_get(class_name).new(arguments)
        result          = object_instance.public_send(method_name)
      rescue
        result          = '404'
      end

      # return result
      response = Rack::Response.new
      response.write(result)
      response.finish
    end
  end
end

Rack::Server.start app: Shelf::Router
