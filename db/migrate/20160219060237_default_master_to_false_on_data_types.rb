class DefaultMasterToFalseOnDataTypes < ActiveRecord::Migration
  def change
    change_column_default :data_types, :master, false
  end
end
