module Restful
  module Jsonapi
    module RestifyParam
      extend ActiveSupport::Concern

      def restify_param(param_key)
        ActionController::Parameters.new(param_key => restify_data(param_key))
      end

      private

      def restify_data(param_key, value = params)
        if value == params
          value = params.clone[:data] # leave params alone
        end
        value.delete(:type)
        new_params = ActionController::Parameters.new
        # relationships
        if value.has_key? :relationships
          value.delete(:relationships).each do |relationship_name, relationship_data|
            new_data = restify_relationship(relationship_name, relationship_data)
            new_params.merge! new_data if new_data.present?
          end
        end
        # attributes
        attributes = value.has_key?(:attributes) ? value[:attributes] : value
        attributes.merge!(id: value[:id]) if value[:id]
        attributes.transform_keys!(&:underscore)
        new_params.merge!(attributes)
        new_params
      end

      def restify_relationship(relationship_name, relationship_data)
        if relationship_data[:data].present?
          if relationship_data[:data].is_a? Hash
            restify_belongs_to(relationship_name, relationship_data)
          else
            restify_has_many(relationship_name, relationship_data)
          end
        end
      end

      def restify_belongs_to(relationship_name, relationship_data)
        if relationship_data[:data].has_key? :attributes
          relationship_key = relationship_name.to_s.underscore+"_attributes"
          {relationship_key => restify_data(relationship_name,relationship_data[:data])}
        else
          {"#{relationship_name}_id" => relationship_data[:data][:id]}
        end
      end

      def restify_has_many(relationship_name, relationship_data)
        if relationship_data[:data].select(&:attributes).blank?
          relationship_key = relationship_name.to_s.singularize.underscore+"_ids"
          new_params[relationship_key] ||= []
          relationship_data[:data].each do |vv|
            new_params[relationship_key].push vv[:id]
          end unless relationship_data[:data].nil?
        else
          relationship_key = relationship_name.to_s.underscore+"_attributes"
          new_params[relationship_key] ||= []
          relationship_data[:data].each do |vv|
            new_params[relationship_key].push restify_data(relationship_name,vv[:data])
          end unless relationship_data[:data].nil?
        end
      end

    end
  end
end
