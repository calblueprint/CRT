class AddGeneralToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :general, :boolean, default: false
    add_index :projects, :general
  end
end
