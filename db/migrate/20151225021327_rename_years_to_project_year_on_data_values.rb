class RenameYearsToProjectYearOnDataValues < ActiveRecord::Migration
  def change
    create_table :years do |t|
      t.integer :year

      t.timestamps null: false
    end
    remove_column :data_values, :year_id
    add_reference :data_values, :project_year
    add_reference :project_years, :year
  end
end
