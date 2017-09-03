module Riews
  module ApplicationHelper
    def display_base_error_messages(f)
      alert_box f.error(:base), context: :danger if f.error(:base).present?
    end
  end
end
