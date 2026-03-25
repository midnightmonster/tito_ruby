module Tito
  module Types
    class Json < ActiveModel::Type::Value
      def type = :json

      def cast(value)
        case value
        when Hash, Array then value
        when String then JSON.parse(value)
        when nil then nil
        else value
        end
      end
    end
  end
end
