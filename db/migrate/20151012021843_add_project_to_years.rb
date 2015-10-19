class AddProjectToYears < ActiveRecord::Migration
  def change
    add_reference :years, :project, index: true
    add_foreign_key :years, :projects
  end
end
