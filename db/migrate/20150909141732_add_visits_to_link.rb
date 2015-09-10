class AddVisitsToLink < ActiveRecord::Migration
  def change
    add_column :links, :visits, :integer, :default => 0
  end
end
