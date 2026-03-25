module Tito
  module Types
    class StringArray < ActiveModel::Type::Value
      def type = :string_array

      def cast(value)
        case value
        when Array then value.map(&:to_s)
        when nil then nil
        else [value.to_s]
        end
      end
    end
  end
end
