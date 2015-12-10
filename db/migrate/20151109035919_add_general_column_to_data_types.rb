class AddGeneralColumnToDataTypes < ActiveRecord::Migration
  def change
    add_column :data_types, :general, :boolean
  end
end
