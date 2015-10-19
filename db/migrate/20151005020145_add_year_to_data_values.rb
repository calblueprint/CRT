class AddYearToDataValues < ActiveRecord::Migration
  def change
    add_reference :data_values, :year, index: true
    add_foreign_key :data_values, :years
  end
end
