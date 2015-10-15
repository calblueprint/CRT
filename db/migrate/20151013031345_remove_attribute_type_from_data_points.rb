class RemoveAttributeTypeFromDataPoints < ActiveRecord::Migration
  def change
    remove_column :data_points, :attribute_type, :integer
  end
end
