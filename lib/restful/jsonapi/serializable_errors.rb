module Restful
  module Jsonapi
    module SerializableErrors
      extend ActiveSupport::Concern

      def serializable_errors(object)
        json = {}

        errors = object.errors

        new_hash = errors.to_hash(true).map do |k, v|
          v.map do |msg|
            { id: k, title: msg }
          end
        end.flatten

        json[:errors] = new_hash

        json
      end
    end
  end
end
