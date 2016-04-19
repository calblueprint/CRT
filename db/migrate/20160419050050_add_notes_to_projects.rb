class AddNotesToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :notes, :text
  end
end
