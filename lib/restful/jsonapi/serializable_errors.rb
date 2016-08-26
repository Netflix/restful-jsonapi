module Restful
  module Jsonapi
    module SerializableErrors
      extend ActiveSupport::Concern

      def serializable_errors(object)
        prefix = object.class.to_s.demodulize.underscore

        errors = object.errors.to_hash.each_with_object([]) do |(k, v), array|
          v.each do |msg|
            array.push(id: "#{prefix}.#{k}", title: msg)
          end
        end

        { errors: errors }
      end
    end
  end
end
