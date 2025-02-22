ActionView::Base.field_error_proc = -> (html_tag, instance) {
  unless html_tag =~ /^<label/
    html = Nokogiri::HTML::DocumentFragment.parse(html_tag)
    element = html.children.first

    if element
      existing_classes = element['class'] || ''
      element.set_attribute("class", "#{existing_classes} is-danger".strip)
    end

    error_message = <<~HTML
      <p class='help is-danger'>
        #{ERB::Util.html_escape(instance.error_message.to_sentence)}
      </p>
    HTML

    "#{html.to_s}#{error_message}".html_safe
  else
    html_tag
  end
}
