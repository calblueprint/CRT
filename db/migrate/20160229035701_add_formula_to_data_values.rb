class AddFormulaToDataValues < ActiveRecord::Migration
  def change
    add_column :data_values, :input_formula, :string
  end
end
