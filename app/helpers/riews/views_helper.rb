module Riews
  module ViewsHelper
    def generate_view_content_for(view, page=1)
      bootstrap_table do |table|
        table.headers = view.columns.map(&:method)

        get_affected_models(view, page).each do |object|
          table.rows << view.columns.map{ |column| object[column.method] }
        end
      end
    end

    def generate_view_paginator_for(view, page=1)
      paginate get_affected_models(view, page)
    end

    private

    def get_affected_models(view, page)
      view.results(page, view.paginator_size)
    end
  end
end
