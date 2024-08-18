class CreateTemperatures < ActiveRecord::Migration[7.1]
  def change
    create_table :temperatures do |t|
      t.integer :timestamp
      t.float :value

      t.timestamps
    end
  end
end
