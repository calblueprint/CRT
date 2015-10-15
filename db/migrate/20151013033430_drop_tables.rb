class DropTables < ActiveRecord::Migration
  def up
    drop_table :formulas
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
