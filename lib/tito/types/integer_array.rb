module Tito
  module Types
    class IntegerArray < ActiveModel::Type::Value
      def type = :integer_array

      def cast(value)
        case value
        when Array then value.map(&:to_i)
        when nil then nil
        else [value.to_i]
        end
      end
    end
  end
end
