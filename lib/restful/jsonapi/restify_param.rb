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
          value = params.clone[:data]
        end
        if value.delete(:type).underscore == param_key.to_s.pluralize
          new_params = ActionController::Parameters.new
          attributes = value.has_key?(:attributes) ? value[:attributes] : value
          attributes.merge!(id: value[:id]) if value[:id]
          attributes.transform_keys!(&:underscore)
          new_params.merge!(attributes)
          if value.has_key? :relationships
            value[:relationships].each do |k,v|
              if k.pluralize != k

              # belongs to relationship
                unless v[:data].nil?
                  new_params["#{k}_id"] = v[:data][:id]
                else
                  new_params["#{k}_id"] = nil
                end

              # has many relationship
              elsif v[:data].present?
                if v[:data].reject{|data|data.has_key? :attributes}.blank?
                  relationship_key = k.to_s.underscore+"_attributes"
                  new_params[relationship_key] ||= []
                  v[:data].each do |vv|
                    new_params[relationship_key].push restify_value(k,vv)
                  end unless v[:data].nil?
                else
                  relationship_key = k.to_s.singularize.underscore+"_ids"
                  new_params[relationship_key] ||= []
                  v[:data].each do |vv|
                    new_params[relationship_key].push vv[:id]
                  end unless v[:data].nil?
                end
              end
            end
          end
          new_params
        end
      end

    end
  end
end
