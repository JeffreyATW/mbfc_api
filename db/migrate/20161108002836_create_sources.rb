class CreateSources < ActiveRecord::Migration[5.0]
  def change
    create_table :sources do |t|
      t.string :name
      t.text :notes
      t.string :homepage
      t.string :domain
      t.integer :bias_id

      t.timestamps
    end
  end
end
