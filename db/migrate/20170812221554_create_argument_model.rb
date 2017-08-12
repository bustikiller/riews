class CreateArgumentModel < ActiveRecord::Migration[5.1]
  def change
    create_table :riews_arguments do |t|
      t.string :value, null: false
      t.references :riews_filter_criteria

      t.timestamps
    end
  end
end
