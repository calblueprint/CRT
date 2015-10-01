class CreateAttributes < ActiveRecord::Migration
  def change
    create_table :attributes do |t|
      t.integer :type
      t.decimal :value

      t.timestamps null: false
    end
  end
end
