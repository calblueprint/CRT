class AddOrderToDataTypes < ActiveRecord::Migration
  def change
    add_column :data_types, :order, :integer
  end
end
