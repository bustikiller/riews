module Riews
  module ViewsHelper
    def generate_view_content_for(view, page=1, per_page=10)
      bootstrap_table do |table|
        table.headers = view.columns.map(&:method)

        get_affected_models(view, page, per_page).each do |object|
          table.rows << view.columns.map{ |column| object[column.method] }
        end
      end
    end

    def generate_view_paginator_for(view, page=1, per_page=10)
      paginate get_affected_models(view, page, per_page)
    end

    private

    def get_affected_models(view, page, per_page)
      view.results(page, per_page)
    end
  end
end
