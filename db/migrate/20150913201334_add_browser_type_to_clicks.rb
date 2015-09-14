class AddBrowserTypeToClicks < ActiveRecord::Migration
  def change
    add_column :clicks, :browser_type, :string
    add_column :clicks, :device, :boolean
  end
end
