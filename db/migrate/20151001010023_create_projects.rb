class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.integer :acres
      t.date :date_closed
      t.decimal :restricted_endowment
      t.decimal :cap_rate
      t.decimal :admin_rate
      t.decimal :total_upfront
      t.integer :years_upfront
      t.date :earnings_begin

      t.timestamps null: false
    end
  end
end
