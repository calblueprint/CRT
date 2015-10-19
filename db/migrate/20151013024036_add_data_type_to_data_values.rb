class AddDataTypeToDataValues < ActiveRecord::Migration
  def change
    add_reference :data_values, :data_type, index: true
    add_foreign_key :data_values, :data_types
  end
end
