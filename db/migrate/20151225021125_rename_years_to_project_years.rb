class RenameYearsToProjectYears < ActiveRecord::Migration
  def change
    rename_table :years, :project_years
  end
end
