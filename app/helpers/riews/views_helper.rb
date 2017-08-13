module Riews
  module ViewsHelper
    def generate_view_content_for(view, page=1)
      if view.columns.any?
        bootstrap_table do |table|
          table.headers = view.columns.map(&:method)
          table.rows = get_affected_models(view, page).pluck(*view.columns.map(&:method).map(&:to_sym))
        end
      else
        render partial: 'riews/views/empty_view', locals: {view: view}
      end
    end

    def generate_view_paginator_for(view, page=1)
      paginate get_affected_models(view, page) if view.columns.any?
    end

    def generate_helper_buttons_for(view)
      [
          link_to('Edit', riews.edit_view_path(view)),
          link_to('Back', riews.views_path),
          link_to('Columns', riews.view_columns_path(view)),
          link_to('Filters', riews.view_filters_path(view))
      ].inject{|sum, link| sum +' | ' + link }
    end

    def riews_table_with_code(code)
      view = View.find_or_create_by code: code
      [
          generate_view_content_for(view),
          generate_view_paginator_for(view),
          generate_helper_buttons_for(view)
      ].compact.inject(:+)
    end

    private

    def get_affected_models(view, page)
      view.results(page, view.paginator_size)
    end
  end
end
