class AddSlugToBias < ActiveRecord::Migration[5.0]
  def change
    add_column :biases, :slug, :text
  end
end
