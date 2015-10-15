class ChangeColumn < ActiveRecord::Migration
  def change
  	change_column :data_points, :attribute_type, :attribute_id
  end
end
