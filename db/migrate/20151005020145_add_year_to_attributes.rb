class AddYearToAttributes < ActiveRecord::Migration
  def change
    add_reference :attributes, :year, index: true
    add_foreign_key :attributes, :years
  end
end
