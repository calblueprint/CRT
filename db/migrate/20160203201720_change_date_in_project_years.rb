class ChangeDateInProjectYears < ActiveRecord::Migration
  def change
    remove_column :project_years, :date
    add_column :project_years, :date, :integer
  end
end
