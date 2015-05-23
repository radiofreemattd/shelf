module Shelf
  class BaseController
    # Dynamically creates a set of instance variables using keys/values in args
    def initialize(args = {})
      args.each { |name, value| instance_variable_set("@#{name}", value) }
      post_initialize # callback hook
    end

    # Dynamically creates a set of instance variables using keys/values in args
    def post_initialize
    end

    # merge instance variables into template and return result
    def erb(class_name  = self.class.name.downcase,
            method_name = caller_locations(1,1)[0].label)

      path = File.expand_path("./views/#{class_name}.#{method_name}.html.erb")
      ERB.new(File.read(path)).result(binding)
    end
  end
end
