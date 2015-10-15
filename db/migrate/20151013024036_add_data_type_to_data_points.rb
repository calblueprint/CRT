class AddDataTypeToDataPoints < ActiveRecord::Migration
  def change
    add_reference :data_points, :data_type, index: true
    add_foreign_key :data_points, :data_types
  end
end
