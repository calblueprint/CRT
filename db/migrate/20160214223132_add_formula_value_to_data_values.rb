class AddFormulaValueToDataValues < ActiveRecord::Migration
  def change
    add_column :data_values, :formula_value, :decimal
  end
end
