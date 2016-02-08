class RenameGeneralInProjectToMaster < ActiveRecord::Migration
  def change
    rename_column :projects, :general, :master
  end
end
