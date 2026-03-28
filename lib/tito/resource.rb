module Tito
  class Resource
    include ActiveModel::API
    include ActiveModel::Attributes
    include ActiveModel::Dirty

    class << self
      def path_template(template = nil)
        if template
          @_path_template = template
        else
          @_path_template
        end
      end

      def member_path_template(template = nil)
        if template
          @_member_path_template = template
        else
          @_member_path_template
        end
      end

      def resource_name(name = nil)
        if name
          @_resource_name = name
        else
          @_resource_name
        end
      end

      def collection_name(name = nil)
        if name
          @_collection_name = name
        else
          @_collection_name || "#{@_resource_name}s"
        end
      end

      def event_scoped!
        @_event_scoped = true
      end

      def account_scoped!
        @_event_scoped = false
      end

      def event_scoped?
        @_event_scoped == true
      end

      def supports(*ops)
        @_supported_operations = ops
      end

      def supported_operations
        @_supported_operations || %i[list show create update delete]
      end

      def expandable(*names)
        @_expandable_fields = names
      end

      def expandable_fields
        @_expandable_fields || []
      end

      def action(name, method: :post, path:)
        define_method(name) do |**params|
          body = params.empty? ? {} : { self.class.resource_name => params }
          response = _scope.request(method, "#{_scope.member_path(identifier)}/#{path}", body: body)
          if response.is_a?(Hash) && response[self.class.resource_name]
            _apply_response(response)
          end
          self
        end
      end

      # Declare a nested resource accessor
      def has_many(name, resource_class_name:, foreign_key: nil)
        define_method(name) do
          child_class = Tito::Admin::Resources.const_get(resource_class_name)
          child_scope = _scope.nested_scope(child_class, parent_id: identifier)
          Tito::Admin::CollectionProxy.new(scope: child_scope)
        end
      end

      def attribute_names_set = @attribute_names_set ||= attribute_names.to_set
    end

    attr_reader :_scope

    def initialize(_scope: nil, **attrs)
      @_scope = _scope
      @_persisted = !!(attrs[:id] || attrs[:slug] || attrs["id"] || attrs["slug"])
      # Drop unknown attributes
      known = self.class.attribute_names_set
      allowed = attrs.select { |k, _| known.include?(k.to_s) }
      super(**allowed)
      clear_changes_information if @_persisted
    end

    def persisted?
      @_persisted
    end

    def new_record?
      !persisted?
    end

    def identifier
      slug = respond_to?(:slug) ? self.slug : nil
      slug.present? ? slug : id
    end

    def save
      if persisted?
        _update
      else
        _create
      end
    end

    def destroy
      _scope.request(:delete, _scope.member_path(identifier))
      @_destroyed = true
      freeze
      true
    end

    def destroyed?
      @_destroyed == true
    end

    def reload
      data = _scope.request(:get, _scope.member_path(identifier))
      _apply_response(data)
      self
    end

    private

    def _create
      body = { self.class.resource_name => _writable_attributes }
      data = _scope.request(:post, _scope.collection_path, body: body)
      _apply_response(data)
      @_persisted = true
      self
    end

    def _update
      body = { self.class.resource_name => _changed_attributes_hash }
      data = _scope.request(:patch, _scope.member_path(identifier), body: body)
      _apply_response(data)
      self
    end

    def _changed_attributes_hash
      changed.each_with_object({}) { |attr, h| h[attr] = send(attr) }
    end

    def _writable_attributes
      attributes.reject { |_, v| v.nil? }
    end

    def _apply_response(data)
      attrs = data.is_a?(Hash) ? (data[self.class.resource_name] || data) : {}
      attrs.each do |key, value|
        setter = "#{key}="
        send(setter, value) if respond_to?(setter)
      end
      clear_changes_information
    end
  end
end
