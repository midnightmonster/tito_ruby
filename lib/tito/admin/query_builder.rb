module Tito
  module Admin
    class QueryBuilder
      attr_reader :page_number

      def initialize
        @wheres = {}
        @orders = {}
        @search_term = nil
        @expands = []
        @page_number = nil
        @per_page = nil
      end

      def add_where(conditions)
        conditions.each { |key, value| @wheres[key] = value }
        self
      end

      def add_order(fields)
        @orders.merge!(fields)
        self
      end

      def add_search(term)
        @search_term = term
        self
      end

      def add_expand(fields)
        @expands.concat(fields.flatten)
        self
      end

      def set_page(number)
        @page_number = number
        self
      end

      def set_per_page(size)
        @per_page = size
        self
      end

      def expand_params
        @expands.any? ? { "expand" => @expands.join(",") } : {}
      end

      def to_params
        params = {}
        params["page[size]"] = @per_page if @per_page
        params["q"] = @search_term if @search_term
        params.merge!(expand_params)
        params.merge!(where_params)
        params.merge!(order_params)
        params
      end

      def dup
        super.tap do |copy|
          copy.instance_variable_set(:@wheres, @wheres.dup)
          copy.instance_variable_set(:@orders, @orders.dup)
          copy.instance_variable_set(:@expands, @expands.dup)
        end
      end

      private

      def where_params
        params = {}
        @wheres.each do |key, value|
          case value
          when Array
            plural_key = key.to_s
            plural_key = plural_key.end_with?("s") ? plural_key : "#{plural_key}s"
            params["search[#{plural_key}]"] = value.map(&:to_s)
          when Range
            if value.begin
              params["search[#{key}][gte]"] = format_value(value.begin)
            end
            if value.end
              op = value.exclude_end? ? "lt" : "lte"
              params["search[#{key}][#{op}]"] = format_value(value.end)
            end
          else
            params["search[#{key}]"] = format_value(value)
          end
        end
        params
      end

      def order_params
        return {} if @orders.empty?
        parts = @orders.map { |field, dir| dir == :desc ? "-#{field}" : field.to_s }
        { "sort" => parts.join(",") }
      end

      def format_value(val)
        case val
        when Time, DateTime
          val.utc.iso8601.sub(/Z$/, " UTC")
        when Date
          val.to_s
        else
          val.to_s
        end
      end
    end
  end
end
