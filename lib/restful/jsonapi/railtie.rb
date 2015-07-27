module Restful
  module Jsonapi
    class Railtie < Rails::Railtie
      initializer "restful-jsonapi.action_controller" do
        ActiveSupport.on_load(:action_controller) do
          puts "Extending #{self} with Restful::Jsonapi::RestifyParam"
          include Restful::Jsonapi::RestifyParam

          puts "Extending #{self} with Restful::Jsonapi::SerializableErrors"
          include Restful::Jsonapi::SerializableErrors
        end
      end

      initializer "restful-jsonapi.active_model_serializer" do
        ActiveModel::Serializer.class_eval do
          puts "Extending #{self} with Restful::Jsonapi::ActiveModelSerializer"
          include Restful::Jsonapi::ActiveModelSerializer
        end
      end
    end
  end
end
