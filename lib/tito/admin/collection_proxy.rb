module Tito
  module Admin
    class CollectionProxy
      include Enumerable

      def initialize(scope:, path_suffix: nil)
        @scope = scope
        @path_suffix = path_suffix
        @query = QueryBuilder.new
        @loaded_pages = {}
        @meta = nil
      end

      # -- Chainable query methods (return new proxy) --

      def where(**conditions)
        dup_with { |q| q.add_where(conditions) }
      end

      def order(**fields)
        dup_with { |q| q.add_order(fields) }
      end

      def search(term)
        dup_with { |q| q.add_search(term) }
      end

      def expand(*fields)
        dup_with { |q| q.add_expand(fields) }
      end

      def page(number)
        dup_with { |q| q.set_page(number) }
      end

      def per(size)
        dup_with { |q| q.set_per_page(size) }
      end

      # -- Reading --

      def find(id_or_slug)
        params = @query.expand_params
        data = @scope.request(:get, @scope.member_path(id_or_slug), params: params)
        instantiate(data[@scope.resource_class.resource_name] || data)
      end

      def each(&block)
        return enum_for(:each) unless block_given?

        page_number = @query.page_number || 1
        loop do
          page_data = fetch_page(page_number)
          records = page_data[@scope.resource_class.collection_name] || []
          records.each { |attrs| block.call(instantiate(attrs)) }

          meta = page_data["meta"] || {}
          break if meta["next_page"].nil?
          page_number = meta["next_page"]
        end
      end

      def size
        ensure_first_page_loaded
        @meta&.fetch("total_count", 0) || 0
      end
      alias_method :count, :size
      alias_method :length, :size

      def total_pages
        ensure_first_page_loaded
        @meta&.fetch("total_pages", 0) || 0
      end

      def empty?
        size == 0
      end

      # -- Mutation helpers --

      def build(**attrs)
        @scope.resource_class.new(_scope: @scope, **attrs)
      end

      def create(**attrs)
        build(**attrs).tap(&:save)
      end

      private

      def dup_with
        dup.tap do |copy|
          new_query = @query.dup
          yield new_query
          copy.instance_variable_set(:@query, new_query)
          copy.instance_variable_set(:@loaded_pages, {})
          copy.instance_variable_set(:@meta, nil)
        end
      end

      def fetch_page(number)
        @loaded_pages[number] ||= begin
          params = @query.to_params.merge("page[number]" => number)
          data = @scope.request(:get, @scope.collection_path(suffix: @path_suffix), params: params)
          @meta = data["meta"] if data.is_a?(Hash)
          data
        end
      end

      def ensure_first_page_loaded
        fetch_page(@query.page_number || 1) unless @meta
      end

      def instantiate(attrs)
        @scope.resource_class.new(_scope: @scope, **attrs.transform_keys(&:to_sym))
      end
    end
  end
end
