module Restful
  module Jsonapi
    module RestifyParam
      extend ActiveSupport::Concern

      def restify_param(param_key)
        ActionController::Parameters.new(param_key => restify_value(param_key))
      end

      private

      def restify_value(param_key, value = params)
        if value == params
          value = params.clone
        end
        if value[:data]
          if value[:data].delete(:type).underscore == param_key.to_s.pluralize
            new_params = ActionController::Parameters.new
            attributes = value[:data].has_key?(:attributes) ? value[:data][:attributes] : value[:data]
            attributes.transform_keys!(&:underscore)
            new_params.merge!(attributes)
            if value[:data].has_key? :relationships
              value[:data][:relationships].each do |k,v|
                if k.pluralize != k
                  unless v[:data].nil?
                    new_params["#{k}_id"] = v[:data][:id]
                  else
                    new_params["#{k}_id"] = nil
                  end
                else
                  relationship_key = k.to_s.underscore+"_attributes"
                  new_params[relationship_key] ||= []
                  v[:data].each do |vv|
                    new_params[relationship_key].push restify_value(k,vv)
                  end unless v[:data].nil?
                end
              end
            end
            new_params
          end
        end
      end

    end
  end
end
