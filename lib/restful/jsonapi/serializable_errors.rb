module Restful
  module Jsonapi
    module SerializableErrors
      extend ActiveSupport::Concern

      def serializable_errors(object)
        errors = object.errors
        prefix = object.class.to_s.demodulize.underscore

        json = {}

        new_hash = errors.to_hash.map do |k, v|
          v.map do |msg|
            { id: "#{prefix}.#{k}", title: msg }
          end
        end.flatten

        json[:errors] = new_hash

        json
      end
    end
  end
end
