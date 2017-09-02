class AddActionLinkModel < ActiveRecord::Migration[5.1]
  def change
    create_table :riews_action_links do |t|
      t.string :base_path
      t.string :display_pattern
      t.references :riews_column, foreign_key: true

      t.timestamps
    end

  end
end
