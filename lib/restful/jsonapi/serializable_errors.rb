module Restful
  module Jsonapi
    module SerializableErrors
      extend ActiveSupport::Concern

      def serializable_errors(object)
        errors = object.errors
        prefix = object.class.to_s.demodulize.underscore

        new_hash = errors.to_hash.map do |k, v|
          v.map do |msg|
            { id: "#{prefix}.#{k}", title: msg }
          end
        end.flatten

        { errors: new_hash }
      end
    end
  end
end
