module Restful
  module Jsonapi
    module ActiveModelSerializer
      extend ActiveSupport::Concern

      included do
        def type
          object.class.model_name.name.demodulize.pluralize.underscore
        end
      end
    end
  end
end
