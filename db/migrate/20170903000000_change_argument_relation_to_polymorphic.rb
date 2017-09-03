class ChangeArgumentRelationToPolymorphic < ActiveRecord::Migration[5.1]
  def up
    rename_column :riews_arguments, :riews_filter_criteria_id, :argumentable_id
    add_column :riews_arguments, :argumentable_type, :string
    Riews::Argument.reset_column_information
    Riews::Argument.update_all(:argumentable_type => 'Riews::FilterCriteria')
  end

  def down
    rename_column :riews_arguments, :argumentable_id, :riews_filter_criteria_id
    remove_column :riews_arguments, :argumentable_type
  end
end
