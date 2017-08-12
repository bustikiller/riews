module Riews
  module ViewsHelper
    def generate_view_content_for(view)
      bootstrap_table do |table|
        table.headers = view.columns.map(&:method)

        view.results.each do |object|
          table.rows << view.columns.map{ |column| object[column.method] }
        end
      end
    end
  end
end
