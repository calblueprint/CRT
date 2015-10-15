class CreateDataTypes < ActiveRecord::Migration
  def change
    create_table :data_types do |t|
      t.string :formula
      t.string :name

      t.timestamps null: false
    end
  end
end
