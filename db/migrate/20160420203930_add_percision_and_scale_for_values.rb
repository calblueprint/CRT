class AddPercisionAndScaleForValues < ActiveRecord::Migration
  def change
    change_column :data_values, :value, :decimal, precision: 19, scale: 4
    change_column :data_values, :formula_value, :decimal, precision: 19, scale: 4
  end
end
