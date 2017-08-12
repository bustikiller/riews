module Riews
  module ViewsHelper

    def generate_view_content_for(view)
      content_tag :table do
        generate_header_for(view) + generate_body_for(view)
      end
    end

    def generate_header_for(view)
      content_tag :thead do
        content_tag :tr do
          view.columns.map {|column| content_tag :th, column.method}.inject(:+)
        end
      end
    end

    def generate_body_for(view)
      content_tag :tbody do
        view.results.map do |object|
          content_tag :tr do
            view.columns.map do |column|
              content_tag :td, object[column.method]
            end.inject(:+)
          end
        end.inject(:+)
      end
    end
  end
end
