class CreateClicks < ActiveRecord::Migration
  def change
    create_table :clicks do |t|
      t.string :ip_address
      t.string :city
      t.string :country_name

      t.timestamps null: false
    end
  end
end
