module Restful
  module Jsonapi
    class Railtie < Rails::Railtie
      initializer "restful-jsonapi.action_controller" do
        ActiveSupport.on_load(:action_controller) do
          puts "Extending #{self} with Restful::Jsonapi::RestifyParam"
          include Restful::Jsonapi::RestifyParam
        end
      end
    end
  end
end
