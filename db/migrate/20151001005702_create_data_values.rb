class CreateDataValues < ActiveRecord::Migration
  def change
    create_table :data_values do |t|
      t.integer :type
      t.decimal :value

      t.timestamps null: false
    end
  end
end
