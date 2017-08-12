class AddForeignKeyOnArguments < ActiveRecord::Migration[5.1]
  def change
    add_foreign_key :riews_arguments, :riews_filter_criterias, column: :riews_filter_criteria_id
  end
end
