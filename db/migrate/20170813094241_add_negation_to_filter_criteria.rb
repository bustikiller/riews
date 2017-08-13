class AddNegationToFilterCriteria < ActiveRecord::Migration[5.1]
  def change
    add_column :riews_filter_criterias, :negation, :boolean, default: false, null: false
  end
end
