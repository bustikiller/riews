require 'riews/column_pattern'

module Riews
  module ViewsHelper
    def generate_view_content_for(view, page=1)
      bootstrap_table do |table|
        table.headers = view.columns.displayed.map(&:displayed_name)
        table.rows = render_view_rows(page, view)
      end
    rescue ActiveRecord::StatementInvalid
      panel_with_body title: 'SQL error' do
        content_tag :span, 'An error occurred executing the SQL statement. Please, review your configuration'
      end
    end

    def generate_view_paginator_for(view, page=1)
      paginate get_affected_models(view, page) if view.columns.any? && view.paginator_size > 0
    end

    def generate_helper_buttons_for(view)
      buttons = []
      buttons << link_to('Edit', riews.edit_view_path(view)) if can? :edit, view
      buttons << link_to('All views', riews.views_path) if can? :list, View
      buttons.inject{|sum, link| sum +' | ' + link }
    end

    def generate_raw_sql_for(view, page=1)
      return unless can? :debug, view
      sql_statement = get_affected_models(view, page).select(*view.queried_column_db_identifiers).to_sql
      content_tag :code, sql_statement, class: 'col-md-12'
    end

    def riews_table_with_code(code)
      view = View.find_or_create_by code: code
      view.update name: code if view.name.blank?
      riews_table(view)
    end

    def riews_table(view, page=1)
      if view.model.present? && view.columns.any?
        [
            generate_view_content_for(view, page),
            generate_view_paginator_for(view, page),
            generate_raw_sql_for(view, page),
            generate_helper_buttons_for(view)
        ].compact.inject(:+)
      else
        render partial: 'riews/views/empty_view', locals: {view: view}
      end
    end

    def available_columns_for_select(view)
      result = view.available_columns.group_by{|c| c.split('.').size > 1 ? c.split('.').first : view.klass.table_name}
      result.each.map do |table, column_names|
        [
            table,
            column_names.map {|column_name| [column_name, table.classify.constantize.human_attribute_name(column_name)]}
        ]
      end.to_h
    end

    private

    def get_affected_models(view, page)
      ability = respond_to?(:current_ability) ? current_ability : nil
      view.results(page, view.paginator_size, ability)
    end

    def render_view_rows(page, view)
      columns_queried = view.columns.with_method
      rows = get_affected_models(view, page).pluck(*view.queried_column_db_identifiers)
      rows.map do |row|
        row = [row] unless row.is_a?(Array)
        row_with_context = row.each_with_index.map{ |value, i| { columns_queried[i].id => value } }.inject({}, :merge)
        render_single_row(view.columns, row_with_context)
      end
    end

    def render_single_row(columns, row)
      original_row = row.dup
      columns.displayed.includes(:action_links).map do |column|
        row_content = if column.method.present? then
                        column.format(row[column.id])
                      else
                        sanitize(Riews::ColumnPattern.new(column.pattern).format(original_row))
                      end
        safe_join [row_content, generate_links_for_column(column, original_row)]
      end
    end

    def generate_links_for_column(column, original_row)
      links = column.action_links.map do |action_link|
        link_name = sanitize(Riews::ColumnPattern.new(action_link.display_pattern).format(original_row))
        link_target = sanitize(action_link.base_path_with_replacements(original_row))

        extra_options = {}
        extra_options = {method: :delete, data: {confirm: 'Are you sure?'}} if action_link.delete_link?
        link_to link_name, link_target, extra_options
      end
      safe_join links
    end
  end
end
