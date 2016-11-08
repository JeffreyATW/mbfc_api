class CreateBiases < ActiveRecord::Migration[5.0]
  def change
    create_table :biases do |t|
      t.string :name
      t.text :description
      t.string :url

      t.timestamps
    end
  end
end
