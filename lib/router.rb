require 'rack'
require 'yaml'

module Shelf
  class Router
    def self.call(env)

      # require all controllers in controller directory
      Dir.glob('./controllers/*.rb').each { |file| require file }

      # determine requested class#method(args)
      request = Rack::Request.new(env)

      class_name  = request.path_info.split('/')[1]
      method_name = request.path_info.split('/')[2]
      arguments   = request.params

      # do we need to re-map to any custom routes?
      config = YAML.load_file 'routes.yml'
      if config['custom_routes'].key?("#{class_name}.#{method_name}")
        custom_route = config['custom_routes']["#{class_name}.#{method_name}"]
        custom_route = custom_route.split('.')
        class_name   = custom_route[0]
        method_name  = custom_route[1]
      end

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
