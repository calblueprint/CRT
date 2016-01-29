class AddNullConstraints < ActiveRecord::Migration
  def change
    change_column_null :years, :year, false
    change_column_null :project_years, :project_id, false
    change_column_null :project_years, :year_id, false
    change_column_null :data_values, :data_type_id, false
    change_column_null :data_values, :project_year_id, false
  end
end
