class CreateFilterCriteria < ActiveRecord::Migration[5.1]
  def change
    create_table :riews_filter_criterias do |t|
      t.string :field_name
      t.integer :operator, limit: 2, null: false
      t.references :riews_view, foreign_key: true

      t.timestamps
    end
  end
end
