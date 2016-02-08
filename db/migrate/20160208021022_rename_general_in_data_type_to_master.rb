class RenameGeneralInDataTypeToMaster < ActiveRecord::Migration
  def change
    rename_column :data_types, :general, :master
  end
end
