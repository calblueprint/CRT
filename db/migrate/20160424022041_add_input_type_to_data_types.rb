class AddInputTypeToDataTypes < ActiveRecord::Migration
  def change
    remove_column :data_values, :input_type, :integer
    add_column :data_types, :input_type, :integer, default: 0, index: true
  end
end
