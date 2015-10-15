class RenameAttributes < ActiveRecord::Migration
  def self.up
    rename_table :attributes, :data_points
  end

 def self.down
    rename_table :data_points, :attributes
 end
end
