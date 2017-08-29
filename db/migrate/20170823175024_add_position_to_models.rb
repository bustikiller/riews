class AddPositionToModels < ActiveRecord::Migration[5.1]
  def change
    %i(riews_columns riews_filter_criterias riews_arguments riews_relationships).each do |table_name|
      add_column table_name, :position, :integer, default: 0, null: false
    end
  end
end
