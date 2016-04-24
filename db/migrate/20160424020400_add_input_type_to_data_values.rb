class AddInputTypeToDataValues < ActiveRecord::Migration
  def change
    add_column :data_values, :input_type, :integer, default: 0, index: true
  end
end
