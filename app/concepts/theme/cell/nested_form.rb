module Theme::Cell
  class NestedForm < ::Trailblazer::Cell
    include ActionView::Helpers::FormOptionsHelper
    self.prefixes << 'app/concepts/theme/view/nested_form'

    # === Parameters
    # {
    #   form: instance,
    #   attribute_name: :symbol,
    #   label: 'string',
    #   fields: [{ type: :(string|collection|boolean), name: :symbol }],
    #   sortable: (true|false)
    # }
    def show
      options[:sortable] = true unless options.key?(:sortable)

      render view: :show, locals: options.except(:fields)
    end

    def collection
      @collection ||= @model
                      .send(options[:attribute_name])
                      .try(:order_by_nested)
    end

    def row(nested_form = nil)
      @nested_form = nested_form

      render view: :row, locals: options.except(:fields)
    end

    def add_label(attribute_name)
      attribute_name.humanize.singularize.titleize
    end

    def fields
      html = field_id("#{field_name}[id]")
      html += field_hidden("#{field_name}[_destroy]", '0')

      options[:fields].each do |field|
        html += generate(field)
      end

      html
    end

    private

    def generate(field)
      send(
        "field_#{field[:type]}",
        "#{field_name}[#{field[:name]}]",
        field_value(field[:name]),
        field
      )
    end

    def object
      @nested_form.object if @nested_form
    end

    def object_try(field)
      object && object.try(:id)
    end

    def object_name
      options[:form].object_name
    end

    def field_name
      "#{object_name}[#{options[:attribute_name]}_attributes][]"
    end

    def field_value(name)
      if field_attributes
        field_attributes[name]
      else
        object ? object.send(name) : nil
      end
    end

    def field_attributes
      return unless params.key?(object_name) && @nested_form

      params[object_name][options[:attribute_name]][@nested_form.index]
    end

    def field_id(name)
      if object_try(:id)
        @nested_form.hidden_field(:id, name: name)
      else
        hidden_field_tag(name)
      end
    end

    def field_boolean(name, value, options = {})
      label_tag(nil, check_box_tag(name, '1', value) + " #{options[:label]}")
    end

    def field_collection(attribute, value, options = {})
      form_group_options = options.fetch(:form_group, {})
      label_text = options.fetch(:label, attribute)
      wrapper_class = options.delete(:wrapper_class)
      wrapper_class = "col-sm-10" if wrapper_class.nil?
      select_html = select_tag(
        attribute,
        options_for_select(options[:collection], value),
        class: 'form-control'
      )
      inspinia_form_group options[:name], form_group_options do
        label_tag(attribute, label_text, class: "col-sm-2 control-label") +
        content_tag(
          :div,
          select_html,
          class: wrapper_class
        )
      end
    end

    def field_hidden(name, value, _options = {})
      hidden_field_tag(name, value)
    end

    # def field_string(name, value, _options = {})
    #   text_field_tag(name, value, class: 'form-control')
    # end

    def field_string(attribute, value, options={})
      wrapper_class = options.delete(:wrapper_class)
      wrapper_class = "col-sm-10" if wrapper_class.nil?
      form_group_options = options.fetch(:form_group, {})
      options[:class] = "form-control"
      label_text = options.fetch(:label, attribute)
      tag_options = options.dup
      tag_options.delete(:name)
      inspinia_form_group options[:name], form_group_options do
        label_tag(attribute, label_text, class: "col-sm-2 control-label") +
        content_tag(
          :div,
          text_field_tag(attribute, value, tag_options) + errors_for(options) + message(options[:message]),
          class: wrapper_class
        )
      end
    end

    def inspinia_form_group(attribute, content, options = {}, &block)
      html_class = options.fetch(:class, "form-group")
      if object
        html_class += " has-error" unless object.errors[attribute].empty?
      end
      content_tag(
        :div,
        yield,
        class: html_class
      )
    end

    def errors_for(options)
      return unless object
      errors = ""
      attribute = options[:name]
      object.errors[attribute].each do |error|
        errors += error + "<br />"
      end
      content_tag(:span, errors.html_safe, class: "help-block m-b-none text-danger")
    end

    def message(str)
      return if str.nil?
      "<span class='help-block m-b-none'>#{str}</span>".html_safe
    end
  end
end
