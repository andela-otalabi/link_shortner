class ChangeColumnType < ActiveRecord::Migration
  def change
    change_column :clicks, :device, :string
  end
end
