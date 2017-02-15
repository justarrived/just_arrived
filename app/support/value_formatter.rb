# frozen_string_literal: true
class ValueFormatter
  include ActionView::Helpers::TextHelper # needed for #simple_format

  def text_to_html(string)
    return if string.blank?

    simple_format(string)
  end
end
