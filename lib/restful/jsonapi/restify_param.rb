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
        new_params = ActionController::Parameters.new
        return new_params if value.nil?
        value.delete(:type)
        # relationships
        if value.has_key? :relationships
          value.delete(:relationships).each do |relationship_name, relationship_data|
            new_data = restify_relationship(relationship_name, relationship_data)
            new_params = new_params.merge(new_data.to_h) if new_data.present?
          end
        end
        # attributes
        attributes = value.has_key?(:attributes) ? value[:attributes] : value
        attributes = attributes.merge(id: value[:id]) if value[:id]
        attributes.transform_keys!(&:underscore)
        new_params = new_params.merge(attributes.to_unsafe_h)
        new_params
      end

      def restify_relationship(relationship_name, relationship_data)
        if data_is_present?(relationship_data[:data]) && relationship_data[:data].is_a?(Array)
          restify_has_many(relationship_name, relationship_data)
        elsif relationship_data.present? && relationship_data.has_key?(:data)
          restify_belongs_to(relationship_name, relationship_data)
        end
      end

      def restify_belongs_to(relationship_name, relationship_data)
        if relationship_data[:data].present? and relationship_data[:data].values_at(:attributes,:relationships).compact.length > 0
          relationship_key = relationship_name.to_s.underscore+"_attributes"
          {relationship_key => restify_data(relationship_name,relationship_data[:data])}
        else
          if relationship_data[:data].nil? || relationship_data[:data].empty?
            {"#{relationship_name.underscore}_id" => nil}
          else
            {"#{relationship_name.underscore}_id" => relationship_data[:data][:id]}
          end
        end
      end

      def restify_has_many(relationship_name, relationship_data)
        if data_is_present?(relationship_data[:data])
          if relationship_data[:data].select{|d|d[:attributes]||d[:relationships]}.blank?
            relationship_key = relationship_name.to_s.singularize.underscore+"_ids"
            relationship = []
            relationship_data[:data].each do |vv|
              relationship.push vv[:id]
            end
            {relationship_key => relationship}
          else
            relationship_key = relationship_name.to_s.underscore+"_attributes"
            relationship = []
            relationship_data[:data].each do |vv|
              relationship.push restify_data(relationship_name,vv)
            end
            {relationship_key => relationship}
          end
        end
      end

      def data_is_present?(data)
        data.is_a? Array or data.present?
      end

    end
  end
end
