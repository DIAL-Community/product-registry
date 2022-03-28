# frozen_string_literal: true

ActionView::Base.field_error_proc = proc do |html_tag, instance|
  html = ''
  form_fields = %w[textarea input select]
  tag_elements = Nokogiri::HTML::DocumentFragment.parse(html_tag).css("label, #{form_fields.join(', ')}")

  tag_elements.each do |e|
    if e.node_name.eql?('label')
      html = e.to_s.html_safe
    elsif form_fields.include?(e.node_name)
      e['class'] = %(#{e['class']} is-invalid)
      field_error_message =
        if instance.error_message.is_a?(Array)
          instance.error_message.uniq.join(', ')
        else
          instance.error_message
        end
      html = %(#{e}<div class="invalid-feedback">#{e.attribute('placeholder')} #{field_error_message}</div>).html_safe
    end
  end

  html
end
